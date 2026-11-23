// Archivo separado de ProyectoMYO_Pru1.v para documentacion modular.
// La definicion original del modulo se conserva sin modificar.
// Controlador I2C para ADS1115 - Cyclone IV / Digital (H. Neemann)
// Reloj FPGA: 50 MHz. Bus I2C: aproximadamente 100 kHz.
// ADS1115: ADDR a GND (direccion de 7 bits 0x48).
// A0: sensor principal; A1: sensor secundario.
// Configuracion: single-shot, PGA +/-4.096 V, 860 SPS, comparador deshabilitado.
// Salidas: 12 bits positivos de las lecturas de 16 bits (bits [14:3]).
//
// IMPORTANTE: Los pines I2C son de drenador abierto.
//   sda_drive_low=1 -> conducir SDA a 0; =0 -> liberar SDA.
//   scl_drive_low=1 -> conducir SCL a 0; =0 -> liberar SCL.
// El bus SDA se lee a traves de sda_in.
// Integrar los buffers triestado fuera de este modulo, en el nivel superior.
//
// No conecta la senal Pulso de procesamiento de 1 ms: funciona independiente.
module ADS1115_I2C (
    input  wire        clk,
    input  wire        rst,
    input  wire        sda_in,
    output reg  [11:0] sensor1,
    output reg  [11:0] sensor2,
    output reg         valid1,
    output reg         valid2,
    output reg         sda_drive_low,
    output reg         scl_drive_low,
    output reg         error
);
    // Cada semiciclo de SCL dura 250 ciclos de reloj: 5 us a 50 MHz.
    localparam [7:0] HALF_PERIOD_LAST = 8'd249;
    // Esperar 2 ms tras configurar single-shot (~1,163 ms de conversion a 860 SPS).
    localparam [18:0] CONVERSION_WAIT_LAST = 19'd99999;
    // Esperar 10 ms antes de reintentar en caso de NACK.
    localparam [18:0] ERROR_WAIT_LAST = 19'd499999;

    localparam [4:0]
        ST_DISPATCH      = 5'd0,
        ST_START_IDLE    = 5'd1,
        ST_START_ASSERT  = 5'd2,
        ST_START_PULL    = 5'd3,
        ST_TX_LOW        = 5'd4,
        ST_TX_HIGH       = 5'd5,
        ST_ACK_LOW       = 5'd6,
        ST_ACK_HIGH      = 5'd7,
        ST_ACK_FALL      = 5'd8,
        ST_RX_LOW        = 5'd9,
        ST_RX_HIGH       = 5'd10,
        ST_MACK_LOW      = 5'd11,
        ST_MACK_HIGH     = 5'd12,
        ST_MACK_FALL     = 5'd13,
        ST_STOP_LOW      = 5'd14,
        ST_STOP_HIGH     = 5'd15,
        ST_STOP_RELEASE  = 5'd16,
        ST_WAIT_ADC      = 5'd17,
        ST_ERROR_WAIT    = 5'd18,
        ST_STORE         = 5'd19;

    // Paso de transaccion:
    //  0 START; 1 TX 90; 2 TX 01; 3 TX C3/D3; 4 TX E3;
    //  5 STOP; 6 esperar conversion;
    //  7 START; 8 TX 90; 9 TX 00; 10 START repetido;
    // 11 TX 91; 12 RX byte alto + ACK; 13 RX byte bajo + NACK;
    // 14 STOP; 15 guardar y cambiar canal;
    // 16 STOP si hubo NACK; 17 esperar y reintentar.
    reg [4:0]  state;
    reg [4:0]  step;
    reg [7:0]  half_timer;
    reg [18:0] wait_timer;
    reg [7:0]  tx_shift;
    reg [7:0]  rx_shift;
    reg [7:0]  byte_high;
    reg [7:0]  byte_low;
    reg [2:0]  bit_count;
    reg        channel;          // 0 -> A0; 1 -> A1
    reg        bus_active;       // 1 mientras hay una transaccion abierta
    reg        ack_received;
    reg        sda_meta, sda_sync;

    wire half_tick = (half_timer == HALF_PERIOD_LAST);
    wire [11:0] sample12 = byte_high[7] ? 12'd0
                                          : {byte_high[6:0], byte_low[7:3]};

    // El dato I2C entra asincronicamente respecto al reloj FPGA.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sda_meta <= 1'b1;
            sda_sync <= 1'b1;
        end else begin
            sda_meta <= sda_in;
            sda_sync <= sda_meta;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= ST_DISPATCH;
            step         <= 5'd0;
            half_timer   <= 8'd0;
            wait_timer   <= 19'd0;
            tx_shift     <= 8'd0;
            rx_shift     <= 8'd0;
            byte_high    <= 8'd0;
            byte_low     <= 8'd0;
            bit_count    <= 3'd0;
            channel      <= 1'b0;
            bus_active   <= 1'b0;
            ack_received <= 1'b0;
            sensor1      <= 12'd0;
            sensor2      <= 12'd0;
            valid1       <= 1'b0;
            valid2       <= 1'b0;
            error        <= 1'b0;
        end else begin
            valid1 <= 1'b0;
            valid2 <= 1'b0;

            // El temporizador se reinicia al entrar a cada fase.
            if ((state == ST_DISPATCH) || (state == ST_WAIT_ADC) ||
                (state == ST_ERROR_WAIT) || (state == ST_STORE))
                half_timer <= 8'd0;
            else if (half_tick)
                half_timer <= 8'd0;
            else
                half_timer <= half_timer + 8'd1;

            case (state)
                ST_DISPATCH: begin
                    case (step)
                        5'd0, 5'd7, 5'd10: begin
                            state <= ST_START_IDLE;
                        end

                        5'd1, 5'd2, 5'd3, 5'd4,
                        5'd8, 5'd9, 5'd11: begin
                            bit_count <= 3'd0;
                            case (step)
                                5'd1, 5'd8: tx_shift <= 8'h90; // 0x48 + W
                                5'd2:       tx_shift <= 8'h01; // Puntero Config
                                5'd3:       tx_shift <= channel ? 8'hD3 : 8'hC3;
                                5'd4:       tx_shift <= 8'hE3;
                                5'd9:       tx_shift <= 8'h00; // Puntero Conversion
                                5'd11:      tx_shift <= 8'h91; // 0x48 + R
                                default:    tx_shift <= 8'h00;
                            endcase
                            state <= ST_TX_LOW;
                        end

                        5'd5, 5'd14, 5'd16: begin
                            state <= ST_STOP_LOW;
                        end

                        5'd6: begin
                            wait_timer <= 19'd0;
                            state <= ST_WAIT_ADC;
                        end

                        5'd12, 5'd13: begin
                            bit_count <= 3'd0;
                            rx_shift <= 8'd0;
                            state <= ST_RX_LOW;
                        end

                        5'd15: state <= ST_STORE;

                        5'd17: begin
                            wait_timer <= 19'd0;
                            state <= ST_ERROR_WAIT;
                        end

                        default: begin
                            step <= 5'd0;
                            state <= ST_DISPATCH;
                        end
                    endcase
                end

                // START: SDA baja mientras SCL permanece alto.
                ST_START_IDLE:   if (half_tick) state <= ST_START_ASSERT;
                ST_START_ASSERT: if (half_tick) begin
                    bus_active <= 1'b1;
                    state <= ST_START_PULL;
                end
                ST_START_PULL:   if (half_tick) begin
                    step <= step + 5'd1;
                    state <= ST_DISPATCH;
                end

                // TX: un bit, mas significativo primero, por cada pulso SCL.
                ST_TX_LOW: if (half_tick) state <= ST_TX_HIGH;
                ST_TX_HIGH: if (half_tick) begin
                    if (bit_count == 3'd7)
                        state <= ST_ACK_LOW;
                    else begin
                        bit_count <= bit_count + 3'd1;
                        tx_shift <= {tx_shift[6:0], 1'b0};
                        state <= ST_TX_LOW;
                    end
                end

                // Noveno pulso: el ADS1115 debe llevar SDA a cero (ACK).
                ST_ACK_LOW: if (half_tick) state <= ST_ACK_HIGH;
                ST_ACK_HIGH: if (half_tick) begin
                    ack_received <= ~sda_sync;
                    if (sda_sync) error <= 1'b1;
                    state <= ST_ACK_FALL;
                end
                ST_ACK_FALL: begin
                    step <= ack_received ? (step + 5'd1) : 5'd16;
                    state <= ST_DISPATCH;
                end

                // RX: el ADS1115 transmite primero el byte alto.
                ST_RX_LOW: if (half_tick) state <= ST_RX_HIGH;
                ST_RX_HIGH: if (half_tick) begin
                    rx_shift <= {rx_shift[6:0], sda_sync};
                    if (bit_count == 3'd7)
                        state <= ST_MACK_LOW;
                    else begin
                        bit_count <= bit_count + 3'd1;
                        state <= ST_RX_LOW;
                    end
                end

                // Tras byte alto enviamos ACK; tras byte bajo, NACK.
                ST_MACK_LOW:  if (half_tick) state <= ST_MACK_HIGH;
                ST_MACK_HIGH: if (half_tick) state <= ST_MACK_FALL;
                ST_MACK_FALL: begin
                    if (step == 5'd12) byte_high <= rx_shift;
                    else              byte_low <= rx_shift;
                    step <= step + 5'd1;
                    state <= ST_DISPATCH;
                end

                // STOP: con SCL alto, liberar SDA para que suba.
                ST_STOP_LOW: if (half_tick) state <= ST_STOP_HIGH;
                ST_STOP_HIGH: if (half_tick) state <= ST_STOP_RELEASE;
                ST_STOP_RELEASE: if (half_tick) begin
                    bus_active <= 1'b0;
                    step <= step + 5'd1;
                    state <= ST_DISPATCH;
                end

                ST_WAIT_ADC: begin
                    if (wait_timer == CONVERSION_WAIT_LAST) begin
                        wait_timer <= 19'd0;
                        step <= 5'd7;
                        state <= ST_DISPATCH;
                    end else
                        wait_timer <= wait_timer + 19'd1;
                end

                ST_ERROR_WAIT: begin
                    if (wait_timer == ERROR_WAIT_LAST) begin
                        wait_timer <= 19'd0;
                        step <= 5'd0;
                        state <= ST_DISPATCH;
                    end else
                        wait_timer <= wait_timer + 19'd1;
                end

                ST_STORE: begin
                    if (channel == 1'b0) begin
                        sensor1 <= sample12;
                        valid1 <= 1'b1;
                    end else begin
                        sensor2 <= sample12;
                        valid2 <= 1'b1;
                    end
                    channel <= ~channel;
                    error <= 1'b0;
                    step <= 5'd0;
                    state <= ST_DISPATCH;
                end

                default: begin
                    state <= ST_DISPATCH;
                    step <= 5'd0;
                    bus_active <= 1'b0;
                end
            endcase
        end
    end

    // 1 = conducir a cero; 0 = liberar el pin I2C.
    // Ninguna salida debe forzar un '1' fisico en SDA/SCL.
    always @(*) begin
        scl_drive_low = 1'b0;
        sda_drive_low = 1'b0;
        case (state)
            ST_DISPATCH: begin
                scl_drive_low = bus_active;
            end
            ST_START_IDLE: begin
                // SCL y SDA altos (libres) antes de START/reSTART.
            end
            ST_START_ASSERT: begin
                sda_drive_low = 1'b1;
            end
            ST_START_PULL: begin
                scl_drive_low = 1'b1;
                sda_drive_low = 1'b1;
            end
            ST_TX_LOW: begin
                scl_drive_low = 1'b1;
                sda_drive_low = ~tx_shift[7];
            end
            ST_TX_HIGH: begin
                sda_drive_low = ~tx_shift[7];
            end
            ST_ACK_LOW, ST_ACK_FALL, ST_RX_LOW: begin
                scl_drive_low = 1'b1;
            end
            ST_ACK_HIGH, ST_RX_HIGH: begin
                // El esclavo tiene el control de SDA.
            end
            ST_MACK_LOW, ST_MACK_FALL: begin
                scl_drive_low = 1'b1;
                sda_drive_low = (step == 5'd12); // ACK = tirar SDA a 0
            end
            ST_MACK_HIGH: begin
                sda_drive_low = (step == 5'd12);
            end
            ST_STOP_LOW: begin
                scl_drive_low = 1'b1;
                sda_drive_low = 1'b1;
            end
            ST_STOP_HIGH: begin
                sda_drive_low = 1'b1;
            end
            ST_STOP_RELEASE: begin
                // SCL alto, SDA sube: STOP.
            end
            default: begin
                // En espera y durante recuperacion, liberar bus.
            end
        endcase
    end
endmodule
