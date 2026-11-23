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
    localparam [7:0] HALF_PERIOD_LAST = 8'd249;
    localparam [18:0] CONVERSION_WAIT_LAST = 19'd99999;
    localparam [18:0] ERROR_WAIT_LAST = 19'd499999;

    // Estados de la máquina principal I2C
    localparam [4:0] ST_DISPATCH = 5'd0, ST_START_IDLE = 5'd1, ST_START_ASSERT = 5'd2, ST_START_PULL = 5'd3, ST_TX_LOW = 5'd4, ST_TX_HIGH = 5'd5, ST_ACK_LOW = 5'd6, ST_ACK_HIGH = 5'd7, ST_ACK_FALL = 5'd8, ST_RX_LOW = 5'd9, ST_RX_HIGH = 5'd10, ST_MACK_LOW = 5'd11, ST_MACK_HIGH = 5'd12, ST_MACK_FALL = 5'd13, ST_STOP_LOW = 5'd14, ST_STOP_HIGH = 5'd15, ST_STOP_RELEASE = 5'd16, ST_WAIT_ADC = 5'd17, ST_ERROR_WAIT = 5'd18, ST_STORE = 5'd19;

    reg [4:0]  state, step;
    reg [7:0]  half_timer, tx_shift, rx_shift, byte_high, byte_low;
    reg [18:0] wait_timer;
    reg [2:0]  bit_count;
    reg        channel, bus_active, ack_received, sda_meta, sda_sync;

    wire half_tick = (half_timer == HALF_PERIOD_LAST);
    // Conversión de 16bits del ADS1115 a los 12bits diseñados
    wire [11:0] sample12 = byte_high[7] ? 12'd0 : {byte_high[6:0], byte_low[7:3]};

    // Sincronizador de 2 etapas para entrada asíncrona SDA (para evitar metaestabilidad)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sda_meta <= 1'b1; sda_sync <= 1'b1;
        end else begin
            sda_meta <= sda_in; sda_sync <= sda_meta;
        end
    end

    // Máquina de estados I2C principal
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= ST_DISPATCH; step <= 5'd0; half_timer <= 8'd0; wait_timer <= 19'd0; tx_shift <= 8'd0; rx_shift <= 8'd0; byte_high <= 8'd0; byte_low <= 8'd0; bit_count <= 3'd0; channel <= 1'b0; bus_active <= 1'b0; ack_received <= 1'b0; sensor1 <= 12'd0; sensor2 <= 12'd0; valid1 <= 1'b0; valid2 <= 1'b0; error <= 1'b0;
        end else begin
            valid1 <= 1'b0; valid2 <= 1'b0;

            if ((state == ST_DISPATCH) || (state == ST_WAIT_ADC) || (state == ST_ERROR_WAIT) || (state == ST_STORE))
                half_timer <= 8'd0;
            else if (half_tick)
                half_timer <= 8'd0;
            else
                half_timer <= half_timer + 8'd1;

            case (state)
                ST_DISPATCH: begin
                    case (step)
                        5'd0, 5'd7, 5'd10: state <= ST_START_IDLE; // Emisión de START
                        5'd1, 5'd2, 5'd3, 5'd4, 5'd8, 5'd9, 5'd11: begin
                            bit_count <= 3'd0;
                            // Byte a enviar
                            case (step)
                                5'd1, 5'd8: tx_shift <= 8'h90; 
                                5'd2:       tx_shift <= 8'h01; 
                                5'd3:       tx_shift <= channel ? 8'hD3 : 8'hC3;
                                5'd4:       tx_shift <= 8'hE3;
                                5'd9:       tx_shift <= 8'h00; 
                                5'd11:      tx_shift <= 8'h91; 
                                default:    tx_shift <= 8'h00;
                            endcase
                            state <= ST_TX_LOW;
                        end
                        5'd5, 5'd14, 5'd16: state <= ST_STOP_LOW; // Emisión de STOP
                        5'd6: begin wait_timer <= 19'd0; state <= ST_WAIT_ADC; end
                        5'd12, 5'd13: begin bit_count <= 3'd0; rx_shift <= 8'd0; state <= ST_RX_LOW; end // Recepción
                        5'd15: state <= ST_STORE; // Guardado de canal
                        5'd17: begin wait_timer <= 19'd0; state <= ST_ERROR_WAIT; end
                        default: begin step <= 5'd0; state <= ST_DISPATCH; end
                    endcase
                end

                // Implementaciones físicas de bus
                ST_START_IDLE:   if (half_tick) state <= ST_START_ASSERT;
                ST_START_ASSERT: if (half_tick) begin bus_active <= 1'b1; state <= ST_START_PULL; end
                ST_START_PULL:   if (half_tick) begin step <= step + 5'd1; state <= ST_DISPATCH; end
                ST_TX_LOW: if (half_tick) state <= ST_TX_HIGH;
                ST_TX_HIGH: if (half_tick) begin
                    if (bit_count == 3'd7) state <= ST_ACK_LOW;
                    else begin bit_count <= bit_count + 3'd1; tx_shift <= {tx_shift[6:0], 1'b0}; state <= ST_TX_LOW; end
                end
                ST_ACK_LOW: if (half_tick) state <= ST_ACK_HIGH;
                ST_ACK_HIGH: if (half_tick) begin ack_received <= ~sda_sync; if (sda_sync) error <= 1'b1; state <= ST_ACK_FALL; end
                ST_ACK_FALL: begin step <= ack_received ? (step + 5'd1) : 5'd16; state <= ST_DISPATCH; end
                ST_RX_LOW: if (half_tick) state <= ST_RX_HIGH;
                ST_RX_HIGH: if (half_tick) begin
                    rx_shift <= {rx_shift[6:0], sda_sync};
                    if (bit_count == 3'd7) state <= ST_MACK_LOW;
                    else begin bit_count <= bit_count + 3'd1; state <= ST_RX_LOW; end
                end
                ST_MACK_LOW:  if (half_tick) state <= ST_MACK_HIGH;
                ST_MACK_HIGH: if (half_tick) state <= ST_MACK_FALL;
                ST_MACK_FALL: begin
                    if (step == 5'd12) byte_high <= rx_shift; else byte_low <= rx_shift;
                    step <= step + 5'd1; state <= ST_DISPATCH;
                end
                ST_STOP_LOW: if (half_tick) state <= ST_STOP_HIGH;
                ST_STOP_HIGH: if (half_tick) state <= ST_STOP_RELEASE;
                ST_STOP_RELEASE: if (half_tick) begin bus_active <= 1'b0; step <= step + 5'd1; state <= ST_DISPATCH; end
                ST_WAIT_ADC: begin
                    if (wait_timer == CONVERSION_WAIT_LAST) begin wait_timer <= 19'd0; step <= 5'd7; state <= ST_DISPATCH; end 
                    else wait_timer <= wait_timer + 19'd1;
                end
                ST_ERROR_WAIT: begin
                    if (wait_timer == ERROR_WAIT_LAST) begin wait_timer <= 19'd0; step <= 5'd0; state <= ST_DISPATCH; end 
                    else wait_timer <= wait_timer + 19'd1;
                end
                ST_STORE: begin
                    if (channel == 1'b0) begin sensor1 <= sample12; valid1 <= 1'b1; end 
                    else begin sensor2 <= sample12; valid2 <= 1'b1; end
                    channel <= ~channel; error <= 1'b0; step <= 5'd0; state <= ST_DISPATCH;
                end
                default: begin state <= ST_DISPATCH; step <= 5'd0; bus_active <= 1'b0; end
            endcase
        end
    end

    always @(*) begin
        scl_drive_low = 1'b0; sda_drive_low = 1'b0;
        case (state)
            ST_DISPATCH: scl_drive_low = bus_active;
            ST_START_IDLE: begin end
            ST_START_ASSERT: sda_drive_low = 1'b1;
            ST_START_PULL: begin scl_drive_low = 1'b1; sda_drive_low = 1'b1; end
            ST_TX_LOW: begin scl_drive_low = 1'b1; sda_drive_low = ~tx_shift[7]; end
            ST_TX_HIGH: sda_drive_low = ~tx_shift[7];
            ST_ACK_LOW, ST_ACK_FALL, ST_RX_LOW: scl_drive_low = 1'b1;
            ST_ACK_HIGH, ST_RX_HIGH: begin end
            ST_MACK_LOW, ST_MACK_FALL: begin scl_drive_low = 1'b1; sda_drive_low = (step == 5'd12); end
            ST_MACK_HIGH: sda_drive_low = (step == 5'd12);
            ST_STOP_LOW: begin scl_drive_low = 1'b1; sda_drive_low = 1'b1; end
            ST_STOP_HIGH: sda_drive_low = 1'b1;
            ST_STOP_RELEASE: begin end
            default: begin end
        endcase
    end
endmodule
