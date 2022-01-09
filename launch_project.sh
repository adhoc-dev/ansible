#!/usr/bin/env bash

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
echo "[Preparar notebook] Instalar colecciones de Ansible"
ansible-galaxy collection install community.general

# Función para aplicar el rol de Ansible según quien use la notebook
function Launch {
# Validar el rol
read -e -p "Qué rol tendrá quien use este notebook? ('F'uncional, 'D'ev o 'S'ysadmin ): [F/D/S] = " USER_TYPE

    while [[ "$USER_TYPE" != "F" && "$USER_TYPE" != "D" && "$USER_TYPE" != "S" ]]; do
        read -e -p "Mmm nop, de nuevo por favor. [F/D/S]: " USER_TYPE
    done

# Ejecutamos playbook / rol correspondiente
    if [[ "$USER_TYPE" == "F" ]]; then
        ansible-playbook --tags "funcional" local.yml -K --verbose
    fi

    if [[ "$USER_TYPE" == "D" ]]; then
        ansible-playbook --tags "devs" local.yml -K --verbose
    fi

    if [[ "$USER_TYPE" == "S" ]]; then
        ansible-playbook --tags "sysadmin" local.yml -K --verbose
    fi
}

Launch