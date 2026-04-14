#!/bin/bash
# Script to delete the VM
#devops engineer: Richard Casallas

# 1. Definición de variables
NAMEVM=$1
LOG_FILE="ERRORS_VM.txt"

# 2. Buscar si la VM está corriendo
# Usamos -v para pasar la variable de Bash a awk de forma limpia
VMNAME1=$(VBoxManage list runningvms | awk -v name="$NAMEVM" -F '"' '$0 ~ name {print $2}')
VMNAME2=$(VBoxManage list vms | awk -v name="$NAMEVM" -F '"' '$0 ~ name {print $2}')


if [[ "$VMNAME1" == "$NAMEVM" ]]; then
    echo "La VM '$NAMEVM' está actualmente en ejecución."
    # 3. Intentar apagado controlado
    VBoxManage controlvm "$NAMEVM" poweroff 2>> "$LOG_FILE"
    if [[ $? -ne 0 ]]; then
        echo "Error crítico: No fue posible apagar la VM utilizando VBoxManage. Revisa los logs $LOG_FILE -> SHUTINGDOWN_VM"
        
        # 4. Búsqueda del proceso (PID) si falla el comando anterior
        # Filtramos por el nombre de la VM dinámicamente
        PID=$(ps aux | grep -i "/usr/lib/virtualbox/VirtualBoxVM --comment $NAMEVM" | grep -v grep | awk '{print $2}')
        
        if [ -n "$PID" ]; then
            echo "Intentando matar el proceso de la VM (PID: $PID)..."
            if kill -9 "$PID" 2>> "$LOG_FILE"; then
                echo "Proceso de la VM matado correctamente."
            else
                echo "Error crítico: Revisa los logs $LOG_FILE -> KILLING_VM_PROCESS"
            fi
        else
            echo "No se encontró el proceso de la VM, podría ya estar apagada."
        fi
    else
        echo "VM apagada correctamente."
        vboxmanage unregistervm "$NAMEVM" --delete 2>> "$LOG_FILE"
    fi
elif [[ "$VMNAME2" == "$NAMEVM" ]]; then  
    echo "La VM '$NAMEVM' existe pero no está en ejecución."
    vboxmanage unregistervm "$NAMEVM" --delete 2>> "$LOG_FILE"
else
    echo "La VM '$NAMEVM' no se encontró."
fi

rm -Rf "/home/rcasallas/VirtualBox VMs/$NAMEVM"
echo "archivos asociados a la VM '$NAMEVM' eliminada correctamente."