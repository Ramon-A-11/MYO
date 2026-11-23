// Primero retiene cada conversion valida del ADS1115;
// despues copia ambas lecturas a registros de procesamiento en cada Pulso.
module Myo_Registro_Sensores (
    input wire clk,
    input wire Valid1,
    input wire Valid2,
    input wire Pulso,
    input wire [11:0] sensor1,
    input wire [11:0] sensor2,
    output wire [11:0] DatoPrincipal,
    output wire [11:0] DatComp
);
    wire [11:0] muestra1_valida;
    wire [11:0] muestra2_valida;

    DIG_Register_BUS #(.Bits(12)) reg_valida_1 (
        .D(sensor1), .C(clk), .en(Valid1), .Q(muestra1_valida)
    );
    DIG_Register_BUS #(.Bits(12)) reg_valida_2 (
        .D(sensor2), .C(clk), .en(Valid2), .Q(muestra2_valida)
    );
    DIG_Register_BUS #(.Bits(12)) reg_proceso_1 (
        .D(muestra1_valida), .C(clk), .en(Pulso), .Q(DatoPrincipal)
    );
    DIG_Register_BUS #(.Bits(12)) reg_proceso_2 (
        .D(muestra2_valida), .C(clk), .en(Pulso), .Q(DatComp)
    );
endmodule
