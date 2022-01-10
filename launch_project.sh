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

# Para ejecutar el rol correspondiente, sin función ni validación (y bue)
read -e -p "Qué rol tendrá quien use este notebook? ('funcional', 'dev' o 'sysadmin' ): " USER_TYPE
ansible-playbook --tags "$USER_TYPE" local.yml -K --verbose