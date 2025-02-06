

# Script de Eliminación de Nodos en Proxmox

Este repositorio contiene scripts para eliminar nodos de un cluster de Proxmox de manera segura o forzada. Los scripts están diseñados para automatizar el proceso y minimizar errores.

---

## **Contenido**
1. [Descripción](#descripción)
2. [Scripts Disponibles](#scripts-disponibles)
3. [Instrucciones de Uso](#instrucciones-de-uso)
4. [Requisitos](#requisitos)
5. [Advertencias](#advertencias)
6. [Contribuciones](#contribuciones)

---

## **Descripción**
Proxmox VE es una plataforma de virtualización que permite gestionar nodos en un cluster. Sin embargo, eliminar un nodo de un cluster puede ser un proceso delicado si no se realiza correctamente. Estos scripts automatizan la eliminación de nodos utilizando dos métodos:

1. **Método Seguro**: Recomendado por Proxmox. Elimina el nodo de manera limpia y segura.
2. **Método Forzado**: Para casos especiales donde el nodo no puede ser eliminado de manera convencional.

Además, se incluye un script de **post-eliminación** para limpiar archivos residuales después de usar el método forzado.

---

## **Scripts Disponibles**

### **1. `menu.sh`**
- **Función**: Menú principal para seleccionar el método de eliminación.
- **Opciones**:
  - Método Seguro.
  - Método Forzado.
  - Post-Eliminación (después del método forzado).
  - Salir.

### **2. `metodo_seguro.sh`**
- **Función**: Elimina un nodo del cluster de manera segura.
- **Pasos**:
  1. Verifica los nodos activos.
  2. Solicita confirmación para eliminar el nodo.
  3. Elimina el nodo con `pvecm delnode`.
  4. Limpia archivos residuales en `/etc/pve/nodes/<nombre-del-nodo>`.

### **3. `metodo_forzado.sh`**
- **Función**: Separa un nodo del cluster sin reinstalar Proxmox.
- **Pasos**:
  1. Detiene los servicios `pve-cluster` y `corosync`.
  2. Inicia el sistema de archivos en modo local.
  3. Elimina los archivos de configuración de Corosync.
  4. Reinicia los servicios y limpia archivos residuales.

### **4. `post-delete-nodo.sh`**
- **Función**: Limpia el nodo eliminado desde otro nodo del cluster.
- **Pasos**:
  1. Elimina el nodo del cluster con `pvecm delnode`.
  2. Ajusta los votos esperados si hay pérdida de quórum.
  3. Elimina archivos residuales en `/etc/pve/nodes/<nombre-del-nodo>`.
  4. Solicita eliminar manualmente las claves SSH en `/etc/pve/priv/authorized_keys`.

---

## **Instrucciones de Uso**

### **1. Clonar el Repositorio**
```bash
git clone https://github.com/tu-usuario/proxmox-remove-node.git
cd proxmox-remove-node
```

### **2. Dar Permisos de Ejecución**
```bash
chmod +x menu.sh metodo_seguro.sh metodo_forzado.sh post-delete-nodo.sh
```

### **3. Ejecutar el Menú Principal**
```bash
./menu.sh
```

### **4. Seleccionar una Opción**
- **Método Seguro**: Sigue las instrucciones en pantalla.
- **Método Forzado**: Asegúrate de separar el almacenamiento compartido antes de continuar.
- **Post-Eliminación**: Ejecuta este script en otro nodo después de usar el método forzado.

---

## **Requisitos**
- Proxmox VE instalado y configurado.
- Acceso root o permisos de superusuario en los nodos.
- Conexión SSH entre los nodos del cluster.

---

## **Advertencias**
- **Método Forzado**: No es recomendado por Proxmox. Úsalo solo si es absolutamente necesario.
- **Almacenamiento Compartido**: Separa el almacenamiento antes de usar el método forzado para evitar conflictos.
- **Pruebas**: Ejecuta estos scripts en un entorno de pruebas antes de usarlos en producción.

---

## **Contribuciones**
¡Las contribuciones son bienvenidas! Si encuentras algún error o tienes sugerencias, abre un issue o envía un pull request.

---
