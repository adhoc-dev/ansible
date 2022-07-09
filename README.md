# Laboratorio Ansible

Laboratorio de pruebas de ansible, con el objetivo de automatizar la preparación de laptops para puestos Funcionales, Desarrollo y SysAdmins en Adhoc. Para resumir, un espacio experimental y de aprendizaje para preparar "notebooks as a service".  
Para información interna más detallada, procedimiento, pendientes, etc., revisar [este documento](https://docs.google.com/document/d/1iDylKWfjRL9SO_GR_1j7HjQhFixYsFz9Vv3Mi0WstPQ).

## Entornos

- Branch > Master > Ubuntu 20.04.3 LTS 64bits
- Branch > 22.04 > Ubuntu 22.04 LTS 64bits

## Preparación equipo

En principio se puede lanzar el proyecto con un script (que además instala dependencias necesarias), seleccionando el rol a instalar:

```bash
# Probando deploy con script
$ bash -c "$(curl -fsSL https://raw.githubusercontent.com/adhoc-dev/ansible/master/launch_project.sh)"
$ bash -c "$(curl -fsSL https://tinyurl.com/launch-ansible)"
# Seleccionar funcional, dev o sysadmin según corresponda
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

Algunos comandos y tareas artesanales pendientes de automatizar:

```bash
# Setear password para conexión rápida de Anydesk
# Login en gcloud (para sysadmin)
$ gcloud auth login
# Configurar DockerHub, luego de generar el token en la organización
# https://hub.docker.com/settings/security
$ sudo docker login --username adhocsa --password {$DOCKER_TOKEN}
# Configurar ssh en github
$ gh auth login
$ gh ssh-key add /home/$USER/.ssh/id_rsa.pub
# Validar: https://github.com/$USER.keys
# Configurar login a Rancher2
$ rancher2 login https://ra.adhoc.ar/v3 --token {bearer-token}
```
