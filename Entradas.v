// Flip-Flop D de 1 bit.
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

  // ============================================================================
  //                              E N T R A D A S
  // ============================================================================
  // Antirrebote de pulsadores
  DIG_D_FF_1bit #(.Default(0)) DIG_D_FF_1bit_i0 (.D( Pulsador ), .C( CLk ), .Q( s36 ));
  DIG_D_FF_1bit #(.Default(0)) DIG_D_FF_1bit_i1 (.D( Reset ), .C( CLk ), .Q( s37 ));
  DIG_D_FF_1bit #(.Default(0)) DIG_D_FF_1bit_i2 (.D( s36 ), .C( CLk ), .Q( s1 ));
  DIG_D_FF_1bit #(.Default(0)) DIG_D_FF_1bit_i3 (.D( s37 ), .C( CLk ), .Q( rst ));
  DIG_D_FF_1bit #(.Default(0)) DIG_D_FF_1bit_i4 (.D( s1 ), .C( CLk ), .\~Q ( s2 ));
  
  assign Nrst = ~ rst;
  assign BtnPul = ((s1 & s2) | rst);
  // ============================================================================
  //                          F I N   E N T R A D A S
  // ============================================================================
