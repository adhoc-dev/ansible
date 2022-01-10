#!/usr/bin/env bash
# Para guardar logs
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>log.out 2>&1

# Script para preparar notebooks. Primero hace unas magias y luego aplica el rol de Ansible que corresponda

# Actualizar sistema
echo "[Preparar notebook] Actualizar ambiente de trabajo"
sudo apt-get -y update
sudo apt-get -y upgrade

# Instalar requerimientos
echo "[Preparar notebook] Instalar Git y Stow"
sudo apt-get install -y git stow

# Instalar dependencias de Ansible
echo '[Preparar notebook] Instalar dependencias'
sudo apt-get install -y python3-setuptools

# Instalar Ansible
echo "[Preparar notebook] Instalar Ansible con apt"
sudo apt-get install -y ansible

echo '[Preparar notebook] Notebook lista!'

# Deploy projecto Ansible, implementación
echo "[Projecto Ansible] Clonar repositorio"
git clone https://github.com/adhoc-dev/ansible.git && cd ansible
# Para instalar plugins / colecciones de la comunidad

# Para ejecutar el rol correspondiente, sin función ni validación (y bue)
function launch() {
    read -e -p "Qué rol tendrá quien use este notebook? ('funcional', 'devs' o 'sysadmin' ): " USER_TYPE

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