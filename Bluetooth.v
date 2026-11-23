module DIG_D_FF_1bit
#(
    parameter Default = 0
)
(
   input D,
   input C,
   output Q,
   output \~Q 
);
    reg state;

    assign Q = state;
    assign \~Q  = ~state;

    always @ (posedge C) begin
        state <= D;
    end

    initial begin
        state = Default;
    end
endmodule

module DIG_Register_BUS #(
    parameter Bits = 1
)
(
    input C,
    input en,
    input [(Bits - 1):0]D,
    output [(Bits - 1):0]Q
);
    reg [(Bits - 1):0] state = 'h0;
    assign Q = state;
    always @ (posedge C) begin
        if (en)
            state <= D;
   end
endmodule

module Mux_2x1_NBits #(
    parameter Bits = 2
)
(
    input [0:0] sel,
    input [(Bits - 1):0] in_0,
    input [(Bits - 1):0] in_1,
    output reg [(Bits - 1):0] out
);
    always @ (*) begin
        case (sel)
            1'h0: out = in_0;
            1'h1: out = in_1;
            default:
                out = 'h0;
        endcase
    end
endmodule

module CompUnsigned #(
    parameter Bits = 1
)
(
    input [(Bits -1):0] a,
    input [(Bits -1):0] b,
    output \> ,
    output \= ,
    output \< 
);
    assign \>  = a > b;
    assign \=  = a == b;
    assign \<  = a < b;
endmodule

module DIG_Counter_Nbit
#(
    parameter Bits = 2
)
(
    output [(Bits-1):0] out,
    output ovf,
    input C,
    input en,
    input clr
);
    reg [(Bits-1):0] count;
    always @ (posedge C) begin
        if (clr)
          count <= 'h0;
        else if (en)
          count <= count + 1'b1;
    end
    assign out = count;
    assign ovf = en? &count : 1'b0;
    initial begin
        count = 'h0;
    end
endmodule

module Mux_2x1 (
    input [0:0] sel, input in_0, input in_1,
    output reg out
);
    always @ (*) begin
        case (sel)
            1'h0: out = in_0; 1'h1: out = in_1;
            default: out = 'h0;
        endcase
    end
endmodule

module TEMPORIZADOR_ENVIO (
  input RESET_GENERAL,
  input CLK_50MHz,
  output START_PAQUETE
);
  wire s0;
  wire [22:0] s1;
  wire FIN_ENVIO;
  assign s0 = (RESET_GENERAL | FIN_ENVIO);
  assign START_PAQUETE = (FIN_ENVIO & ~ RESET_GENERAL);
  DIG_Counter_Nbit #(.Bits(23)) DIG_Counter_Nbit_i0 (.en( 1'b1 ), .C( CLK_50MHz ), .clr( s0 ), .out( s1 ));
  CompUnsigned #(.Bits(23)) CompUnsigned_i1 (.a( s1 ), .b( 23'b10011000100101100111111 ), .\= ( FIN_ENVIO ));
endmodule

module REGISTROS_TX (
  input RESET_GENERAL, input [11:0] DATO_PRINCIPAL, input CAPTURAR_PAQUETE, input CLK_50MHz,
  output [11:0] DATO_GUARDADO
);
  wire [11:0] s0; wire s1;
  Mux_2x1_NBits #(.Bits(12)) Mux_2x1_NBits_i0 (.sel( RESET_GENERAL ), .in_0( DATO_PRINCIPAL ), .in_1( 12'b0 ), .out( s0 ));
  assign s1 = (CAPTURAR_PAQUETE | RESET_GENERAL);
  DIG_Register_BUS #(.Bits(12)) DIG_Register_BUS_i1 (.D( s0 ), .C( CLK_50MHz ), .en( s1 ), .Q( DATO_GUARDADO ));
endmodule

module Decoder3 (
    output out_0, output out_1, output out_2, output out_3, output out_4, output out_5, output out_6, output out_7,
    input [2:0] sel
);
    assign out_0 = (sel == 3'h0); assign out_1 = (sel == 3'h1); assign out_2 = (sel == 3'h2); assign out_3 = (sel == 3'h3); assign out_4 = (sel == 3'h4); assign out_5 = (sel == 3'h5); assign out_6 = (sel == 3'h6); assign out_7 = (sel == 3'h7);
endmodule

