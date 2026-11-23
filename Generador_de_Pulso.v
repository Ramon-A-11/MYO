// Comparador de magnitudes sin signo para buses de N bits.
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

// Contador síncrono ascendente de N bits con reset síncrono y Enable.
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

  // ============================================================================
  //                          G E N   D E   P U L S O
  // ============================================================================
  // Temporizador que le dice al sistema cada cuanto debe procesar muestras
  DIG_Counter_Nbit #(.Bits(19)) DIG_Counter_Nbit_i12 (.en( 1'b1 ), .C( CLk ), .clr( s32 ), .out( s33 ));
  CompUnsigned #(.Bits(19)) CompUnsigned_i18 (.a( s33 ), .b( 19'b1111010000100011111 ), .\= ( Pulso ));
  assign s32 = (rst | Pulso);
  // ============================================================================
  //                      F I N   G E N   D E   P U L S O
  // ============================================================================
