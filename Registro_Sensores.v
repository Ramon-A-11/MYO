// Registro de N bits con Enable.
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

  // Captura asíncrona de datos desde el I2C
  // ============================================================================
  //                    D A T O   S E N   P R I N C I P A L
  // ============================================================================
  DIG_Register_BUS #(.Bits(12)) DIG_Register_BUS_i13 (.D( \12Sen1  ), .C( CLk ), .en( Valid1 ), .Q( s34 )); // Sensor 1 (Principal)
  DIG_Register_BUS #(.Bits(12)) DIG_Register_BUS_i20 (.D( s34 ), .C( CLk ), .en( Pulso ), .Q( s3 ));
  // ============================================================================
  //                F I N   D A T O   S E N   P R I N C I P A L
  // ============================================================================
  
  // ============================================================================
  //                 D A T O   S E N   C O M P E N S A C I Ó N
  // ============================================================================
  DIG_Register_BUS #(.Bits(12)) DIG_Register_BUS_i14 (.D( \12Sen2  ), .C( CLk ), .en( Valid2 ), .Q( s35 )); // Sensor 2 (Compensación)
  DIG_Register_BUS #(.Bits(12)) DIG_Register_BUS_i21 (.D( s35 ), .C( CLk ), .en( Pulso ), .Q( DatComp ));
  // ============================================================================
  //             F I N   D A T O   S E N   C O M P E N S A C I Ó N
  // ============================================================================
  
