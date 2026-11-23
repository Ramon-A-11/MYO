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

module DIG_Mul_unsigned #(parameter Bits = 1) (
      input [(Bits-1):0] a, input [(Bits-1):0] b,
      output [(Bits*2-1):0] mul
);
    assign mul = a * b;
endmodule

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