module CONTROL_PAQUETES (
  input RESET_GENERAL, input START_PAQUETE, input UART_BUSY, input UART_DONE, input [7:0] BYTE_ALTO, input [7:0] BYTE_BAJO, input CLK_50MHz,
  output SEL_BYTE, output PAQUETE_DONE, output PAQUETE_BUSY, output CAPTURAR_PAQUETE, output START_TX, output [7:0] DATA_TX
);
  wire [2:0] \SIG_ESTADO[2:0] ;
  wire [2:0] s0;
  wire S_IDLE, S_ENV_ALTO, S_ESP_ALTO, S_ENV_BAJO, S_ESP_BAJO, S_FIN;
  wire NOT_RESET, NOT_BUSY, NOT_DONE, A1, A9, s1, SEL_BYTE_temp;
  
  assign NOT_RESET = ~ RESET_GENERAL;
  assign NOT_BUSY = ~ UART_BUSY;
  assign NOT_DONE = ~ UART_DONE;
  assign A1 = (S_IDLE & START_PAQUETE & NOT_BUSY);
  assign A9 = (S_ESP_BAJO & UART_DONE);
  assign s1 = ((S_ESP_ALTO & UART_DONE) | (S_ENV_BAJO & UART_BUSY));
  
  // Transiciones de estado
  assign \SIG_ESTADO[2:0] [0] = (NOT_RESET & ((A1 | (S_ENV_ALTO & UART_BUSY)) | s1 | A9));
  assign \SIG_ESTADO[2:0] [1] = ((((S_ENV_ALTO & NOT_BUSY) | (S_ESP_ALTO & NOT_DONE)) | s1) & NOT_RESET);
  assign \SIG_ESTADO[2:0] [2] = ((((S_ENV_BAJO & NOT_BUSY) | (S_ESP_BAJO & NOT_DONE)) | A9) & NOT_RESET);
  
  Mux_2x1_NBits #(.Bits(8)) Mux_2x1_NBits_i0 (.sel( SEL_BYTE_temp ), .in_0( BYTE_ALTO ), .in_1( BYTE_BAJO ), .out( DATA_TX ));
  
  assign START_TX = ((S_ENV_ALTO | S_ENV_BAJO) & NOT_BUSY & NOT_RESET);
  assign CAPTURAR_PAQUETE = (A1 & NOT_RESET);
  assign PAQUETE_DONE = (S_FIN & NOT_RESET);
  
  DIG_Register_BUS #(.Bits(3)) DIG_Register_BUS_i1 (.D( \SIG_ESTADO[2:0]  ), .C( CLK_50MHz ), .en( 1'b1 ), .Q( s0 ));
  Decoder3 Decoder3_i2 (.sel( s0 ), .out_0( S_IDLE ), .out_1( S_ENV_ALTO ), .out_2( S_ESP_ALTO ), .out_3( S_ENV_BAJO ), .out_4( S_ESP_BAJO ), .out_5( S_FIN ));
  
  assign SEL_BYTE_temp = (S_ENV_BAJO | S_ESP_BAJO);
  assign PAQUETE_BUSY = (S_ENV_ALTO | S_ESP_ALTO | S_ENV_BAJO | S_ESP_BAJO);
  assign SEL_BYTE = SEL_BYTE_temp;
endmodule

