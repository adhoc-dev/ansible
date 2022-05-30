#!/usr/bin/env bash
# Script para preparar notebooks. Primero hace unas magias y luego aplica el rol de Ansible que corresponda

# Actualizar sistema
echo "[PREPARAR NOTEBOOK] ACTUALIZAR AMBIENTE DE TRABAJO"
sudo apt-get -y update
sudo apt-get -y upgrade

# Instalar requerimientos
echo "[PREPARAR NOTEBOOK] INSTALAR GIT Y STOW"
sudo apt-get install -y git stow

# Instalar dependencias de Ansible
echo '[PREPARAR NOTEBOOK] INSTALAR DEPENDENCIAS'
sudo apt-get install -y python3-setuptools

# Instalar Ansible
echo "[PREPARAR NOTEBOOK] INSTALAR ANSIBLE"
sudo apt-get install -y ansible

echo '[PREPARAR NOTEBOOK] NOTEBOOK LISTA!'

# Deploy projecto Ansible, implementación
echo "[PROYECTO ANSIBLE] CLONAR REPOSITORIO"
git clone https://github.com/adhoc-dev/ansible.git
cd ansible

[WARNING]: log file at /var/log/ansible.log is not writeable and we cannot create it, aborting


# Para ejecutar el rol correspondiente, sin función ni validación (y bue)
function launch {
    read -e -p "PARA QUÉ ROL SE USARÁ ESTA NOTEBOOK? ('funcional', 'devs' o 'sysadmin' ): " USER_TYPE

    while [[ "$USER_TYPE" != "funcional" && "$USER_TYPE" != "devs" && "$USER_TYPE" != "sysadmin" ]]; do
        read -e -p "Ingresar el rol correctamente ('funcional', 'devs' o 'sysadmin'): " USER_TYPE
    done

    if [[ "$USER_TYPE" == "funcional" ]]; then
        ansible-playbook --tags "$USER_TYPE" local.yml -K --verbose
    fi

    if [[ "$USER_TYPE" == "devs" ]]; then
        ansible-playbook --tags "$USER_TYPE" local.yml -K --verbose
    fi

    if [[ "$USER_TYPE" == "sysadmin" ]]; then
        ansible-playbook --tags "$USER_TYPE" local.yml -K --verbose
    fi
}

launch
