// Porcentaje LCD (8 bits), nivel LCD (0..16), servo (0..15).
// La barra/segmentacion y el servo se limitan al 100 %.
module Myo_Escalado_Segmentos (
    input wire [18:0] Porcentaje,
    output wire [7:0] Prc,
    output wire [4:0] LCD16,
    output wire [3:0] Servo15
);
    wire saturar;
    wire [7:0] porcentaje_limitado;
    wire [15:0] producto_lcd;
    wire [15:0] producto_servo;
    wire [10:0] nivel_lcd;
    wire [10:0] nivel_servo;
    assign saturar = (Porcentaje >= 19'd100);
    assign Prc = Porcentaje[7:0];

    Mux_2x1_NBits #(.Bits(8)) limitar_porcentaje (
        .sel(saturar), .in_0(Porcentaje[7:0]),
        .in_1(8'd100), .out(porcentaje_limitado)
    );
    DIG_Mul_unsigned #(.Bits(8)) mul_lcd (
        .a(porcentaje_limitado), .b(8'd16), .mul(producto_lcd)
    );
    DIG_Mul_unsigned #(.Bits(8)) mul_servo (
        .a(porcentaje_limitado), .b(8'd15), .mul(producto_servo)
    );
    Mod_div_11 div_lcd (
        .a(producto_lcd[10:0]), .b(11'd100), .q(nivel_lcd)
    );
    Mod_div_11 div_servo (
        .a(producto_servo[10:0]), .b(11'd100), .q(nivel_servo)
    );
    assign LCD16 = nivel_lcd[4:0];
    assign Servo15 = nivel_servo[3:0];
endmodule
