#!/bin/bash

#Si no pueden usar ./run.sh ejecuten: chmod +x run.sh

README="README.md"

# El archivo existe?
if [[ ! -f "$README" ]]; then
    echo "Error: No se encontró el archivo $README"
    exit 1
fi

echo "Ejecutando comandos del README.md..."
# Usar `while read` en lugar de `while IFS= read -r`
# Esto manejará mejor los saltos de línea extra
while IFS= read -r line || [[ -n "$line" ]]; do
    # Ignorar líneas vacías
    [[ -z "$line" ]] && continue
    
    # Ejecutar la línea
    echo "Ejecutando: $line"
    eval "$line"
done < "$README"

echo "Comandos ejecutados con éxito."
