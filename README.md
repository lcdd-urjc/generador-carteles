# Generador de carteles
Generador de carteles a partir de una plantilla SVG. El programa genera automáticamente un código QR, rellena la plantilla con los datos proporcionados y exporta el resultado en formato PDF y PNG.

## Requisitos
### Usar con Nix (recomendado)
Para ejecutar el generador con Nix, necesitas tener habilitadas las [flakes](https://wiki.nixos.org/wiki/Flakes#Setup).

No es necesario instalar manualmente las dependencias. Tampoco es necesario instalar las fuentes utilizadas por la plantilla en tu sistema si incluyes los archivos `.ttf` correspondientes en el directorio `fonts/` del proyecto.

Puedes ejecutar el generador desde el directorio raíz del repositorio con:
```bash
nix run . -- ruta-a-la-plantilla.svg DD/MM/YYYY AULARIO AULA [URL]
```
 
> [!TIP]
> No es necesario clonar el repositorio. Puedes ejecutar el generador directamente con:
> ```bash
> nix run github:lcdd-urjc/generador-carteles -- ruta-a-la-plantilla.svg DD/MM/YYYY AULARIO AULA [URL]
> ```
> Si has publicado cambios nuevos y Nix sigue utilizando una referencia almacenada en caché, puedes forzar la actualización añadiendo `--refresh` al comando.

### Usar sin Nix
Si prefieres ejecutar el generador directamente, necesitas instalar previamente las dependencias y las fuentes utilizadas por la plantilla.

#### Dependencias necesarias
* [`file`](https://darwinsys.com/file/)
* [`librsvg`](https://gitlab.gnome.org/GNOME/librsvg)
* [`qrencode`](https://fukuchi.org/works/qrencode/)

#### Otras dependencias
Estas herramientas también son necesarias, aunque suelen estar instaladas por defecto en la mayoría de los sistemas Unix:
* [`awk`](https://www.gnu.org/software/gawk/)
* [`bash`](https://www.gnu.org/software/bash/)
* [`coreutils`](https://www.gnu.org/software/coreutils/)
* [`grep`](https://www.gnu.org/software/grep/)
* [`sed`](https://www.gnu.org/software/sed/)

Una vez instaladas todas las dependencias y las fuentes, ejecuta el script.

# Uso
El generador recibe cuatro argumentos obligatorios y uno opcional:
```bash
./generar.sh PLANTILLA FECHA AULARIO AULA [URL]
```

|Argumento|Descripción|
|---|---|
|PLANTILLA|Ruta al archivo SVG que se utilizará como plantilla.|
|FECHA|Fecha en formato DD/MM/YYYY. El generador la formatea automáticamente y sustituye el marcador {fecha}.|
|AULARIO|Nombre del aulario. Sustituye el marcador {aulario} de la plantilla. Se recomienda ponerlo entrecomillado, ya que suele contener espacios.|
|AULA|Identificador o nombre del aula. Sustituye el marcador {aula} de la plantilla.|
|URL|Opcional. Dirección web utilizada para generar el código QR. Por defecto, se utiliza https://cavernadeldragon.org.|

## Ejemplo
Para generar un cartel para el aula 208 de Laboratorios 1, con fecha del 23 de octubre de 2026 y un QR que apunte a https://cavernadeldragon.org/eventos/23, ejecuta:
```bash
nix run github:lcdd-urjc/generador-carteles -- plantilla.svg 23/10/2026 "Lab 1" 208 https://cavernadeldragon.org/eventos/23
```

Si utilizas el generador sin Nix, ejecuta el mismo comando sustituyendo la primera parte por `./generar.sh`.

Si omites el argumento URL, el código QR apuntará a https://cavernadeldragon.org.

# Plantillas
La plantilla se define mediante un archivo SVG. El generador utiliza los siguientes marcadores para completar el cartel:

* `{fecha}`: fecha formateada a partir del argumento proporcionado.
* `{aulario}`: nombre del aulario.
* `{aula}`: nombre o identificador del aula.
* `{qr}`: qr generado.

Asegúrate de que las fuentes utilizadas por la plantilla estén instaladas en el sistema.

# Resultados

Los resultados se generan en el mismo directorio que la plantilla.

A partir de la plantilla y los argumentos proporcionados, el generador crea:

* **SVG**: plantilla con todos los datos rellenos.
* **PDF**: versión del cartel lista para imprimir.
* **PNG**: versión del cartel en formato de imagen.
* **Código QR**: generado a partir de la URL especificada.
