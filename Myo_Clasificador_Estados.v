// Porcentajes 80, 100 y umbral digital 3000 originales del top.
module Myo_Clasificador_Estados (
    input wire [18:0] Porcentaje,
    input wire [11:0] VlrMax,
    input wire [11:0] DatComp,
    output wire En_Nor,
    output wire En_Pre,
    output wire En_Lim,
    output wire En_Exc,
    output wire En_Com
);
    wire referencia_activa;
    assign referencia_activa = (VlrMax != 12'd0);
    assign En_Nor = referencia_activa && (Porcentaje < 19'd80);
    assign En_Pre = (Porcentaje >= 19'd80) && (Porcentaje < 19'd100);
    assign En_Lim = (Porcentaje == 19'd100);
    assign En_Exc = (Porcentaje > 19'd100);
    assign En_Com = referencia_activa && (DatComp >= 12'd3000);
endmodule
