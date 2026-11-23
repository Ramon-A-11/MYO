// Fragmento del modulo ProyectoMYO_Pru1; requiere señales y módulos auxiliares.
  // ============================================================================
  //                   D I V I S I O N   P A S O S / S E G M
  // ============================================================================
  CompUnsigned #(.Bits(19)) CompUnsigned_i26 (.a( s10 ), .b( 19'b1100100 ), .\> ( s11 ), .\= ( s12 )); // > 100% (Excedido)
  
  assign s14 = s10[7:0];
  assign s38 = s10[7:0];
  assign s13 = (s11 | s12);
  
  // Límite para evitar saturación
  Mux_2x1_NBits #(.Bits(8)) Mux_2x1_NBits_i29 (.sel( s13 ), .in_0( s14 ), .in_1( 8'b1100100 ), .out( s15 ));
  Mux_2x1_NBits #(.Bits(8)) Mux_2x1_NBits_i30 (.sel( s13 ), .in_0( s14 ), .in_1( 8'b1100100 ), .out( s25 ));
  
  // Escalado de porcentajes para LCD y PWM
  DIG_Mul_unsigned #(.Bits(8)) DIG_Mul_unsigned_i31 (.a( s15 ), .b( 8'b10000 ), .mul( s16 ));
  DIG_Mul_unsigned #(.Bits(8)) DIG_Mul_unsigned_i32 (.a( s25 ), .b( 8'b1111 ), .mul( s26 ));
  assign s17 = s16[10:0];
  assign s27 = s26[10:0];
  
  Mod_div_11 Mod_div_11_i33 (.a( s27 ), .b( 11'b1100100 ), .q( s28 ));
  Mod_div_11 Mod_div_11_i34 (.a( s17 ), .b( 11'b1100100 ), .q( s18 ));
  
  assign s19 = s18[4:0];
  assign s29 = s28[3:0];
  // ============================================================================
  //               F I N   D I V I S I O N   P A S O S / S E G M
  // ============================================================================
