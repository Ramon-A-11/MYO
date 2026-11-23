# Salida 2 — Servomotor por PWM

[Volver al README](../../README.md) · [Abrir código `Cont_Srv_Con.v`](../../rtl/salidas/02_servomotor/Cont_Srv_Con.v)

## Módulo principal y su código individual

**[Cont_Srv_Con.v](../../rtl/salidas/02_servomotor/Cont_Srv_Con.v)** recibe `clk`, `rst`, `In[3:0]` y produce `pwm`. En el módulo superior, `In` recibe una escala de 0 a 15 derivada del porcentaje de esfuerzo, previamente limitado al 100 %.

## Submódulos compartidos usados por esta salida

- [`DIG_Mul_unsigned.v`](../../rtl/procesamiento/DIG_Mul_unsigned.v): multiplicación para calcular el ancho del pulso.
- [`DIG_Add.v`](../../rtl/comunes/DIG_Add.v): suma de offset del pulso.
- [`DIG_Register_BUS.v`](../../rtl/comunes/DIG_Register_BUS.v): registro del contador.
- [`CompUnsigned.v`](../../rtl/comunes/CompUnsigned.v): comparación de tiempos.
- [`Mux_2x1_NBits.v`](../../rtl/comunes/Mux_2x1_NBits.v): selección y reinicio del contador.

## Funcionamiento observable en el código

Con un reloj de 50 MHz, el contador del PWM se reinicia tras 1 000 000 ciclos, por lo que el período aproximado es **20 ms (50 Hz)**. El umbral en ciclos resulta de `25 000 + In × 6 333`, equivalente aproximadamente a pulsos de **0,5 ms a 2,4 ms** para la escala de entrada 0–15. No se garantiza compatibilidad con un servo concreto sin consultar su hoja de datos y verificar niveles eléctricos y tiempos de pulso.