module UART_COMPLETO (
  input RESET_GENERAL, input START_TX, input [7:0] DATA_TX, input CLK_50MHz,
  output UART_TX_OUT, output UART_BUSY, output UART_DONE, output BAUD_RUN
);
  wire s0; wire [12:0] s1; wire s2; wire BAUD_RUN_temp; wire s3; wire TICK_BAUD;
  wire [2:0] s4, s5; wire S_IDLE, S_START, S_DATA, S_STOP; wire s6, s7; wire [2:0] s8;
  wire s9, NOT_TICK, s10; wire [7:0] s11; wire s12; wire [7:0] s13, s14; wire s15;
  
  assign s3 = ~ RESET_GENERAL;
  assign s0 = (s2 | RESET_GENERAL | ~ BAUD_RUN_temp);
  assign TICK_BAUD = (s3 & s2 & BAUD_RUN_temp);
  assign s6 = (~ RESET_GENERAL & S_DATA & TICK_BAUD);
  assign s7 = (RESET_GENERAL | S_IDLE);
  
  // Máquina de estados UART
  assign s4[0] = (((S_IDLE & START_TX) | (S_DATA & s9 & TICK_BAUD) | (S_START & NOT_TICK) | s10) & s3);
  assign s4[1] = (s3 & ((TICK_BAUD & S_START) | S_DATA | s10));
  assign s4[2] = (s3 & (TICK_BAUD & S_STOP));
  
  Mux_2x1_NBits #(.Bits(8)) Mux_2x1_NBits_i0 (.sel( s15 ), .in_0( s14 ), .in_1( DATA_TX ), .out( s11 ));
  assign s15 = (S_IDLE & START_TX & s3);
  
  DIG_Counter_Nbit #(.Bits(13)) DIG_Counter_Nbit_i1 (.en( 1'b1 ), .C( CLK_50MHz ), .clr( s0 ), .out( s1 ));
  DIG_Register_BUS #(.Bits(3)) DIG_Register_BUS_i2 (.D( s4 ), .C( CLK_50MHz ), .en( 1'b1 ), .Q( s5 ));
  DIG_Counter_Nbit #(.Bits(3)) DIG_Counter_Nbit_i3 (.en( s6 ), .C( CLK_50MHz ), .clr( s7 ), .out( s8 ));
  
  assign NOT_TICK = ~ TICK_BAUD;
  assign s12 = (s15 | s6);
  CompUnsigned #(.Bits(13)) CompUnsigned_i4 (.a( s1 ), .b( 13'b1010001010111 ), .\= ( s2 ));
  
  Decoder3 Decoder3_i5 (.sel( s5 ), .out_0( S_IDLE ), .out_1( S_START ), .out_2( S_DATA ), .out_3( S_STOP ), .out_4( UART_DONE ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i6 (.a( s8 ), .b( 3'b111 ), .\= ( s9 ));
  
  DIG_Register_BUS #(.Bits(8)) DIG_Register_BUS_i7 (.D( s11 ), .C( CLK_50MHz ), .en( s12 ), .Q( s13 ));
  
  assign s10 = (S_STOP & NOT_TICK);
  assign s14[6:0] = s13[7:1];
  assign s14[7] = 1'b1;
  
  // Salida física de la UART
  assign UART_TX_OUT = ((s13[0] | ~ S_DATA) & ~ S_START);
  assign BAUD_RUN_temp = (S_START | S_DATA | S_STOP);
  assign UART_BUSY = BAUD_RUN_temp;
  assign BAUD_RUN = BAUD_RUN_temp;
endmodule

module SEPARADOR_12_A_8 (
  input [11:0] DATO_GUARDADO, output [7:0] BYTE_BAJO, output [7:0] BYTE_ALTO
);
  assign BYTE_ALTO[3:0] = DATO_GUARDADO[11:8];
  assign BYTE_ALTO[7:4] = 4'b0;
  assign BYTE_BAJO = DATO_GUARDADO[7:0];
endmodule

module Mod_Blue (
  input RESET_N, input VALOR_MAX, input [11:0] s_P, input [11:0] Dato_max, input clk,
  output UART_TX_OUT
);
  wire [11:0] s0; wire CAPTURAR_PAQUETES; wire [11:0] s1; wire [7:0] s2; wire [7:0] BYTE_ALTO;
  wire s3, UART_BUSY, UART_DONE, PAQUETE_DONE, PAQUETE_BUSY, START_TX;
  wire [7:0] BYTE_ALTO_FINAL, DATA_TX; wire s4, s5, s6, s7, s8, s9, s10; wire [7:0] s11;
  
  TEMPORIZADOR_ENVIO TEMPORIZADOR_ENVIO_i0 (.RESET_GENERAL( RESET_N ), .CLK_50MHz( clk ), .START_PAQUETE( s4 ));
  assign s7 = ~ RESET_N;
  
  REGISTROS_TX REGISTROS_TX_i1 (.RESET_GENERAL( RESET_N ), .DATO_PRINCIPAL( s0 ), .CAPTURAR_PAQUETE( CAPTURAR_PAQUETES ), .CLK_50MHz( clk ), .DATO_GUARDADO( s1 ));
  CONTROL_PAQUETES CONTROL_PAQUETES_i2 (.RESET_GENERAL( RESET_N ), .START_PAQUETE( s3 ), .UART_BUSY( UART_BUSY ), .UART_DONE( UART_DONE ), .BYTE_ALTO( BYTE_ALTO_FINAL ), .BYTE_BAJO( s2 ), .CLK_50MHz( clk ), .PAQUETE_DONE( PAQUETE_DONE ), .PAQUETE_BUSY( PAQUETE_BUSY ), .CAPTURAR_PAQUETE( CAPTURAR_PAQUETES ), .START_TX( START_TX ), .DATA_TX( DATA_TX ));
  UART_COMPLETO UART_COMPLETO_i3 (.RESET_GENERAL( RESET_N ), .START_TX( START_TX ), .DATA_TX( DATA_TX ), .CLK_50MHz( clk ), .UART_TX_OUT( UART_TX_OUT ), .UART_BUSY( UART_BUSY ), .UART_DONE( UART_DONE ));
  
  Mux_2x1_NBits #(.Bits(12)) Mux_2x1_NBits_i4 (.sel( s5 ), .in_0( s_P ), .in_1( Dato_max ), .out( s0 ));
  assign s6 = (((s5 & ~ (s5 & CAPTURAR_PAQUETES)) | VALOR_MAX) & s7);
  assign s10 = (s7 & s9);
  assign s3 = (s4 | (s5 & ~ PAQUETE_DONE & ~ PAQUETE_BUSY));
  
  SEPARADOR_12_A_8 SEPARADOR_12_A_8_i5 (.DATO_GUARDADO( s1 ), .BYTE_BAJO( s2 ), .BYTE_ALTO( BYTE_ALTO ));
  DIG_D_FF_1bit #(.Default(0)) DIG_D_FF_1bit_i6 (.D( s6 ), .C( clk ), .Q( s5 ));
  DIG_D_FF_1bit #(.Default(0)) DIG_D_FF_1bit_i7 (.D( s10 ), .C( clk ), .Q( s8 )); 
  
  Mux_2x1 Mux_2x1_i8 (.sel( CAPTURAR_PAQUETES ), .in_0( s8 ), .in_1( s5 ), .out( s9 ));
  assign s11[6:0] = 7'b0;
  assign s11[7] = s8;
  
  assign BYTE_ALTO_FINAL = (s11 | BYTE_ALTO);
endmodule
