# Laboratorio Ansible

Laboratorio de pruebas de ansible, con el objetivo de automatizar la preparación de laptops para puestos Funcionales, Desarrollo y SRE en Adhoc. Sobre todo un espacio experimental y de aprendizaje...

## Recursos / Inspiración

- [Documentación oficial](https://docs.ansible.com/)
- [Learn Linux TV - Getting started with Ansible](https://www.youtube.com/playlist?list=PLT98CRl2KxKEUHie1m24-wkyHpEsa4Y70)
- [Ansible Desktop Tutorial - Repositorio](https://github.com/LearnLinuxTV/personal_ansible_desktop_configs)
- [Repositorio jackdbd](https://github.com/jackdbd/ansible-laptop)
- [Repositorio nihiliad](https://github.com/nihiliad/ansible-ubuntu-laptop)
- [Sample Ansible setup](https://docs.ansible.com/ansible/latest/user_guide/sample_setup.html)
- [5 everyday sysadmin tasks to automate with Ansible](https://opensource.com/article/21/3/ansible-sysadmin)
- [Ansible for dummies](https://miquelmariano.github.io/2017/01/10/ansible-for-dummies/)

### Entornos

- PRD: Ubuntu 20.04.3 LTS 64bits
- LAB: Vagrant 2.2.19

## To-do

- [ ] Entorno para devs
  - [x] Install Visual Studio Code extensions
  - [x] Install docker-compose
  - [x] installing PIP (2 & 3)
  - [x] Install PyLint for Python 2 and Python 3
  - [x] Install flake8 and pep8 for Python 2 and Python 3
  - [x] Install Yakuake
  - [ ] Install lint hook
  - [x] Enable history-search with arrows
  - [ ] Install rancher1 + rancher2
- [ ] Actualización automática (ansible-pull + cron?)
- [ ] Preparar nuevo ambiente de desarrollo
  - [ ] Login, tokens Github, Rancher, DockerHub
- [ ] Entorno para sysadmin
  - [x] Instalar terraform
  - [x] Instalar gcloud
  - [ ] Ver más tareas en [script](https://github.com/adhoc-dev/it-nb/blob/main/scripts/sysadmin.sh)
- [ ] incluir dotfiles, keys, bash y otros archivos de configuración (~/.ssh, ~/.bashrc, ~/.bash_aliases, ~/.gitconfig, ~/.pgadmin3, ~/.pgpass, ~/odoo, /opt)

## Preparación equipo

Esto fue cambiando muchas veces, desde algo más artesanal instalando con comandos, hasta esta versión más automágica:

```bash
# Probando deploy con script
$ curl https://raw.githubusercontent.com/adhoc-dev/ansible/master/launch_project.sh | sudo bash
# El script actualiza paquetes, instala algunas dependencias, clona el proyecto y ejecuta el playbook que corresponda según el rol (aun en experimentación)
$ ansible --version
ansible 2.9.6
```

### Deploy artesanal ambientes de trabajo (Funcional / Devs / SRE)

```bash
# Clonar repositorio con playbooks, tasks, etc.
$ git clone https:https://github.com/adhoc-dev/ansible && cd ansible
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

Esto no está automatizado aun, sólo me conecto a la VM y ejecuto los comandos...

- [Documentación](https://www.vagrantup.com/)
- [Ansible Provisioner](https://www.vagrantup.com/docs/provisioning/ansible)

```bash
# Lanzar proyecto ubuntu20.04 (crea archivo Vagrantfile)
$ vagrant init ubuntu/focal64
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
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/dib/Private/ansible/.vagrant/machines/default/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL
# Para conectarse y ejecutar comandos
$ vagrant ssh
# Destruir VM
$ vagrant destroy
```
