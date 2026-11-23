// Archivo separado de ProyectoMYO_Pru1.v para documentacion modular.
// La definicion original del modulo se conserva sin modificar.
module ProyectoMYO_Pru1 (
  input CLk,
  input Reset,
  input Pulsador,
  output PWM,
  output E,
  output Rs,
  output Rw,
  output D4,
  output D5,
  output D6,
  output D7,
  output UART,
  output Buzz,
  output ErrADS,
  inout scl,
  inout sda
);
  wire [11:0] s0;
  wire BtnPul;
  wire [11:0] VlrMax;
  wire s1;
  wire s2;
  wire [11:0] s3;
  wire [23:0] s4;
  wire [18:0] s5;
  wire [18:0] s6;
  wire s7;
  wire [18:0] s8;
  wire [18:0] s9;
  wire [18:0] s10;
  wire s11;
  wire s12;
  wire s13;
  wire [7:0] s14;
  wire [7:0] s15;
  wire [15:0] s16;
  wire [10:0] s17;
  wire [10:0] s18;
  wire [4:0] s19;
  wire s20;
  wire s21;
  wire s22;
  wire En_Exc;
  wire En_Lim;
  wire s23;
  wire En_Pre;
  wire s24;
  wire En_Nor;
  wire [7:0] s25;
  wire [15:0] s26;
  wire [10:0] s27;
  wire [10:0] s28;
  wire [3:0] s29;
  wire [11:0] DatComp;
  wire s30;
  wire s31;
  wire s32;
  wire [18:0] s33;
  wire Pulso;
  wire rst;
  wire [11:0] s34;
  wire [11:0] s35;
  wire [11:0] \12Sen1 ;
  wire Valid1;
  wire s36;
  wire s37;
  wire En_Com;
  wire Nrst;
  wire [7:0] s38;
  wire [11:0] \12Sen2 ;
  wire Valid2;
  wire s39;
  wire s40;
  wire s41;
  DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i0 (
    .D( Pulsador ),
    .C( CLk ),
    .Q( s36 )
  );
  DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i1 (
    .D( Reset ),
    .C( CLk ),
    .Q( s37 )
  );
  DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i2 (
    .D( s36 ),
    .C( CLk ),
    .Q( s1 )
  );
  DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i3 (
    .D( s37 ),
    .C( CLk ),
    .Q( rst )
  );
  DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i4 (
    .D( s1 ),
    .C( CLk ),
    .\~Q ( s2 )
  );
  assign Nrst = ~ rst;
  assign BtnPul = ((s1 & s2) | rst);
  DIG_Register_BUS #(
    .Bits(12)
  )
  DIG_Register_BUS_i5 (
    .D( s0 ),
    .C( CLk ),
    .en( BtnPul ),
    .Q( VlrMax )
  );
  assign s32 = (rst | Pulso);
  Mux_2x1_NBits #(
    .Bits(12)
  )
  Mux_2x1_NBits_i6 (
    .sel( rst ),
    .in_0( s3 ),
    .in_1( 12'b0 ),
    .out( s0 )
  );
  Mod_LCD_F Mod_LCD_F_i7 (
    .clk( CLk ),
    .rst( rst ),
    .In_Com( En_Com ),
    .In_Norm( En_Nor ),
    .In_Pre( En_Pre ),
    .In_Lim( En_Lim ),
    .In_Exc( En_Exc ),
    .Prc( s38 ),
    .LCD16( s19 ),
    .E( E ),
    .RS( Rs ),
    .Rw( Rw ),
    .D4( D4 ),
    .D5( D5 ),
    .D6( D6 ),
    .D7( D7 )
  );
  Cont_Srv_Con Cont_Srv_Con_i8 (
    .clk( CLk ),
    .rst( rst ),
    .In( s29 ),
    .pwm( PWM )
  );
  Mod_Blue Mod_Blue_i9 (
    .RESET_N( rst ),
    .VALOR_MAX( BtnPul ),
    .s_P( \12Sen1  ),
    .Dato_max( VlrMax ),
    .clk( CLk ),
    .UART_TX_OUT( UART )
  );
  Mod_Buzzer Mod_Buzzer_i10 (
    .EXC( En_Exc ),
    .COM( En_Com ),
    .clk( CLk ),
    .rst( rst ),
    .Buzz( Buzz )
  );
  // ADS1115_I2C
  ADS1115_I2C ADS1115_I2C_i11 (
    .clk( CLk ),
    .rst( rst ),
    .sda_in( s39 ),
    .sensor1( \12Sen1  ),
    .sensor2( \12Sen2  ),
    .valid1( Valid1 ),
    .valid2( Valid2 ),
    .sda_drive_low( s40 ),
    .scl_drive_low( s41 ),
    .error( ErrADS )
  );
  assign s6[11:0] = VlrMax;
  assign s6[18:12] = 7'b0;
  DIG_Counter_Nbit #(
    .Bits(19)
  )
  DIG_Counter_Nbit_i12 (
    .en( 1'b1 ),
    .C( CLk ),
    .clr( s32 ),
    .out( s33 )
  );
  // 1Sensor
  DIG_Register_BUS #(
    .Bits(12)
  )
  DIG_Register_BUS_i13 (
    .D( \12Sen1  ),
    .C( CLk ),
    .en( Valid1 ),
    .Q( s34 )
  );
  // 1Sensor
  DIG_Register_BUS #(
    .Bits(12)
  )
  DIG_Register_BUS_i14 (
    .D( \12Sen2  ),
    .C( CLk ),
    .en( Valid2 ),
    .Q( s35 )
  );
  DIG_PinControl_BUS DIG_PinControl_BUS_i15 (
    .wr( 1'b0 ),
    .oe( s40 ),
    .rd( s39 ),
    .pin( sda )
  );
  DIG_PinControl_BUS DIG_PinControl_BUS_i16 (
    .wr( 1'b0 ),
    .oe( s41 ),
    .pin( scl )
  );
  CompUnsigned #(
    .Bits(19)
  )
  CompUnsigned_i17 (
    .a( s6 ),
    .b( 19'b0 ),
    .\= ( s7 )
  );
  CompUnsigned #(
    .Bits(19)
  )
  CompUnsigned_i18 (
    .a( s33 ),
    .b( 19'b1111010000100011111 ),
    .\= ( Pulso )
  );
  Mux_2x1_NBits #(
    .Bits(19)
  )
  Mux_2x1_NBits_i19 (
    .sel( s7 ),
    .in_0( s6 ),
    .in_1( 19'b1 ),
    .out( s9 )
  );
  DIG_Register_BUS #(
    .Bits(12)
  )
  DIG_Register_BUS_i20 (
    .D( s34 ),
    .C( CLk ),
    .en( Pulso ),
    .Q( s3 )
  );
  // 2sensor
  DIG_Register_BUS #(
    .Bits(12)
  )
  DIG_Register_BUS_i21 (
    .D( s35 ),
    .C( CLk ),
    .en( Pulso ),
    .Q( DatComp )
  );
  assign s24 = ~ s7;
  DIG_Mul_unsigned #(
    .Bits(12)
  )
  DIG_Mul_unsigned_i22 (
    .a( 12'b1100100 ),
    .b( s3 ),
    .mul( s4 )
  );
  CompUnsigned #(
    .Bits(12)
  )
  CompUnsigned_i23 (
    .a( DatComp ),
    .b( 12'b101110111000 ),
    .\> ( s30 ),
    .\= ( s31 )
  );
  assign En_Com = (s24 & (s30 | s31));
  assign s5 = s4[18:0];
  Mux_2x1_NBits #(
    .Bits(19)
  )
  Mux_2x1_NBits_i24 (
    .sel( s7 ),
    .in_0( s5 ),
    .in_1( 19'b0 ),
    .out( s8 )
  );
  // Mod_div_19
  Mod_div_19 Mod_div_19_i25 (
    .a( s8 ),
    .b( s9 ),
    .q( s10 )
  );
  CompUnsigned #(
    .Bits(19)
  )
  CompUnsigned_i26 (
    .a( s10 ),
    .b( 19'b1100100 ),
    .\> ( s11 ),
    .\= ( s12 )
  );
  CompUnsigned #(
    .Bits(19)
  )
  CompUnsigned_i27 (
    .a( s10 ),
    .b( 19'b1010000 ),
    .\> ( s20 ),
    .\= ( s21 ),
    .\< ( s22 )
  );
  CompUnsigned #(
    .Bits(19)
  )
  CompUnsigned_i28 (
    .a( s10 ),
    .b( 19'b1100100 ),
    .\> ( En_Exc ),
    .\= ( En_Lim ),
    .\< ( s23 )
  );
  assign s14 = s10[7:0];
  assign s38 = s10[7:0];
  assign s13 = (s11 | s12);
  assign En_Pre = ((s20 | s21) & s23);
  assign En_Nor = (s22 & s24);
  Mux_2x1_NBits #(
    .Bits(8)
  )
  Mux_2x1_NBits_i29 (
    .sel( s13 ),
    .in_0( s14 ),
    .in_1( 8'b1100100 ),
    .out( s15 )
  );
  Mux_2x1_NBits #(
    .Bits(8)
  )
  Mux_2x1_NBits_i30 (
    .sel( s13 ),
    .in_0( s14 ),
    .in_1( 8'b1100100 ),
    .out( s25 )
  );
  DIG_Mul_unsigned #(
    .Bits(8)
  )
  DIG_Mul_unsigned_i31 (
    .a( s15 ),
    .b( 8'b10000 ),
    .mul( s16 )
  );
  DIG_Mul_unsigned #(
    .Bits(8)
  )
  DIG_Mul_unsigned_i32 (
    .a( s25 ),
    .b( 8'b1111 ),
    .mul( s26 )
  );
  assign s17 = s16[10:0];
  assign s27 = s26[10:0];
  // Mod_div_11
  Mod_div_11 Mod_div_11_i33 (
    .a( s27 ),
    .b( 11'b1100100 ),
    .q( s28 )
  );
  // Mod_div_11
  Mod_div_11 Mod_div_11_i34 (
    .a( s17 ),
    .b( 11'b1100100 ),
    .q( s18 )
  );
  assign s19 = s18[4:0];
  assign s29 = s28[3:0];
endmodule
