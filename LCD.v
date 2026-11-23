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

module Mod_div_8 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] q,
    output wire [7:0] r
);
    assign q = (b != 8'd0) ? (a / b) : 8'd0;
    assign r = (b != 8'd0) ? (a % b) : 8'd0;
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

module Mux_16x1_NBits #(parameter Bits = 2) (
    input [3:0] sel, input [(Bits - 1):0] in_0, input [(Bits - 1):0] in_1, input [(Bits - 1):0] in_2, input [(Bits - 1):0] in_3, input [(Bits - 1):0] in_4, input [(Bits - 1):0] in_5, input [(Bits - 1):0] in_6, input [(Bits - 1):0] in_7, input [(Bits - 1):0] in_8, input [(Bits - 1):0] in_9, input [(Bits - 1):0] in_10, input [(Bits - 1):0] in_11, input [(Bits - 1):0] in_12, input [(Bits - 1):0] in_13, input [(Bits - 1):0] in_14, input [(Bits - 1):0] in_15,
    output reg [(Bits - 1):0] out
);
    always @ (*) begin
        case (sel)
            4'h0: out = in_0; 4'h1: out = in_1; 4'h2: out = in_2; 4'h3: out = in_3; 4'h4: out = in_4; 4'h5: out = in_5; 4'h6: out = in_6; 4'h7: out = in_7; 4'h8: out = in_8; 4'h9: out = in_9; 4'ha: out = in_10; 4'hb: out = in_11; 4'hc: out = in_12; 4'hd: out = in_13; 4'he: out = in_14; 4'hf: out = in_15;
            default: out = 'h0;
        endcase
    end
endmodule

module Mux_8x1_NBits #(parameter Bits = 2) (
    input [2:0] sel, input [(Bits - 1):0] in_0, input [(Bits - 1):0] in_1, input [(Bits - 1):0] in_2, input [(Bits - 1):0] in_3, input [(Bits - 1):0] in_4, input [(Bits - 1):0] in_5, input [(Bits - 1):0] in_6, input [(Bits - 1):0] in_7,
    output reg [(Bits - 1):0] out
);
    always @ (*) begin
        case (sel)
            3'h0: out = in_0; 3'h1: out = in_1; 3'h2: out = in_2; 3'h3: out = in_3; 3'h4: out = in_4; 3'h5: out = in_5; 3'h6: out = in_6; 3'h7: out = in_7;
            default: out = 'h0;
        endcase
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

module DIG_Register
(
    input C,
    input en,
    input D,
    output Q
);
    reg  state = 'h0;
    assign Q = state;
    always @ (posedge C) begin
        if (en)
            state <= D;
   end
endmodule

module DIG_Add
#(
    parameter Bits = 1
)
(
    input [(Bits-1):0] a,
    input [(Bits-1):0] b,
    input c_i,
    output [(Bits - 1):0] s,
    output c_o
);
   wire [Bits:0] temp;
   assign temp = a + b + c_i;
   assign s = temp [(Bits-1):0];
   assign c_o = temp[Bits];
endmodule

module Mux_4x1 (
    input [1:0] sel, input in_0, input in_1, input in_2, input in_3,
    output reg out
);
    always @ (*) begin
        case (sel)
            2'h0: out = in_0; 2'h1: out = in_1; 2'h2: out = in_2; 2'h3: out = in_3;
            default: out = 'h0;
        endcase
    end
endmodule

