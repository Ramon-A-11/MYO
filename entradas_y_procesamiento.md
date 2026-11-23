# Entradas y procesamiento digital de MYO

Regresar al [README principal](../README.md).

## 1. Entradas

**[ADS1115_I2C.v](../rtl/entradas/ADS1115_I2C.v)** es el controlador I²C original. Selecciona alternativamente los canales A0 y A1 del convertidor ADS1115, configura la conversión, espera el resultado y expone `sensor1`, `sensor2`, `valid1`, `valid2` y `error`. El bus I²C requiere resistencias de *pull-up* y el código indica dirección 0x48 (ADDR a GND).

**[DIG_PinControl_BUS.v](../rtl/entradas/DIG_PinControl_BUS.v)** implementa la conexión bidireccional a SDA y SCL con conducción de ceros y estado de alta impedancia. SDA se lee; para SCL se usa el mismo adaptador con el puerto de lectura sin conectar.

## 2. Captura y selección de referencia

Las señales `Reset` y `Pulsador` pasan por etapas `DIG_D_FF_1bit`. Un pulso derivado del botón actualiza `VlrMax`, referencia de 12 bits. En reset la referencia se borra; mientras el máximo es cero, el porcentaje se fuerza a cero.

## 3. Muestreo y aritmética

Un contador de 19 bits produce un pulso cada 500 000 ciclos con el reloj de 50 MHz, correspondiente a 1 ms. `Valid1` y `Valid2` almacenan las lecturas válidas del ADC; las lecturas se transfieren a registros de trabajo con el pulso de procesamiento.

- **[Mod_div_19.v](../rtl/procesamiento/Mod_div_19.v):** división entera para el porcentaje de esfuerzo.
- **[Mod_div_11.v](../rtl/procesamiento/Mod_div_11.v):** escalado de porcentaje para visualización/servo.
- **[DIG_Mul_unsigned.v](../rtl/procesamiento/DIG_Mul_unsigned.v):** multiplicación sin signo, utilizada por el procesamiento y el servomotor.
- **[ProyectoMYO_Pru1.v](../rtl/top/ProyectoMYO_Pru1.v):** contiene el circuito integrado de captura, operaciones y estados.

La operación central es `porcentaje = 100 * señal_principal / referencia`, con tratamiento especial de referencia igual a cero. El porcentaje de salida para LCD utiliza los 8 bits de menor peso del resultado.

## 4. Clasificación de estados

| Estado | Condición observada en el Verilog |
|---|---|
| `En_Nor` | Porcentaje menor que 80 y referencia distinta de cero |
| `En_Pre` | Porcentaje entre 80 inclusive y 100 exclusivo |
| `En_Lim` | Porcentaje igual a 100 |
| `En_Exc` | Porcentaje mayor que 100 |
| `En_Com` | Dato de canal secundario >= 3000 y referencia distinta de cero |

El umbral fijo de compensación se compara directamente con cuentas ADC. No se incluye en este código una regla clínica de interpretación de la señal sEMG.

## 5. Bibliotecas de lógica compartida

Los contadores, registros, comparadores, sumadores y multiplexores están en [rtl/comunes/](../rtl/comunes/) y se compilan solo una vez. Su ubicación compartida evita definirlos repetidamente en la carpeta de cada salida.
