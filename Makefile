# Requiere Icarus Verilog instalado (iverilog)
.PHONY: revisar integridad

revisar:
	iverilog -g2012 -tnull -s ProyectoMYO_Pru1 -f lista_fuentes.f

integridad:
	python3 verificacion/verificar_integridad.py
