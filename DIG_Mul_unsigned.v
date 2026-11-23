// Archivo separado de ProyectoMYO_Pru1.v para documentacion modular.
// La definicion original del modulo se conserva sin modificar.
module DIG_Mul_unsigned #(
    parameter Bits = 1
)
(
    
      input [(Bits-1):0] a,
      input [(Bits-1):0] b,
      output [(Bits*2-1):0] mul
    
);
    assign mul = a * b;
endmodule
