# Salida 3 — Bluetooth mediante UART TX

[Volver al README](../../README.md) · [Ver carpeta Bluetooth](../../rtl/salidas/03_bluetooth/)

El circuito FPGA **no implementa la radio Bluetooth**; entrega una transmisión UART serial para conectar un módulo Bluetooth UART externo. La interfaz implementada aquí es **transmisión (TX)**; no se incorpora receptor UART.

## Código principal

- **[Mod_Blue.v](../../rtl/salidas/03_bluetooth/Mod_Blue.v):** integra la transmisión de las muestras y el valor de referencia/máximo; conecta los submódulos siguientes.

## Código desglosado: un archivo por submódulo

| Archivo de código | Función |
|---|---|
| [TEMPORIZADOR_ENVIO.v](../../rtl/salidas/03_bluetooth/submodulos/TEMPORIZADOR_ENVIO.v) | Genera `START_PAQUETE` periódicamente, aproximadamente cada 0,1 s con 50 MHz. |
| [REGISTROS_TX.v](../../rtl/salidas/03_bluetooth/submodulos/REGISTROS_TX.v) | Captura 12 bits antes de transmitirlos. |
| [SEPARADOR_12_A_8.v](../../rtl/salidas/03_bluetooth/submodulos/SEPARADOR_12_A_8.v) | Divide el dato de 12 bits en byte alto (nibble útil) y byte bajo. |
| [CONTROL_PAQUETES.v](../../rtl/salidas/03_bluetooth/submodulos/CONTROL_PAQUETES.v) | Máquina de estados para enviar primero byte alto y luego byte bajo. |
| [UART_COMPLETO.v](../../rtl/salidas/03_bluetooth/submodulos/UART_COMPLETO.v) | Emisor UART con bits de inicio, 8 bits de datos y bit de parada. |
| [Decoder3.v](../../rtl/salidas/03_bluetooth/submodulos/Decoder3.v) | Decodifica estados de 3 bits utilizados por controladores UART. |

## Formato implementado

El módulo separa cada muestra de 12 bits en **dos bytes UART**. El byte bajo contiene los bits `[7:0]`; el byte alto lleva los bits `[11:8]` en su nibble bajo, los bits `[6:4]` a cero y un indicador de tipo de paquete en el bit 7. El código selecciona enviar muestras del sensor principal o valor de máximo/referencia, mediante su lógica de eventos. No se incluye protocolo de aplicación ni un programa para almacenar datos en un teléfono/computador.

**Velocidad nominal:** aproximadamente **9600 baudios** con reloj FPGA a 50 MHz (contador hasta 5207, es decir, 5208 ciclos/bit). La recepción debe configurarse de acuerdo con el formato UART del transmisor, típicamente 8N1.

> El parámetro de entrada `RESET_N` en `Mod_Blue` está nombrado de forma confusa en el Verilog: en esta integración está conectado a `rst` y se utiliza como reset activo alto. Revisar esa interfaz antes de reutilizar el módulo de forma independiente.
