# Salida 4 — Buzzer de alerta

[Volver al README](../../README.md) · [Ver código `Mod_Buzzer.v`](../../rtl/salidas/04_buzzer/Mod_Buzzer.v)

## Código individual

- **[Mod_Buzzer.v](../../rtl/salidas/04_buzzer/Mod_Buzzer.v):** entrada `EXC` (excedido), entrada `COM` (posible compensación), `clk`, `rst` y salida `Buzz`.

## Módulos auxiliares compartidos

- [`DIG_D_FF_1bit.v`](../../rtl/comunes/DIG_D_FF_1bit.v): registro de estado.
- [`DIG_Counter_Nbit.v`](../../rtl/comunes/DIG_Counter_Nbit.v): contador de duración.
- [`CompUnsigned.v`](../../rtl/comunes/CompUnsigned.v): comparación del contador.

## Comportamiento

La alerta se habilita si `EXC` o `COM` están activos. `Buzz` está expresado como `~(s1 & ~rst)`, de modo que la alarma se encuentra **activa en nivel bajo**. La comparación del contador utiliza 25 000 000 ciclos, aproximadamente 0,5 s a 50 MHz. El patrón acústico concreto depende de la lógica de control y del tipo de buzzer empleado; no se debe describir como una frecuencia de tono programada sin verificar el hardware.
