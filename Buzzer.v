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
