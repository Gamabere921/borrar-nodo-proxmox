#!/bin/bash

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

clear
echo -e "${RED}=== MÉTODO FORZADO (NO RECOMENDADO) ===${NC}"
echo -e "${YELLOW}Este método no es recomendado por Proxmox, pero se utiliza si necesitas reusar el nodo sin reinstalar.${NC}"
echo -e "${RED}¡ADVERTENCIA!:${NC}"
echo "1. Separa el almacenamiento compartido antes de continuar."
echo "2. Este proceso puede corromper el cluster si no se hace correctamente."
echo "----------------------------------------"

# Confirmación
echo -e "${YELLOW}¿Estás seguro de continuar?${NC}"
read -p "(s/n): " confirmacion
if [[ ! $confirmacion =~ [sS] ]]; then
    echo -e "${GREEN}Operación cancelada.${NC}"
    exit 0
fi

# Paso 1: Detener servicios
echo -e "\n${GREEN}Deteniendo servicios...${NC}"
systemctl stop pve-cluster corosync || {
    echo -e "${RED}Error al detener servicios!${NC}"
    exit 1
}

# Paso 2: Iniciar pmxcfs en modo local
echo -e "\n${GREEN}Iniciando sistema de archivos en modo local...${NC}"
pmxcfs -l || {
    echo -e "${RED}Error al iniciar pmxcfs!${NC}"
    exit 1
}

# Paso 3: Eliminar archivos de Corosync
echo -e "\n${GREEN}Eliminando archivos de Corosync...${NC}"
rm -f /etc/pve/corosync.conf && rm -rf /etc/corosync/* || {
    echo -e "${RED}Error al eliminar archivos!${NC}"
    exit 1
}

# Paso 4: Reiniciar servicios
echo -e "\n${GREEN}Reiniciando servicios...${NC}"
killall pmxcfs 2>/dev/null
systemctl start pve-cluster || {
    echo -e "${RED}Error al reiniciar pve-cluster!${NC}"
    exit 1
}

# Paso 5: Eliminar archivos residuales
echo -e "\n${GREEN}Eliminando archivos residuales...${NC}"
rm -rf /var/lib/corosync/* || {
    echo -e "${YELLOW}Advertencia: No se pudieron eliminar algunos archivos.${NC}"
}

echo -e "\n${GREEN}¡Proceso completado! Ejecuta el script post-delete-nodo.sh en otro nodo.${NC}"
