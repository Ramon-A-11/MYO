// Periodo exacto: 500000 ciclos de 50 MHz = 10 ms (~100 Hz).
module Myo_Generador_Pulso (
    input wire clk,
    input wire rst,
    output wire Pulso
);
    wire [18:0] cuenta;
    wire borrar;
    assign borrar = rst | Pulso;

    DIG_Counter_Nbit #(.Bits(19)) contador (
        .en(1'b1), .C(clk), .clr(borrar), .out(cuenta)
    );
    CompUnsigned #(.Bits(19)) fin_cuenta (
        .a(cuenta), .b(19'd499999), .\= (Pulso)
    );
endmodule
