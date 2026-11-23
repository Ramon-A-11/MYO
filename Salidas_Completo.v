// ============================================================================
//                                 S A L I D A S
// ============================================================================

// CONTROLADOR DE PANTALLA LCD (Mod_LCD_F)

// Máquina de estados que resetea y envía datos a la LCD.
// Decodifica el nivel de contracción y elige los mensajes a mostrar en pantalla.


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

// CONTROLADOR DE SERVOMOTOR (Cont_Srv_Con)

// Módulo que genera la señal PWM para controlar la posición del servo dependiendo del nivel de contracción muscular.

module Cont_Srv_Con (
  input clk,
  input rst,
  input [3:0] In,
  output pwm
);
  wire [19:0] s0;
  wire [19:0] s1;
  wire [19:0] s2;
  wire s3;
  wire s4;
  wire [19:0] s5;
  wire [39:0] s6;
  wire [19:0] s7;
  wire [19:0] s8;
  
  // Escalado del valor de entrada a un ancho de pulso utilizable por el servo
  assign s5[3:0] = In;
  assign s5[19:4] = 16'b0;
  DIG_Mul_unsigned #(.Bits(20)) DIG_Mul_unsigned_i0 (
    .a( s5 ), .b( 20'b1100010111101 ), .mul( s6 )
  );
  assign s7 = s6[19:0];
  DIG_Add #(.Bits(20)) DIG_Add_i1 (
    .a( s7 ), .b( 20'b110000110101000 ), .c_i( 1'b0 ), .s( s8 )
  );
  
  assign s4 = (rst | s3);
  
  // Comparador que modula la salida PWM según el contador y el ciclo de trabajo
  CompUnsigned #(.Bits(20)) CompUnsigned_i2 (
    .a( s1 ), .b( s8 ), .\< ( pwm )
  );
  Mux_2x1_NBits #(.Bits(20)) Mux_2x1_NBits_i3 (.sel( s4 ), .in_0( s2 ), .in_1( 20'b0 ), .out( s0 ));
  DIG_Register_BUS #(.Bits(20)) DIG_Register_BUS_i4 (.D( s0 ), .C( clk ), .en( 1'b1 ), .Q( s1 ));
  
  // Contador del periodo base PWM
  DIG_Add #(.Bits(20)) DIG_Add_i5 (.a( s1 ), .b( 20'b1 ), .c_i( 1'b0 ), .s( s2 ));
  CompUnsigned #(.Bits(20)) CompUnsigned_i6 (
    .a( s1 ), .b( 20'b11110100001000111111 ), .\= ( s3 )
  );
endmodule

// TRANSMISIÓN DE DATOS (BLUETOOTH/UART)

// Temporizador que define la frecuencia a la que se envían los paquetes
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

// Registros para los datos a enviar
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

// Máquina de estados que divide el dato de 12 bits en 2 Bytes y controla la UART
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

// Núcleo UART transmisor
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

// Separador para extraer 12 bits en dos fragmentos de 8 bits para el envío UART
module SEPARADOR_12_A_8 (
  input [11:0] DATO_GUARDADO, output [7:0] BYTE_BAJO, output [7:0] BYTE_ALTO
);
  assign BYTE_ALTO[3:0] = DATO_GUARDADO[11:8];
  assign BYTE_ALTO[7:4] = 4'b0;
  assign BYTE_BAJO = DATO_GUARDADO[7:0];
endmodule

// MÓdulo de comunicaciones bluetooth
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

// CONTROLADOR DE BUZZER (Mod_Buzzer)

// Activa una señal cuadrada oscilatoria cuando los límites de esfuerzo EXC (Excedido) o COM (Compensación) están activos.

module Mod_Buzzer (
  input EXC, input COM, input clk, input rst,
  output Buzz
);
  wire s0, s1, s2; wire [25:0] s3; wire s4, s5;
  assign s0 = (EXC | COM);
  
  DIG_D_FF_1bit #(.Default(0)) DIG_D_FF_1bit_i0 (.D( COM ), .C( clk ), .\~Q ( s5 ));
  assign s2 = (~ s0 | (s5 & COM) | rst);
  
  DIG_Counter_Nbit #(.Bits(26)) DIG_Counter_Nbit_i1 (.en( s1 ), .C( clk ), .clr( s2 ), .out( s3 ));
  assign s1 = (~ s4 & s0);
  assign Buzz = ~ (s1 & ~ rst);
  CompUnsigned #(.Bits(26)) CompUnsigned_i2 (.a( s3 ), .b( 26'b1011111010111100001000000 ), .\= ( s4 ));
endmodule
