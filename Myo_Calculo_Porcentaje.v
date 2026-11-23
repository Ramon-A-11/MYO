// Equivalente bit a bit al producto/seleccion/division del top original.
// Usa 19 bits bajos del producto de 24 bits; protege division por cero.
module Myo_Calculo_Porcentaje (
    input wire [11:0] DatoPrincipal,
    input wire [11:0] VlrMax,
    output wire [18:0] Porcentaje
);
    wire [23:0] producto;
    wire [18:0] referencia_ext;
    wire es_cero;
    wire [18:0] numerador;
    wire [18:0] divisor;
    assign referencia_ext = {7'b0, VlrMax};

    DIG_Mul_unsigned #(.Bits(12)) multiplicacion (
        .a(12'd100), .b(DatoPrincipal), .mul(producto)
    );
    CompUnsigned #(.Bits(19)) comprobar_referencia (
        .a(referencia_ext), .b(19'd0), .\= (es_cero)
    );
    Mux_2x1_NBits #(.Bits(19)) proteger_numerador (
        .sel(es_cero), .in_0(producto[18:0]),
        .in_1(19'd0), .out(numerador)
    );
    Mux_2x1_NBits #(.Bits(19)) proteger_divisor (
        .sel(es_cero), .in_0(referencia_ext),
        .in_1(19'd1), .out(divisor)
    );
    Mod_div_19 division (
        .a(numerador), .b(divisor), .q(Porcentaje)
    );
endmodule
