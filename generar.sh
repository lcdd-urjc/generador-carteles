#!/usr/bin/env bash
set -e

USO="Uso: $0 PLANTILLA DD/MM/YYYY AULARIO AULA [URL]"
LOCALE="es_ES.UTF-8"

# Mirar si hay --help
for arg in "$@"; do
    if [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
        echo "$USO"
        exit 0
    fi
done

if [[ $# -lt 4 || $# -gt 5 ]]; then
    echo "$USO" >&2
    exit 1
fi

PLANTILLA="$1"
FECHA="$2"
AULARIO="$3"
AULA="$4"
URL="${5:-https://cavernadeldragon.org}"

DIRPLANTILLA="$(dirname "$PLANTILLA")"
NOMBREPLANTILLA="$(basename "$PLANTILLA" .svg)"
OUTPUTNAME="$DIRPLANTILLA/$NOMBREPLANTILLA-${FECHA//\//-}"

# Validar plantilla
if [[ ! -f "$PLANTILLA" ]]; then
    echo "Error: Plantilla no encontrada: $PLANTILLA" >&2
    echo "$USO" >&2
    exit 1
fi

if ! file --mime-type "$PLANTILLA" | grep -q 'image/svg+xml'; then
  echo "$PLANTILLA no es un SVG" >&2
  exit 1
fi

DIA=${FECHA:0:2}
MES=${FECHA:3:2}
ANIO=${FECHA:6:4}

# Validar fecha
if ! [[ "$FECHA" =~ ^[0-9]{2}/[0-9]{2}/[0-9]{4}$ ]] ||
   ! { date -d "$ANIO-$MES-$DIA" \
        "+%d/%m/%Y" 2>/dev/null | grep -qx "$FECHA"; }; then
    echo "Fecha incorrecta: $FECHA"
    echo "$USO" >&2
    exit 1
fi

# Validar aula
if ! [[ "$AULA" =~ ^[0-9S][0-9]{2}$ ]]; then
    echo "Aula incorrecta: $AULA" >&2
    echo "El aula debe tener 3 cifras o empezar por S si es un sótano. (ej. 007, 102, S07)" >&2
    echo "$USO" >&2
    exit 1
fi

# Formatear fecha
# toupper $1 es necesario para que las tildes queden en mayúscula también
FECHAFORMATEADA=$(LC_ALL="$LOCALE" LC_TIME="$LOCALE" date -d "$ANIO-$MES-$DIA" "+%A %d %B" | awk '{ $1 = toupper($1); $3 = toupper(substr($3,1,1)) substr($3,2); print }')

# Generar QR
qrencode -o "$OUTPUTNAME-qr.png" -s 6 -m 5 "$URL" && echo "$OUTPUTNAME-qr.png generado"

# Rellenar plantilla
sed \
    -e "s|{fecha}|$FECHAFORMATEADA|g" \
    -e "s|{aulario}|$AULARIO|g" \
    -e "s|{aula}|$AULA|g" \
    -e "s|{qr}|$(basename "$OUTPUTNAME")-qr.png|g" \
    "$PLANTILLA" > "$OUTPUTNAME.svg" && echo "$OUTPUTNAME.svg generado"


# Convertir a png y pdf
rsvg-convert "$OUTPUTNAME.svg" > "$OUTPUTNAME.png" && echo "$OUTPUTNAME.png generado"
rsvg-convert --format=pdf "$OUTPUTNAME.svg" > "$OUTPUTNAME.pdf" && echo "$OUTPUTNAME.pdf generado"
