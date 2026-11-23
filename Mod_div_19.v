// Archivo separado de ProyectoMYO_Pru1.v para documentacion modular.
// La definicion original del modulo se conserva sin modificar.
module Mod_div_19 (
    input wire [18:0] a,
    input wire [18:0] b,
    output wire [18:0] q
);

    assign q = (b != 19'd0) ? (a / b) : 19'd0;

endmodule
