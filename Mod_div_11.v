// Archivo separado de ProyectoMYO_Pru1.v para documentacion modular.
// La definicion original del modulo se conserva sin modificar.
module Mod_div_11 (
    input wire [10:0] a,
    input wire [10:0] b,
    output wire [10:0] q
);

    assign q = (b != 11'd0) ? (a / b) : 11'd0;

endmodule
