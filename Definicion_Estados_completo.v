// Fragmento original del módulo ProyectoMYO_Pru1. Requiere señales y módulos auxiliares del proyecto para compilar.
  // ============================================================================
  //                  D E F I N I C I Ó N   D E   R A N G O S
  // ============================================================================
  assign s24 = ~ s7;
  
  // Detección de rangos de estado muscular
  CompUnsigned #(.Bits(19)) CompUnsigned_i27 (.a( s10 ), .b( 19'b1010000 ), .\> ( s20 ), .\= ( s21 ), .\< ( s22 )); // > 80% (Precaución)
  CompUnsigned #(.Bits(19)) CompUnsigned_i28 (.a( s10 ), .b( 19'b1100100 ), .\> ( En_Exc ), .\= ( En_Lim ), .\< ( s23 )); // = 100% (Límite)
  
  // Banderas de estado hacia periféricos
  assign En_Pre = ((s20 | s21) & s23); // En Precaución
  assign En_Nor = (s22 & s24);         // Normal
  
  // Límites de compensación
  CompUnsigned #(.Bits(12)) CompUnsigned_i23 (.a( DatComp ), .b( 12'b010111011100 ), .\> ( s30 ), .\= ( s31 ));
  assign En_Com = (s24 & (s30 | s31));
  // ============================================================================
  //              F I N   D E F I N I C I Ó N   D E   R A N G O S
  // ============================================================================
