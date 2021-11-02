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
$ ansible -m setup {playbook}
$ ansible-pull -U {repositorio.git} {playbook.yml} -K

# Para obtener información sobre el host
$ ansible all -m gather_facts
$ ansible-doc --list
# Install a package via the apt module, and also make sure it's the latest version available
$ ansible all -m apt -a "name=snapd state=latest" --become --ask-become-pass
# Upgrade all the package updates that are available
$ ansible all -m apt -a upgrade=dist --become --ask-become-pass
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
$ ansible-galaxy collection install community.general
```

## To-do

- [ ] Entorno para devs
  - [ ] Install Visual Studio Code extensions
  - [ ] Install docker-compose
  - [ ] Install rancher + token
  - [ ] installing PIP (2 & 3)
  - [ ] Install PyLint for Python 2 and Python 3
  - [ ] Install flake8 and pep8 for Python 2 and Python 3
  - [ ] Install Yakuake
  - [ ] Install lint hook
  - [ ] Enable history-search with arrows
- [ ] Mejorar estructura proyecto
- [ ] Actualización automática (ansible-pull + cron?)
- [ ] Preparar nuevo ambiente de desarrollo
  - [ ] Login, tokens Github, Rancher, DockerHub
- [ ] Entorno para sysadmin
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