module Mod_LCD_F (
  input clk,
  input rst,
  input In_Com,
  input In_Norm,
  input In_Pre,
  input In_Lim,
  input In_Exc,
  input [7:0] Prc,
  input [4:0] LCD16,
  output E,
  output RS,
  output Rw,
  output D4,
  output D5,
  output D6,
  output D7
);
  wire s0;
  wire [3:0] LCD;
  wire [4:0] s1;
  wire s2;
  wire [7:0] Fil1;
  wire [7:0] s3;
  wire [7:0] s4;
  wire [3:0] s5;
  wire [7:0] s6;
  wire [7:0] s7;
  wire [7:0] s8;
  wire [7:0] U;
  wire s9;
  wire [7:0] C;
  wire s10;
  wire [7:0] D;
  wire s11;
  wire [3:0] POS_LCD;
  wire [7:0] Pul;
  wire [7:0] \Nor ;
  wire [7:0] Pre;
  wire [7:0] Lim;
  wire [7:0] Exc;
  wire [7:0] Com;
  wire [2:0] s12;
  wire [7:0] Fil2;
  wire Fil_LCD;
  wire [7:0] Out_LCD;
  wire [7:0] s13;
  wire [3:0] s14;
  wire [3:0] s15;
  wire s16;
  wire [3:0] s17;
  wire [7:0] Dat_TX;
  wire CD;
  wire [2:0] s18;
  wire [2:0] s19;
  wire s20;
  wire s21;
  wire s22;
  wire s23;
  wire s24;
  wire s25;
  wire s26;
  wire [11:0] s27;
  wire s28;
  wire FinT;
  wire s29;
  wire START_tx;
  wire s30;
  wire [2:0] s31;
  wire [2:0] s32;
  wire Donetx;
  wire [2:0] s33;
  wire RS_TX;
  wire Mant1;
  wire Sol_Nibble_TX;
  wire s34;
  wire s35;
  wire [2:0] s36;
  wire Sig_Ini;
  wire [3:0] PasoIni;
  wire [7:0] Dat_Ini;
  wire s37;
  wire [2:0] s38;
  wire [2:0] s39;
  wire s40;
  wire Start_int;
  wire Esp_LCD;
  wire s41;
  wire List_in;
  wire UltPas;
  wire s42;
  wire s43;
  wire [21:0] s44;
  wire s45;
  wire s46;
  wire s47;
  wire s48;
  wire [1:0] s49;
  wire Fin_Esp;
  wire [2:0] s50;
  wire [2:0] s51;
  wire [2:0] s52;
  wire [2:0] s53;
  wire [2:0] s54;
  wire s55;
  wire s56;
  wire s57;
  wire Avan_Pos_LCD;
  wire s58;
  wire s59;
  wire Cam_Fila;
  wire NO_Fil_LCD;
  wire [7:0] s60;
  wire Env_Dir;
  wire [7:0] s61;
  wire [2:0] s62;
  wire [2:0] Est_Pant;
  wire s_Rs;
  wire Start_Pant;
  wire [2:0] s63;
  wire [2:0] s64;
  wire [2:0] s65;
  wire [2:0] s66;
  wire [2:0] s67;
  wire Ult_Pos;
  wire [7:0] s68;

  // Únicamente escritura.
  assign Rw = 1'b0;

  // Lógica de prioridad para elegir el mensaje de estado en pantalla.
  assign s12[0] = (In_Com | In_Norm | In_Lim);
  assign s12[1] = ((In_Pre | In_Lim) & ~ In_Com);
  assign s12[2] = (In_Com | In_Exc);

  // Binario a BCD para el porcentaje de esfuerzo.
  Mod_div_8 Mod_div_8_i0 (
    .a( Prc ),
    .b( 8'b1100100 ),
    .q( s3 ),
    .r( s68 )
  );
  assign s7[3:0] = s3[3:0];
  assign s7[7:4] = 4'b11; 
  
  Mod_div_8 Mod_div_8_i1 (
    .a( s68 ),
    .b( 8'b1010 ),
    .q( s4 ),
    .r( s6 )
  );
  assign s9 = s3[0];
  assign U[3:0] = s6[3:0];
  assign U[7:4] = 4'b11;

  Mux_2x1_NBits #(.Bits(8)) Mux_2x1_NBits_i2 (
    .sel( s9 ), .in_0( 8'b100000 ), .in_1( s7 ), .out( C )
  );
  assign s5 = s4[3:0];
  assign s8[3:0] = s5;
  assign s8[7:4] = 4'b11;
  CompUnsigned #(.Bits(4)) CompUnsigned_i3 (
    .a( s5 ), .b( 4'b0 ), .\> ( s11 )
  );
  assign s10 = (s9 | s11);
  Mux_2x1_NBits #(.Bits(8)) Mux_2x1_NBits_i4 (
    .sel( s10 ), .in_0( 8'b100000 ), .in_1( s8 ), .out( D )
  );

  // Contador que controla la posición de los caracteres en la pantalla.
  DIG_Counter_Nbit #(.Bits(4)) DIG_Counter_Nbit_i5 (
    .en( s0 ), .C( clk ), .clr( rst ), .out( LCD )
  );
  CompUnsigned #(.Bits(5)) CompUnsigned_i6 (
    .a( s1 ), .b( LCD16 ), .\< ( s2 )
  );

  // Distintos mensajes de estado muscular
  Mux_16x1_NBits #(.Bits(8)) Mux_16x1_NBits_i7 ( // Estado NORMAL
    .sel( POS_LCD ), .in_0( C ), .in_1( D ), .in_2( U ), .in_3( 8'b100101 ), .in_4( 8'b100000 ), .in_5( 8'b100000 ), .in_6( 8'b100000 ), .in_7( 8'b100000 ), .in_8( 8'b100000 ), .in_9( 8'b100000 ), .in_10( 8'b1001110 ), .in_11( 8'b1001111 ), .in_12( 8'b1010010 ), .in_13( 8'b1001101 ), .in_14( 8'b1000001 ), .in_15( 8'b1001100 ),
    .out( \Nor  )
  );
  Mux_16x1_NBits #(.Bits(8)) Mux_16x1_NBits_i8 ( // Estado PRECAUCION
    .sel( POS_LCD ), .in_0( C ), .in_1( D ), .in_2( U ), .in_3( 8'b100101 ), .in_4( 8'b100000 ), .in_5( 8'b100000 ), .in_6( 8'b1010000 ), .in_7( 8'b1010010 ), .in_8( 8'b1000101 ), .in_9( 8'b1000011 ), .in_10( 8'b1000001 ), .in_11( 8'b1010101 ), .in_12( 8'b1000011 ), .in_13( 8'b1001001 ), .in_14( 8'b1001111 ), .in_15( 8'b1001110 ),
    .out( Pre )
  );
  Mux_16x1_NBits #(.Bits(8)) Mux_16x1_NBits_i9 ( // Estado LIMITE
    .sel( POS_LCD ), .in_0( C ), .in_1( D ), .in_2( U ), .in_3( 8'b100101 ), .in_4( 8'b100000 ), .in_5( 8'b100000 ), .in_6( 8'b100000 ), .in_7( 8'b100000 ), .in_8( 8'b100000 ), .in_9( 8'b100000 ), .in_10( 8'b1001100 ), .in_11( 8'b1001001 ), .in_12( 8'b1001101 ), .in_13( 8'b1001001 ), .in_14( 8'b1010100 ), .in_15( 8'b1000101 ),
    .out( Lim )
  );
  Mux_16x1_NBits #(.Bits(8)) Mux_16x1_NBits_i10 ( // Estado EXCEDIDO
    .sel( POS_LCD ), .in_0( C ), .in_1( D ), .in_2( U ), .in_3( 8'b100101 ), .in_4( 8'b100000 ), .in_5( 8'b100000 ), .in_6( 8'b100000 ), .in_7( 8'b100000 ), .in_8( 8'b1000101 ), .in_9( 8'b1011000 ), .in_10( 8'b1000011 ), .in_11( 8'b1000101 ), .in_12( 8'b1000100 ), .in_13( 8'b1001001 ), .in_14( 8'b1000100 ), .in_15( 8'b1001111 ),
    .out( Exc )
  );
  
  // Selector del mensaje a mostrar
  Mux_8x1_NBits #(.Bits(8)) Mux_8x1_NBits_i11 (
    .sel( s12 ), .in_0( Pul ), .in_1( \Nor  ), .in_2( Pre ), .in_3( Lim ), .in_4( Exc ), .in_5( Com ), .in_6( 8'b0 ), .in_7( 8'b0 ), .out( Fil2 )
  );

  // Temporizadores y Máquinas de Estados para la LCD en modo 4-bits
  assign s26 = (s20 | rst | FinT);
  Mux_2x1_NBits #(.Bits(3)) Mux_2x1_NBits_i12 (.sel( rst ), .in_0( s36 ), .in_1( 3'b0 ), .out( s18 ));
  DIG_Counter_Nbit #(.Bits(4)) DIG_Counter_Nbit_i13 (.en( Sig_Ini ), .C( clk ), .clr( rst ), .out( PasoIni ));
  
  assign s43 = (rst | Fin_Esp | ~ s42);
  Mux_2x1_NBits #(.Bits(3)) Mux_2x1_NBits_i14 (.sel( rst ), .in_0( s54 ), .in_1( 3'b0 ), .out( s38 ));
  DIG_Counter_Nbit #(.Bits(4)) DIG_Counter_Nbit_i15 (.en( Avan_Pos_LCD ), .C( clk ), .clr( rst ), .out( POS_LCD ));
  
  assign s59 = (rst | Cam_Fila);
  Mux_2x1 Mux_2x1_i16 (.sel( rst ), .in_0( NO_Fil_LCD ), .in_1( 1'b0 ), .out( s58 ));
  Mux_2x1_NBits #(.Bits(3)) Mux_2x1_NBits_i17 (.sel( rst ), .in_0( s67 ), .in_1( 3'b0 ), .out( s62 ));
  Mux_2x1_NBits #(.Bits(8)) Mux_2x1_NBits_i18 (.sel( s2 ), .in_0( 8'b100000 ), .in_1( 8'b11111111 ), .out( Fil1 ));
  
  assign s1[3:0] = LCD;
  assign s1[4] = 1'b0;

  // Se guardan los mensajes de "pulse boton" y "compensacion" para mostrarlos en pantalla.
  Mux_16x1_NBits #(.Bits(8)) Mux_16x1_NBits_i19 (.sel( POS_LCD ), .in_0( 8'b100000 ), .in_1( 8'b100000 ), .in_2( 8'b1010000 ), .in_3( 8'b1010101 ), .in_4( 8'b1001100 ), .in_5( 8'b1010011 ), .in_6( 8'b1000101 ), .in_7( 8'b100000 ), .in_8( 8'b100000 ), .in_9( 8'b1000010 ), .in_10( 8'b1001111 ), .in_11( 8'b1010100 ), .in_12( 8'b1001111 ), .in_13( 8'b1001110 ), .in_14( 8'b100000 ), .in_15( 8'b100000 ), .out( Pul ));
  Mux_16x1_NBits #(.Bits(8)) Mux_16x1_NBits_i20 (.sel( POS_LCD ), .in_0( 8'b100000 ), .in_1( 8'b100000 ), .in_2( 8'b1000011 ), .in_3( 8'b1001111 ), .in_4( 8'b1001101 ), .in_5( 8'b1010000 ), .in_6( 8'b1000101 ), .in_7( 8'b1001110 ), .in_8( 8'b1010011 ), .in_9( 8'b1000001 ), .in_10( 8'b1000011 ), .in_11( 8'b1001001 ), .in_12( 8'b1001111 ), .in_13( 8'b1001110 ), .in_14( 8'b100000 ), .in_15( 8'b100000 ), .out( Com ));
  
  // Inicialización del LCD
  DIG_Register_BUS #(.Bits(3)) DIG_Register_BUS_i21 (.D( s18 ), .C( clk ), .en( 1'b1 ), .Q( s19 ));
  Mux_16x1_NBits #(.Bits(8)) Mux_16x1_NBits_i22 (.sel( PasoIni ), .in_0( 8'b110000 ), .in_1( 8'b110000 ), .in_2( 8'b110000 ), .in_3( 8'b100000 ), .in_4( 8'b101000 ), .in_5( 8'b1000 ), .in_6( 8'b1 ), .in_7( 8'b110 ), .in_8( 8'b1100 ), .in_9( 8'b0 ), .in_10( 8'b0 ), .in_11( 8'b0 ), .in_12( 8'b0 ), .in_13( 8'b0 ), .in_14( 8'b0 ), .in_15( 8'b0 ), .out( Dat_Ini ));
  
  CompUnsigned #(.Bits(4)) CompUnsigned_i23 (.a( PasoIni ), .b( 4'b100 ), .\< ( s37 ));

  // Registros de control de estado del display
  DIG_Register_BUS #(.Bits(3)) DIG_Register_BUS_i24 (.D( s38 ), .C( clk ), .en( 1'b1 ), .Q( s39 ));
  CompUnsigned #(.Bits(4)) CompUnsigned_i25 (.a( PasoIni ), .b( 4'b1000 ), .\= ( UltPas ));
  CompUnsigned #(.Bits(4)) CompUnsigned_i26 (.a( PasoIni ), .b( 4'b0 ), .\= ( s56 ));
  CompUnsigned #(.Bits(4)) CompUnsigned_i27 (.a( PasoIni ), .b( 4'b110 ), .\= ( s57 ));
  DIG_Register DIG_Register_i28 (.D( s58 ), .C( clk ), .en( s59 ), .Q( Fil_LCD ));
  DIG_Register_BUS #(.Bits(3)) DIG_Register_BUS_i29 (.D( s62 ), .C( clk ), .en( 1'b1 ), .Q( Est_Pant ));
  CompUnsigned #(.Bits(4)) CompUnsigned_i30 (.a( POS_LCD ), .b( 4'b1111 ), .\= ( Ult_Pos ));
  
  // Selección del dato final hacia el driver de 4 bits del LCD
  Mux_2x1_NBits #(.Bits(8)) Mux_2x1_NBits_i31 (.sel( Fil_LCD ), .in_0( Fil1 ), .in_1( Fil2 ), .out( Out_LCD ));
  
  // Controladores de interrupción, esperas y envíos por nibbles
  CompUnsigned #(.Bits(3)) CompUnsigned_i32 (.a( s19 ), .b( 3'b0 ), .\= ( s20 ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i33 (.a( s19 ), .b( 3'b10 ), .\= ( s21 ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i34 (.a( s19 ), .b( 3'b100 ), .\= ( s22 ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i35 (.a( s19 ), .b( 3'b101 ), .\= ( s23 ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i36 (.a( s19 ), .b( 3'b110 ), .\= ( s24 ));
  DIG_Add #(.Bits(3)) DIG_Add_i37 (.a( s19 ), .b( 3'b1 ), .c_i( 1'b0 ), .s( s31 ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i38 (.a( s19 ), .b( 3'b1 ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i39 (.a( s19 ), .b( 3'b11 ), .\= ( Mant1 ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i40 (.a( s39 ), .b( 3'b0 ), .\= ( s40 ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i41 (.a( s39 ), .b( 3'b1 ), .\= ( Start_int ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i42 (.a( s39 ), .b( 3'b10 ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i43 (.a( s39 ), .b( 3'b11 ), .\= ( Esp_LCD ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i44 (.a( s39 ), .b( 3'b100 ), .\= ( s41 ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i45 (.a( s39 ), .b( 3'b101 ), .\= ( List_in ));
  
  assign s53[0] = 1'b1;
  assign s53[1] = 1'b0;
  assign s53[2] = UltPas;
  assign NO_Fil_LCD = ~ Fil_LCD;
  
  // Asignación de las direcciones DDRAM
  Mux_2x1_NBits #(.Bits(8)) Mux_2x1_NBits_i46 (.sel( Fil_LCD ), .in_0( 8'b10000000 ), .in_1( 8'b11000000 ), .out( s60 ));
  
  CompUnsigned #(.Bits(3)) CompUnsigned_i47 (.a( Est_Pant ), .b( 3'b0 ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i48 (.a( Est_Pant ), .b( 3'b1 ), .\= ( Env_Dir ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i49 (.a( Est_Pant ), .b( 3'b10 ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i50 (.a( Est_Pant ), .b( 3'b11 ), .\= ( s_Rs ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i51 (.a( Est_Pant ), .b( 3'b100 ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i52 (.a( Est_Pant ), .b( 3'b101 ), .\= ( Avan_Pos_LCD ));
  CompUnsigned #(.Bits(3)) CompUnsigned_i53 (.a( Est_Pant ), .b( 3'b110 ), .\= ( Cam_Fila ));
  
  assign s66[0] = ~ Ult_Pos;
  assign s66[1] = 1'b1;
  assign s66[2] = Ult_Pos;
  
  // Control del pin Enable E y multiplexado de nibbles
  assign s16 = (s22 | s23 | s24);
  assign E = (s21 | s23);
  assign s25 = ~ s20;
  assign Sig_Ini = (s41 & ~ UltPas);
  assign s42 = (s40 | Esp_LCD);
  assign s49[0] = (Esp_LCD & ~ s57);
  assign s49[1] = (Esp_LCD & ~ s56);
  
  Mux_2x1_NBits #(.Bits(8)) Mux_2x1_NBits_i54 (.sel( Env_Dir ), .in_0( Out_LCD ), .in_1( s60 ), .out( s61 ));
  assign Start_Pant = (Env_Dir | s_Rs);
  assign s63[0] = List_in;
  assign s63[2:1] = 2'b0;
  Mux_2x1 Mux_2x1_i55 (.sel( List_in ), .in_0( 1'b0 ), .in_1( s_Rs ), .out( RS_TX ));
  Mux_2x1 Mux_2x1_i56 (.sel( List_in ), .in_0( s37 ), .in_1( 1'b0 ), .out( Sol_Nibble_TX ));
  assign s0 = (NO_Fil_LCD & Avan_Pos_LCD);
  
  // Contadores de temporización general del LCD
  DIG_Counter_Nbit #(.Bits(12)) DIG_Counter_Nbit_i57 (.en( s25 ), .C( clk ), .clr( s26 ), .out( s27 ));
  DIG_Counter_Nbit #(.Bits(22)) DIG_Counter_Nbit_i58 (.en( s42 ), .C( clk ), .clr( s43 ), .out( s44 ));
  
  Mux_2x1_NBits #(.Bits(8)) Mux_2x1_NBits_i59 (.sel( List_in ), .in_0( Dat_Ini ), .in_1( s61 ), .out( Dat_TX ));
  Mux_2x1 Mux_2x1_i60 (.sel( List_in ), .in_0( Start_int ), .in_1( Start_Pant ), .out( START_tx ));
  
  CompUnsigned #(.Bits(12)) CompUnsigned_i61 (.a( s27 ), .b( 12'b110001 ), .\= ( s28 ));
  CompUnsigned #(.Bits(12)) CompUnsigned_i62 (.a( s27 ), .b( 12'b100111000011 ), .\= ( s29 ));
  assign CD = (START_tx & s20);
  CompUnsigned #(.Bits(22)) CompUnsigned_i63 (.a( s44 ), .b( 22'b1001100010010110011111 ), .\= ( s45 ));
  CompUnsigned #(.Bits(22)) CompUnsigned_i64 (.a( s44 ), .b( 22'b111101000010001111 ), .\= ( s46 ));
  CompUnsigned #(.Bits(22)) CompUnsigned_i65 (.a( s44 ), .b( 22'b11000011010011111 ), .\= ( s47 ));
  CompUnsigned #(.Bits(22)) CompUnsigned_i66 (.a( s44 ), .b( 22'b10011100001111 ), .\= ( s48 ));
  
  DIG_Register_BUS #(.Bits(8)) DIG_Register_BUS_i67 (.D( Dat_TX ), .C( clk ), .en( CD ), .Q( s13 ));
  Mux_2x1 Mux_2x1_i68 (.sel( s24 ), .in_0( s28 ), .in_1( s29 ), .out( FinT ));
  DIG_Register DIG_Register_i69 (.D( RS_TX ), .C( clk ), .en( CD ), .Q( RS ));
  DIG_Register DIG_Register_i70 (.D( Sol_Nibble_TX ), .C( clk ), .en( CD ), .Q( s34 ));
  Mux_4x1 Mux_4x1_i71 (.sel( s49 ), .in_0( s45 ), .in_1( s46 ), .in_2( s47 ), .in_3( s48 ), .out( Fin_Esp ));
  
  assign s30 = ((s20 & START_tx) | (~ s20 & FinT));
  assign Donetx = (FinT & s24);
  assign s35 = (s34 & FinT & Mant1);
  assign s50[0] = Fin_Esp; assign s50[1] = 1'b0; assign s50[2] = 1'b0;
  assign s55 = ~ Fin_Esp;
  
  // Multiplexado del bus de datos de 8bits hacia 4bits
  assign s14 = s13[3:0];
  assign s15 = s13[7:4];
  Mux_2x1_NBits #(.Bits(4)) Mux_2x1_NBits_i72 (.sel( s16 ), .in_0( s15 ), .in_1( s14 ), .out( s17 ));
  Mux_2x1_NBits #(.Bits(3)) Mux_2x1_NBits_i73 (.sel( s30 ), .in_0( s19 ), .in_1( s31 ), .out( s32 ));
  
  assign s51[0] = Donetx; assign s51[1] = 1'b1; assign s51[2] = 1'b0;
  assign s52[0] = s55;    assign s52[1] = s55;    assign s52[2] = Fin_Esp;
  assign s64[0] = Donetx; assign s64[1] = 1'b1;   assign s64[2] = 1'b0;
  assign s65[0] = Donetx; assign s65[1] = 1'b0;   assign s65[2] = 1'b1;
  
  Mux_2x1_NBits #(.Bits(3)) Mux_2x1_NBits_i74 (.sel( Donetx ), .in_0( s32 ), .in_1( 3'b0 ), .out( s33 ));
  Mux_8x1_NBits #(.Bits(3)) Mux_8x1_NBits_i75 (.sel( s39 ), .in_0( s50 ), .in_1( 3'b10 ), .in_2( s51 ), .in_3( s52 ), .in_4( s53 ), .in_5( 3'b101 ), .in_6( 3'b0 ), .in_7( 3'b0 ), .out( s54 ));
  Mux_8x1_NBits #(.Bits(3)) Mux_8x1_NBits_i76 (.sel( Est_Pant ), .in_0( s63 ), .in_1( 3'b10 ), .in_2( s64 ), .in_3( 3'b100 ), .in_4( s65 ), .in_5( s66 ), .in_6( 3'b1 ), .in_7( 3'b0 ), .out( s67 ));
  
  // Salida física al puerto LCD.
  assign D4 = s17[0];
  assign D5 = s17[1];
  assign D6 = s17[2];
  assign D7 = s17[3];
  
  Mux_2x1_NBits #(.Bits(3)) Mux_2x1_NBits_i77 (.sel( s35 ), .in_0( s33 ), .in_1( 3'b110 ), .out( s36 ));
endmodule
