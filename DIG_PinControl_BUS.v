// Archivo separado de ProyectoMYO_Pru1.v para documentacion modular.
// La definicion original del modulo se conserva sin modificar.
module DIG_PinControl_BUS(
   inout pin,
   input oe,
   input wr,
   output rd
);

  assign pin = oe ? wr : 1'bz;
  assign rd  = oe ? wr : pin ;
endmodule
