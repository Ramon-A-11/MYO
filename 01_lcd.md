# Salida 1 — Pantalla LCD 16×2

[Volver al README](../../README.md) · [Ver carpeta LCD](../../rtl/salidas/01_lcd/)

**Función:** presenta el porcentaje de esfuerzo, estados y una barra indicadora. El controlador `Mod_LCD_F` gobierna una LCD de dos líneas en modo de **4 bits**.

## Módulo principal, código completo

- **[Mod_LCD_F.v](../../rtl/salidas/01_lcd/Mod_LCD_F.v):** lógica de inicialización, temporización, caracteres, selección de mensajes, barras y señales `E`, `RS`, `Rw`, `D4`–`D7`. Entradas: `clk`, `rst`, `In_Com`, `In_Norm`, `In_Pre`, `In_Lim`, `In_Exc`, `Prc[7:0]`, `LCD16[4:0]`.

## Submódulos individuales de LCD

- **[Mod_div_8.v](../../rtl/salidas/01_lcd/submodulos/Mod_div_8.v):** cociente y residuo para separar cifras decimales.
- **[Mux_16x1_NBits.v](../../rtl/salidas/01_lcd/submodulos/Mux_16x1_NBits.v):** selección de caracteres por posición de pantalla.
- **[Mux_8x1_NBits.v](../../rtl/salidas/01_lcd/submodulos/Mux_8x1_NBits.v):** selección de estados/cadenas y otras rutas de control.
- **[Mux_4x1.v](../../rtl/salidas/01_lcd/submodulos/Mux_4x1.v):** multiplexación de cuatro señales.
- **[DIG_Register.v](../../rtl/salidas/01_lcd/submodulos/DIG_Register.v):** registro de un bit empleado en el control.

## Módulos compartidos que también utiliza

[`DIG_Register_BUS`](../../rtl/comunes/DIG_Register_BUS.v), [`DIG_Counter_Nbit`](../../rtl/comunes/DIG_Counter_Nbit.v), [`CompUnsigned`](../../rtl/comunes/CompUnsigned.v), [`DIG_Add`](../../rtl/comunes/DIG_Add.v), [`Mux_2x1`](../../rtl/comunes/Mux_2x1.v) y [`Mux_2x1_NBits`](../../rtl/comunes/Mux_2x1_NBits.v).

## ¿Qué muestra?

La lógica construye mensajes de **NORMAL**, **PRECAUCIÓN**, **LÍMITE**, **EXCEDIDO** y **COMPENSACIÓN** (en caracteres ASCII sin tildes), además de porcentaje y barra. `Rw` se conecta permanentemente a cero (escritura). La visualización física depende de la LCD y su conexión correcta.

> Se conserva exactamente el módulo del archivo de origen. El código del LCD se generó con la herramienta Digital; no se ha rediseñado su máquina de estados.
