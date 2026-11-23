# Guía para subir MYO a GitHub desde cero

[Regresar al README](../README.md)

## Paso 1 — Crear una cuenta

1. Ve a [https://github.com/](https://github.com/) y selecciona **Sign up** si todavía no tienes cuenta.
2. Completa el registro y verifica tu correo electrónico.
3. Inicia sesión.

## Paso 2 — Descargar y descomprimir los archivos de MYO

Descarga el archivo ZIP que acompaña la entrega de este proyecto. Extrae el ZIP en una carpeta local. Verifica que dentro de `MYO-FPGA/` estén `README.md`, `rtl/`, `diagramas/` y `documentacion/`.

**Importante:** al publicar por Git, sube la carpeta descomprimida con todos los subdirectorios, **no solo el ZIP**. Así GitHub mostrará los módulos `.v` y los enlaces de la documentación.

## Paso 3 — Crear un repositorio vacío en GitHub

1. Abre [https://github.com/new](https://github.com/new).
2. En **Repository name**, escribe `MYO-FPGA`.
3. En **Description**, puedes escribir: `Prototipo de rehabilitación con sEMG, FPGA Cyclone IV, ADS1115, LCD, PWM, UART y buzzer.`
4. Selecciona **Public** (visible para cualquiera) o **Private** (solo acceso autorizado).
5. **No marques** las opciones para generar un README, un `.gitignore` o una licencia: los dos primeros ya están incluidos y esto evita conflictos en el primer envío.
6. Presiona **Create repository**.

Antes de hacerlo público, revisa si tienes permiso de publicar el PDF original, los nombres y correos electrónicos que aparecen en él y el diagrama del proyecto.

## Paso 4 — Instalar Git en tu equipo

Instala [Git](https://git-scm.com/downloads) para tu sistema operativo. En Windows puedes abrir **Git Bash** dentro de la carpeta del proyecto. En macOS y Linux, puedes usar Terminal.

Comprueba la instalación:

```bash
git --version
```

## Paso 5 — Configurar Git (una sola vez por equipo)

Reemplaza los valores de ejemplo con tu nombre y correo asociados a GitHub:

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu-correo@example.com"
```

## Paso 6 — Abrir una terminal dentro de MYO-FPGA

En Windows puedes entrar a la carpeta `MYO-FPGA` con el explorador, hacer clic derecho y seleccionar **Open Git Bash here** (si aparece). En otras terminales usa `cd` a la ubicación correspondiente.

La terminal debe mostrarte dentro de la carpeta donde está `README.md`.

## Paso 7 — Crear el repositorio local y hacer el primer commit

Ejecuta en este orden:

```bash
git init -b main
git add .
git commit -m "Documentar MYO y separar modulos Verilog"
```

## Paso 8 — Conectarlo con GitHub y subirlo

Reemplaza `TU_USUARIO` con **tu usuario real de GitHub**:

```bash
git remote add origin https://github.com/TU_USUARIO/MYO-FPGA.git
git push -u origin main
```

GitHub puede pedirte autenticarte mediante una ventana del navegador, un administrador de credenciales o un token. **No compartas tu contraseña ni un token**. Si falla la autenticación por HTTPS, revisa las instrucciones oficiales de GitHub sobre credenciales.

## Paso 9 — Comprobar el repositorio publicado

Abre `https://github.com/TU_USUARIO/MYO-FPGA` y verifica:

- Se ve el `README.md` en la portada con título, introducción, arquitectura, conclusiones y bibliografía.
- Están las cuatro subcarpetas dentro de `rtl/salidas/`.
- El archivo del Bluetooth tiene seis submódulos en `submodulos/`.
- Funcionan los enlaces al Verilog de cada salida y al diagrama.

## Paso 10 — Subir cambios futuros

Cada vez que cambies archivos, desde la misma carpeta del proyecto:

```bash
git status
git add .
git commit -m "Actualizar documentacion o modulos de MYO"
git push
```

### Si prefieres una interfaz gráfica

Puedes usar [GitHub Desktop](https://desktop.github.com/): crea primero el repositorio local desde la carpeta `MYO-FPGA`, haz **Commit** y después **Publish repository**. Evita crear una segunda copia del mismo repositorio con archivos duplicados. Como alternativa, usa los pasos de Git anteriores, que preservan todas las carpetas de una vez.

### Documentación oficial

- [Crear un repositorio nuevo](https://docs.github.com/es/repositories/creating-and-managing-repositories/creating-a-new-repository)
- [Agregar código local a GitHub](https://docs.github.com/es/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github)
- [Comenzar con Git](https://docs.github.com/es/get-started/learning-to-code/getting-started-with-git)
