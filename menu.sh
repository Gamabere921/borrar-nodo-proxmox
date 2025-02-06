#!/bin/bash

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

clear
echo -e "${BLUE}=== Script de Eliminación de Nodos Proxmox ===${NC}"
echo -e "${YELLOW}Selecciona una opción:${NC}"
echo "1) Método Seguro (recomendado)"
echo "2) Método Forzado (avanzado)"
echo "3) Post-Eliminación (después del método forzado)"
echo -e "${RED}4) Salir${NC}"

read -p "Opción: " opcion

case $opcion in
    1)
        ./metodo_seguro.sh
        ;;
    2)
        ./metodo_forzado.sh
        ;;
    3)
        read -p "Nombre del nodo a eliminar: " nodo
        ./post-delete-nodo.sh "$nodo"
        ;;
    4)
        echo -e "${GREEN}Saliendo...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Opción inválida!${NC}"
        exit 1
        ;;
esac
