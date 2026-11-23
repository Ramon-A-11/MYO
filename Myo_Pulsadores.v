// Extraccion modular equivalente al bloque de pulsadores del top original.
// Sincronizacion y deteccion de flanco; no incluye antirrebote.
module Myo_Pulsadores (
    input wire clk,
    input wire Reset,
    input wire Pulsador,
    output wire rst,
    output wire BtnPul
);
    wire pulso_ff1, pulso_ff2, pulso_ff2_anterior_n;
    wire reset_ff1;

    DIG_D_FF_1bit #(.Default(0)) ff_pulso_1 (
        .D(Pulsador), .C(clk), .Q(pulso_ff1)
    );
    DIG_D_FF_1bit #(.Default(0)) ff_pulso_2 (
        .D(pulso_ff1), .C(clk), .Q(pulso_ff2)
    );
    DIG_D_FF_1bit #(.Default(0)) ff_pulso_flanco (
        .D(pulso_ff2), .C(clk), .\~Q (pulso_ff2_anterior_n)
    );
    DIG_D_FF_1bit #(.Default(0)) ff_reset_1 (
        .D(Reset), .C(clk), .Q(reset_ff1)
    );
    DIG_D_FF_1bit #(.Default(0)) ff_reset_2 (
        .D(reset_ff1), .C(clk), .Q(rst)
    );
    assign BtnPul = (pulso_ff2 & pulso_ff2_anterior_n) | rst;
endmodule
