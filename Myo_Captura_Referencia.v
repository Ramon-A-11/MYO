// Captura DatoPrincipal al pulsar; rst borra VlrMax en el flanco de reloj.
module Myo_Captura_Referencia (
    input wire clk,
    input wire rst,
    input wire BtnPul,
    input wire [11:0] DatoPrincipal,
    output wire [11:0] VlrMax
);
    wire [11:0] valor_a_guardar;
    Mux_2x1_NBits #(.Bits(12)) sel_referencia (
        .sel(rst), .in_0(DatoPrincipal), .in_1(12'b0),
        .out(valor_a_guardar)
    );
    DIG_Register_BUS #(.Bits(12)) registro_referencia (
        .D(valor_a_guardar), .C(clk), .en(BtnPul), .Q(VlrMax)
    );
endmodule
