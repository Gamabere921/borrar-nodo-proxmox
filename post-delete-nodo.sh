#!/bin/bash

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

clear
echo -e "${BLUE}=== SCRIPT POST-ELIMINACIÓN (EJECUTAR EN OTRO NODO) ===${NC}"
echo -e "${YELLOW}Este script elimina por completo el nodo del cluster después del método forzado.${NC}"
echo "----------------------------------------"

# Validar argumento
if [[ -z "$1" ]]; then
    echo -e "${RED}Error: Debes especificar el nombre del nodo!${NC}"
    echo "Ejemplo: ./post-delete-nodo.sh nombre-del-nodo"
    exit 1
fi

nodo="$1"

# Paso 1: Eliminar nodo del cluster
echo -e "\n${GREEN}Eliminando nodo $nodo...${NC}"
pvecm delnode "$nodo"
if [[ $? -ne 0 ]]; then
    echo -e "${YELLOW}Falló por pérdida de quórum. Ajustando votos...${NC}"
    pvecm expected 1
    pvecm delnode "$nodo" || {
        echo -e "${RED}Error crítico: No se pudo eliminar el nodo.${NC}"
        exit 1
    }
fi

# Paso 2: Eliminar carpetas residuales
echo -e "\n${GREEN}Eliminando /etc/pve/nodes/$nodo...${NC}"
rm -rf "/etc/pve/nodes/$nodo" && echo -e "${GREEN}¡Directorio eliminado!${NC}" || {
    echo -e "${YELLOW}Advertencia: No se encontró el directorio.${NC}"
}

# Paso 3: Eliminar claves SSH manualmente
echo -e "\n${YELLOW}Acción manual requerida:${NC}"
echo -e "Elimina las claves SSH de $nodo en:"
echo -e "${BLUE}/etc/pve/priv/authorized_keys${NC}"
echo -e "Usa el comando:"
echo -e "nano /etc/pve/priv/authorized_keys"

echo -e "\n${GREEN}¡Proceso completado!${NC}"
