# Laboratorio Ansible

Laboratorio de pruebas de ansible, con el objetivo de automatizar la preparación de laptops para puestos Funcionales, Desarrollo y SysAdmins en Adhoc. Para resumir, un espacio experimental y de aprendizaje.

## Recursos / Inspiración / Otros proyectos

- [Documentación oficial](https://docs.ansible.com/)
- [Learn Linux TV - Getting started with Ansible](https://www.youtube.com/playlist?list=PLT98CRl2KxKEUHie1m24-wkyHpEsa4Y70)
- [Ansible Desktop Tutorial - Repositorio](https://github.com/LearnLinuxTV/personal_ansible_desktop_configs)
- [Repositorio jackdbd](https://github.com/jackdbd/ansible-laptop)
- [Repositorio nihiliad](https://github.com/nihiliad/ansible-ubuntu-laptop)
- [5 everyday sysadmin tasks to automate with Ansible](https://opensource.com/article/21/3/ansible-sysadmin)
- [Ansible for dummies](https://miquelmariano.github.io/2017/01/10/ansible-for-dummies/)

### Entorno

- Ubuntu 20.04.3 LTS 64bits (Vagrant 2.2.19 para Test)

## To-do

- [ ] Entorno para devs
  - [ ] Login, tokens Github, Rancher, DockerHub
- [ ] Entorno para sysadmin
  - [ ] Ver más tareas en [script](https://github.com/adhoc-dev/it-nb/blob/main/scripts/sysadmin.sh)
- [ ] Actualización automática (ansible-pull + cron?)
- [ ] Preparar nuevo ambiente de desarrollo
- [ ] incluir dotfiles, keys, bash y otros archivos de configuración (~/.ssh, ~/.bashrc, ~/.bash_aliases, ~/.gitconfig, ~/.pgadmin3, ~/.pgpass, ~/odoo, /opt)
- [ ] Optimizar y automatizar pruebas de roles y tareas

## Preparación equipo

En principio se puede lanzar el proyecto con un script, seleccionando el rol a instalar:

```bash
# Probando deploy con script
$ bash -c "$(curl -fsSL https://raw.githubusercontent.com/adhoc-dev/ansible/master/launch_project.sh)"
$ bash -c "$(curl -fsSL https://tinyurl.com/launch-ansible)"
# Revisar o editar script
$ wget https://raw.githubusercontent.com/adhoc-dev/ansible/master/launch_project.sh
$ sudo bash launch_project.sh
```

### Deploy artesanal ambientes de trabajo (Funcional / Devs / SysAdmin)

```bash
# Dependencias
$ apt install python3-setuptools ansible git stow
# Clonar repositorio con playbooks, tasks, etc.
$ git clone https://github.com/adhoc-dev/ansible && cd ansible
# Deployar roles
$ ansible-playbook --tags "funcional" local.yml -K --verbose
$ ansible-playbook --tags "devs" local.yml -K --verbose
$ ansible-playbook --tags "sysadmin" local.yml -K --verbose
```

## Post instalación

Algunos comandos artesanales pendientes de automatizar:

```bash
# Setear password para conexión rápida de Anydesk
$ echo <some_password> | sudo anydesk --set-password and anydesk --get-id
# Login en gcloud (para sysadmin)
$ gcloud auth login
# Configurar DockerHub, luego de generar el token en la organización
# https://hub.docker.com/settings/security
$ sudo docker login --username adhocsa --password {$DOCKER_TOKEN}
# Configurar ssh en github
$ gh auth login
$ gh ssh-key add /home/$USER/.ssh/id_rsa.pub
# Validar: https://github.com/$USER.keys
# Configurar login a Rancher1
$ rancher --url https://ra.adhoc.com.ar/v1 --access-key {$RANCHER_AC_KEY} --secret-key {$RANCHER_SE_KEY}
# Configurar login a Rancher2
$ rancher2 login https://ra.adhoc.ar/v3 --token {bearer-token}
```

## Ansible: Algunos apuntes

```bash
# instalando usando roles de Galaxy
# -s: use sudo, -K: prompt for sudo password, -a: arguments to module, --become: sudo is default
$ ansible-galaxy install -r requirements.yml
# instalando los roles configurados
# ansible-playbook --> --syntax-check, --check, --list-tasks, --start NAME, --tags ["tag, tag"]
$ ansible-playbook playbook.yml -K
# Para ejecutar un playbook en un host específico (y no todo el inventario)
$ ansible-playbook playbook.yml --limit localhost
# debugging playbook
$ ansible-playbook {playbook} -v
$ ansible -m setup {playbook}
# ejecutar un deployment específico directamente llamando al repositorio
$ ansible-pull -U {repositorio.git} {playbook.yml} -K
```

### Ambiente dev con vagrant

Esto no está automatizado ni nada, sólo me conecto a la VM y ejecuto los comandos...

- [Documentación](https://www.vagrantup.com/)
- [Ansible Provisioner](https://www.vagrantup.com/docs/provisioning/ansible)

```bash
# Lanzar proyecto ubuntu20.04 (crea archivo Vagrantfile)
$ vagrant init generic/ubuntu2004
$ vagrant plugin install vagrant-vbguest # Dependencia
# Levantar VM
$ vagrant up
# Actualizar la imagen de la VM
$ vagrant box update
# Para conocer los datos de la VM, key, etc.
$ vagrant ssh-config
Host default
  HostName 127.0.0.1
  User vagrant
  Port 2222
...
# Para conectarse y ejecutar comandos
$ vagrant ssh
# Guardar y recuperar estados de la box (sin nombre ni parámetros adicionales)
$ vagrant snapshot push
$ vagrant snapshot pop --no-delete
# Destruir VM
$ vagrant destroy
# Para limpiar el ambiente y borrar las boxes
$ vagrant box list | cut -f 1 -d ' ' | xargs -L 1 vagrant box remove -f
```
