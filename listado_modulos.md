# Inventario de los 28 módulos Verilog

[Regresar al README](../README.md)

Todos los enlaces apuntan a **archivos `.v` individuales** y corresponden a módulos del archivo exportado originalmente.

> No copies todos los archivos de la carpeta `respaldo_codigo_original.v` al compilar: produciría módulos duplicados.

## Módulo superior

1. [`ProyectoMYO_Pru1.v`](../rtl/top/ProyectoMYO_Pru1.v)

## Entradas y controlador ADC

2. [`ADS1115_I2C.v`](../rtl/entradas/ADS1115_I2C.v)
3. [`DIG_PinControl_BUS.v`](../rtl/entradas/DIG_PinControl_BUS.v)

## Procesamiento aritmético auxiliar

4. [`Mod_div_19.v`](../rtl/procesamiento/Mod_div_19.v)
5. [`Mod_div_11.v`](../rtl/procesamiento/Mod_div_11.v)
6. [`DIG_Mul_unsigned.v`](../rtl/procesamiento/DIG_Mul_unsigned.v)

## Salida LCD y submódulos

7. [`Mod_LCD_F.v`](../rtl/salidas/01_lcd/Mod_LCD_F.v)
8. [`Mod_div_8.v`](../rtl/salidas/01_lcd/submodulos/Mod_div_8.v)
9. [`DIG_Register.v`](../rtl/salidas/01_lcd/submodulos/DIG_Register.v)
10. [`Mux_16x1_NBits.v`](../rtl/salidas/01_lcd/submodulos/Mux_16x1_NBits.v)
11. [`Mux_8x1_NBits.v`](../rtl/salidas/01_lcd/submodulos/Mux_8x1_NBits.v)
12. [`Mux_4x1.v`](../rtl/salidas/01_lcd/submodulos/Mux_4x1.v)

## Salida servomotor

13. [`Cont_Srv_Con.v`](../rtl/salidas/02_servomotor/Cont_Srv_Con.v)

## Salida Bluetooth y submódulos

14. [`Mod_Blue.v`](../rtl/salidas/03_bluetooth/Mod_Blue.v)
15. [`TEMPORIZADOR_ENVIO.v`](../rtl/salidas/03_bluetooth/submodulos/TEMPORIZADOR_ENVIO.v)
16. [`REGISTROS_TX.v`](../rtl/salidas/03_bluetooth/submodulos/REGISTROS_TX.v)
17. [`Decoder3.v`](../rtl/salidas/03_bluetooth/submodulos/Decoder3.v)
18. [`CONTROL_PAQUETES.v`](../rtl/salidas/03_bluetooth/submodulos/CONTROL_PAQUETES.v)
19. [`UART_COMPLETO.v`](../rtl/salidas/03_bluetooth/submodulos/UART_COMPLETO.v)
20. [`SEPARADOR_12_A_8.v`](../rtl/salidas/03_bluetooth/submodulos/SEPARADOR_12_A_8.v)

## Salida buzzer

21. [`Mod_Buzzer.v`](../rtl/salidas/04_buzzer/Mod_Buzzer.v)

## Primitivas compartidas

22. [`DIG_D_FF_1bit.v`](../rtl/comunes/DIG_D_FF_1bit.v)
23. [`DIG_Register_BUS.v`](../rtl/comunes/DIG_Register_BUS.v)
24. [`Mux_2x1_NBits.v`](../rtl/comunes/Mux_2x1_NBits.v)
25. [`CompUnsigned.v`](../rtl/comunes/CompUnsigned.v)
26. [`DIG_Counter_Nbit.v`](../rtl/comunes/DIG_Counter_Nbit.v)
27. [`Mux_2x1.v`](../rtl/comunes/Mux_2x1.v)
28. [`DIG_Add.v`](../rtl/comunes/DIG_Add.v)
