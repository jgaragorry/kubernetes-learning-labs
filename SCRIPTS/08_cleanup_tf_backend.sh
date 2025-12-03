#!/bin/bash
# file: SCRIPTS/08_cleanup_tf_backend.sh
# PROPÓSITO: Elimina completamente el Resource Group del Backend de Terraform.
# OBJETIVO SRE: Eliminar la infraestructura antigua para una reconstrucción limpia.

RG_BACKEND="rg-tfstate-backend-k8s"

echo "--- 🗑️ Eliminando el Resource Group del Backend de Terraform ($RG_BACKEND) ---"
echo "ADVERTENCIA: Esto eliminará la Storage Account y todos los datos contenidos."

# Eliminar el Resource Group (RG) de forma asíncrona (--no-wait) y sin confirmación (--yes).
# Esto limpia el Storage Account, el Container, y el RG en un solo paso.
if az group show --name $RG_BACKEND &>/dev/null; then
    az group delete --name $RG_BACKEND --yes --no-wait
    echo "✅ Eliminación del Resource Group $RG_BACKEND iniciada. Tarda unos minutos en completarse."
else
    echo "Resource Group $RG_BACKEND no existe. No se requiere limpieza."
fi

echo -e "\n--- ⏳ Espere unos minutos antes de ejecutar el script de creación. ---"
echo -e "\n--- ⏳ Esperando 2 minutos para ver los cambios reflejados. ---"
sleep 120
