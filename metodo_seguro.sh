#!/bin/bash

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

clear
echo -e "${YELLOW}=== MÉTODO SEGURO ===${NC}"
echo -e "${BLUE}Este método es el recomendado por Proxmox para eliminar nodos de forma segura.${NC}"
echo -e "${YELLOW}Requisitos previos:${NC}"
echo "1. Todas las VMs/Contenedores deben estar migradas del nodo"
echo "2. El nodo debe estar APAGADO"
echo -e "${RED}3. ¡No reiniciar el nodo en la misma red después de eliminarlo!${NC}"
echo "----------------------------------------"

# Paso 1: Mostrar nodos activos
echo -e "${GREEN}Nodos actuales en el cluster:${NC}"
pvecm nodes || {
    echo -e "${RED}Error al obtener la lista de nodos!${NC}"
    exit 1
}

# Confirmación
echo -e "\n${YELLOW}¿Estás seguro de continuar?${NC}"
read -p "(s/n): " confirmacion
if [[ ! $confirmacion =~ [sS] ]]; then
    echo -e "${GREEN}Operación cancelada.${NC}"
    exit 0
fi

# Obtener nombre del nodo
read -p "Nombre del nodo a eliminar: " nodo

# Validar entrada
if [[ -z "$nodo" ]]; then
    echo -e "${RED}Error: Debes especificar un nombre de nodo!${NC}"
    exit 1
fi

# Confirmación final
echo -e "\n${RED}¡ADVERTENCIA!${NC}"
echo -e "Asegúrate de que el nodo ${YELLOW}$nodo${NC} está APAGADO y no se reiniciará."
read -p "¿Confirmar eliminación? (s/n): " confirmacion_final

if [[ ! $confirmacion_final =~ [sS] ]]; then
    echo -e "${GREEN}Operación cancelada.${NC}"
    exit 0
fi

# Ejecutar eliminación
echo -e "${GREEN}Eliminando nodo $nodo...${NC}"
pvecm delnode "$nodo" || {
    echo -e "${YELLOW}Nota: El error 'Could not kill node' puede ignorarse si el nodo ya estaba apagado.${NC}"
}

# Limpieza de archivos residuales
echo -e "\n${GREEN}Limpiando archivos residuales...${NC}"
if [[ -d "/etc/pve/nodes/$nodo" ]]; then
    echo -e "${YELLOW}Eliminando /etc/pve/nodes/$nodo...${NC}"
    rm -rf "/etc/pve/nodes/$nodo" && echo -e "${GREEN}¡Archivos eliminados!${NC}" || echo -e "${RED}Error al eliminar los archivos.${NC}"
else
    echo -e "${YELLOW}No se encontraron archivos residuales en /etc/pve/nodes/$nodo.${NC}"
fi

# Mensaje final
echo -e "\n${GREEN}¡Proceso completado! Verifica con 'pvecm status'.${NC}"
