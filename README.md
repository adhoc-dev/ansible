# Laboratorio Ansible

Laboratorio de pruebas de ansible, con la idea de automatizar la preparación de laptops / equipos de trabajo. Sobre todo un espacio experimental y de aprendizaje...

## Recursos

- [Documentación oficial](https://docs.ansible.com/)
- [Learn Linux TV - Getting started with Ansible](https://www.youtube.com/playlist?list=PLT98CRl2KxKEUHie1m24-wkyHpEsa4Y70)
- [Ansible Desktop Tutorial - Repositorio](https://github.com/LearnLinuxTV/personal_ansible_desktop_configs)
- [Repositorio](https://github.com/jackdbd/ansible-laptop)
- [Repositorio](https://github.com/nihiliad/ansible-ubuntu-laptop)
- [Sample Ansible setup](https://docs.ansible.com/ansible/latest/user_guide/sample_setup.html)
- [5 everyday sysadmin tasks to automate with Ansible](https://opensource.com/article/21/3/ansible-sysadmin)
- [Ansible for dummies](https://miquelmariano.github.io/2017/01/10/ansible-for-dummies/)

### Entorno

- OS Name: Ubuntu 20.04.3 LTS
- OS Type: 64bits

## Ansible: Teoría

```bash
# instalando usando roles de Galaxy
# -s: use sudo, -K: prompt for sudo password, -a: arguments to module, --become: sudo is default
$ ansible-galaxy install -r requirements.yml
# instalando los roles configurados
# ansible-playbook --> --syntax-check, --check, --list-tasks, --start NAME, --tags ["tag, tag"]
$ ansible-playbook playbook.yml -K
# debugging playbook
$ ansible-playbook {playbook} -v
$ ansible -m setup {playbook}
# ejecutar un deployment específico directamente llamando al repositorio
$ ansible-pull -U {repositorio.git} {playbook.yml} -K
```

```yml
# Puede utilizarse regex para parsear sólo el int del print de --version
- set_fact:
    docker_compose_current_version: "{{ docker_compose_vsn.stdout | regex_search('(\\d+(\\.\\d+)+)') }}"
  when:
    - docker_compose_vsn.stdout is defined
```

```yml
# Para definir variables
docker_compose_version: "1.29.2"
# Asignar variables de entorno
vars:
  cloudflare_email:     "{{ lookup('env','CF_EMAIL') }}"
  cloudflare_api_token: "{{ lookup('env','CF_API_TOKEN') }}"
  cloudflare_zone:      "example.com"
```

### Roles

```yml
---
- hosts: laptop
  roles:
    - common
    - git_homedir
    # roles can also be used conditionally
    - { role: x11, when: ansible_distribution != "MacOSX" }
    - { role: erlang, when: install_erlang is defined }
```

## Preparar ambiente

```bash
# Instalar dependencias
$ apt install git ansible stow
$ ansible --version
ansible 2.9.6
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/diego/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Jun  2 2021, 10:49:15) [GCC 9.4.0]
# Para instalar plugins / colecciones de la comunidad
$ ansible-galaxy collection install community.general
```

### Ambiente dev con vagrant

- [Documentación](https://www.vagrantup.com/)
- [Ansible Provisioner](https://www.vagrantup.com/docs/provisioning/ansible)


```bash
$ vagrant init # Lanzar proyecto base para editar
$ vagrant up # Levantar VM ya preconfigurada

# Para usar una VM como ambiente de test
$ vagrant ssh-config # Para conocer los datos de la VM, key, etc.
Host ubuntu-test
  HostName 127.0.0.1
  User vagrant
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/bolli/proyectos/ansible/.vagrant/machines/ubuntu-test/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL
# Agregar host en archivo / inventario
[vagrant]
ubuntu-test ansible_host=127.0.0.1 ansible_port=2222 ansible_ssh_user=vagrant ansible_ssh_private_key_file=/home/bolli/proyectos/ansible/.vagrant/machines/ubuntu-test/virtualbox/private_key
# Test conexión
$ ansible ubuntu-test -m ping    
ubuntu-test | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

# Vagrant’s Ansible provisioning feature (ver bloque en Vagrantifle)











```



## To-do

- [ ] Entorno para devs
  - [ ] Importar entorno funcionales
  - [x] Install Visual Studio Code extensions
  - [x] Install docker-compose
  - [ ] installing PIP (2 & 3)
  - [ ] Install PyLint for Python 2 and Python 3
  - [ ] Install flake8 and pep8 for Python 2 and Python 3
  - [x] Install Yakuake
  - [ ] Install lint hook
  - [ ] Enable history-search with arrows
  - [ ] Install rancher
- [ ] Mejorar estructura proyecto - [Guía](https://ansible.github.io/workshops/exercises/ansible_rhel/1.7-role/README.es.html)
- [ ] Actualización automática (ansible-pull + cron?)
- [ ] Preparar nuevo ambiente de desarrollo
  - [ ] Login, tokens Github, Rancher, DockerHub
- [ ] Entorno para sysadmin
  - [ ] Instalar terraform
  - [ ] Instalar gcloud
- [ ] incluir dotfiles, keys, bash y otros archivos de configuración

### Modelo dotfiles

```bash
$ mkdir ~/repos
$ git clone https://.../dotfiles.git
$ git clone https://.../ansible-laptop.git

# setup bash
$ rm ~/.bashrc
$ rm ~/.bash_logout
$ cd ~/repos/dotfiles/bash
$ stow . --target ~

# setup ssh
$ cd ~/repos/dotfiles/ssh
$ stow . —target ~
# copiar keys
$ cp -r /media/jack/PATH-TO-SSH-KEYS-ON-USB-STICK/ ~/.ssh
# fix permisos
$ chmod 400 ~/.ssh/keys/*
$ chmod 400 ~/.ssh/conf.d/*
$ chmod 400 ~/.ssh/config
# add to ssh-agent
$ source ~.bashrc
$ ssh github

$ cd ~/repos/ansible-laptop
$ mkdir ~/bin
```
