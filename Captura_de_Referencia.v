  // Registro de captura máxima.
  Mux_2x1_NBits #(.Bits(12)) Mux_2x1_NBits_i6 (.sel( rst ), .in_0( s3 ), .in_1( 12'b0 ), .out( s0 ));
  DIG_Register_BUS #(.Bits(12)) DIG_Register_BUS_i5 (.D( s0 ), .C( CLk ), .en( BtnPul ), .Q( VlrMax ));
  assign s6[11:0] = VlrMax;
  assign s6[18:12] = 7'b0;
  

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

// Multiplexor de 2 entradas a 1 salida para buses de N bits.
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
