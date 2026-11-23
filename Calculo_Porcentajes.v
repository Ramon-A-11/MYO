// Fragmento ORIGINAL del módulo ProyectoMYO_Pru1.
// Requiere las señales y los módulos auxiliares declarados en el proyecto completo.

  // ============================================================================
  //                C Á L C U L O   D E   P O R C E N T A J E S
  // ============================================================================
  // Registro de captura máxima.
  Mux_2x1_NBits #(.Bits(12)) Mux_2x1_NBits_i6 (.sel( rst ), .in_0( s3 ), .in_1( 12'b0 ), .out( s0 ));
  DIG_Register_BUS #(.Bits(12)) DIG_Register_BUS_i5 (.D( s0 ), .C( CLk ), .en( BtnPul ), .Q( VlrMax ));
  assign s6[11:0] = VlrMax;
  assign s6[18:12] = 7'b0;
  
  // Cálculo de Porcentaje ((Sensor * 100) / Max)
  CompUnsigned #(.Bits(19)) CompUnsigned_i17 (.a( s6 ), .b( 19'b0 ), .\= ( s7 ));
  Mux_2x1_NBits #(.Bits(19)) Mux_2x1_NBits_i19 (.sel( s7 ), .in_0( s6 ), .in_1( 19'b1 ), .out( s9 ));
  DIG_Mul_unsigned #(.Bits(12)) DIG_Mul_unsigned_i22 (.a( 12'b1100100 ), .b( s3 ), .mul( s4 ));
  assign s5 = s4[18:0];
  Mux_2x1_NBits #(.Bits(19)) Mux_2x1_NBits_i24 (.sel( s7 ), .in_0( s5 ), .in_1( 19'b0 ), .out( s8 ));
  Mod_div_19 Mod_div_19_i25 (.a( s8 ), .b( s9 ), .q( s10 ));
  // ============================================================================
  //            F I N   C Á L C U L O   D E   P O R C E N T A J E S
  // ============================================================================
