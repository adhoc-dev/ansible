# Basic installation.

~/.ssh
~/.bashrc
~/.bash_aliases
~/.gitconfig
~/.pgadmin3
~/.pgpass
~/odoo
~/Escritorio
/opt



        PrintMsg "installing PIP (2 & 3)"
        # pip2
        curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
        sudo python2 get-pip.py
        rm get-pip.py
        # pip3
        curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
        sudo python3 get-pip.py
        rm get-pip.py



        # Increase fs.inotify.max_user_watches value.
        PrintMsg "Increase fs.inotify.max_user_watches value..."
        sudo sh -c 'echo "fs.inotify.max_user_watches=524288" > /etc/sysctl.conf'

        # Install PyLint for Python 2 and Python 3
        PrintMsg "Installing PyLint for Python 2 and Python 3"
        sudo pip2 install pylint && sudo pip2 install --upgrade git+https://github.com/oca/pylint-odoo.git
        sudo pip3 install --upgrade git+https://github.com/oca/pylint-odoo.git

        PrintMsg "Set python defaults"
        # Hacemos el update alternatives para que python2 corra por defecto (mas alto es mayor)
        sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 2
        sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1


        # Configure UI and improve UX.

        # Install the Extensions using https://github.com/cyfrost/install-gnome-extensions/
        PrintMsg "Install Gnome extensions"
        AptInstall curl wget jq unzip
        rm -f ./install-gnome-extensions.sh
        wget -N -q "https://raw.githubusercontent.com/cyfrost/install-gnome-extensions/master/install-gnome-extensions.sh" -O ./install-gnome-extensions.sh && chmod +x install-gnome-extensions.sh
        yes | ./install-gnome-extensions.sh --enable --overwrite --file ./static/text/gnome-ext.txt
        rm -f ./install-gnome-extensions.sh


        # Make keylock indicator and Yakuake start automatically
        PrintMsg "set autostart apps..."
        mkdir -p ~/.config/autostart/
        cp -f ./static/text/indicator-keylock.desktop ~/.config/autostart/
        cp -f ./static/text/org.kde.yakuake.desktop ~/.config/autostart/

        # Install lint hook.
        PrintMsg "Installing lint hook..."
        rm -rf ${HOME}/lint-hook
        git clone https://github.com/OCA/maintainer-quality-tools ${HOME}/lint-hook
        cd ${HOME}/lint-hook
        sudo pip2 install -r requirements.txt
        sudo ln -sf ${HOME}/lint-hook/git/* /usr/share/git-core/templates/hooks
        cd ${INSTALLDIR}

        # Make Nautilus capable of browse recursively
        PrintMsg "Making Nautilus capable of browse recursively"
        $ADDAPTREPOSITORY ppa:lubomir-brindza/nautilus-typeahead
        $UPDATE
        sudo apt dist-upgrade -y
        dconf write /org/gnome/nautilus/preferences/always-use-location-entry true
        dconf write /org/gnome/nautilus/preferences/enable-interactive-search true
        nautilus -q |true



        # Enable history-search with arrows
        PrintMsg "Set other user configs"
        yes | cp -rf ./static/text/.inputrc ~/
        echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc
        echo 'export HISTSIZE=1000000' >> ~/.bashrc
        echo 'export HISTFILESIZE=1000000000' >> ~/.bashrc
        echo 'export HISTIGNORE="ls:ll:cd:pwd:bg:fg:history"' >> ~/.bashrc
        echo 'shopt -s histappend' >> ~/.bashrc

        # Enable to configure and config wifi without sudo
        sudo touch /etc/sudoers.d/network_interface
        #echo "$USER ALL=(ALL) /usr/bin/ip link set *[a-z0-9] down" | sudo tee -a /etc/sudoers.d/network_interface
        echo "#$(id -u) ALL=(ALL) /usr/bin/ip link set *[a-z0-9] down" | sudo tee -a /etc/sudoers.d/network_interface > /dev/null
        #echo "$USER ALL=(ALL) /usr/bin/ip link set *[a-z0-9] up" | sudo tee -a /etc/sudoers.d/network_interface
        echo "#$(id -u) ALL=(ALL) /usr/bin/ip link set *[a-z0-9] up" | sudo tee -a /etc/sudoers.d/network_interface > /dev/null

        if [[ ! -f /swapfile ]]; then
            # https://linuxconfig.net/manuals/howto/how-to-configure-swap-partition-in-ubuntu-19-10.html
            PrintMsg "Set swapfile"
            #sudo swapoff /swapfile
            sysmem=`awk '/MemTotal/ {print $2}' /proc/meminfo`
            sw_a=$(($sysmem * 2))
            sudo fallocate -l ${sw_a}k /swapfile
            sudo chmod 0600 /swapfile
            sudo mkswap /swapfile
            sudo swapon /swapfile
            echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab > /dev/null
        fi

        touch ~/.config/adhocbasic
    else
        PrintMsg "Basic configuration was already done. If you need re-run remove ~/.config/adhocbasic"
    fi

    # Configurarmos
    if [[ "$USER_TYPE" == "T" ]]; then
        . scripts/technical.sh

    fi

    if [[ "$USER_TYPE" == "S" ]]; then
        . scripts/sysadmin.sh
    fi


# Add Sysadmin Account
    if id "sysadmin" &>/dev/null; then
        echo 'user found'
    else
        # Create system account
        sudo adduser -q --gecos "" --disabled-password --uid 499 sysadmin
        # Add Acount to sudo
        sudo usermod -G sudo sysadmin
        # Add SSH public key
        sudo -u sysadmin mkdir -p /home/sysadmin/.ssh/
        sudo -u sysadmin cp -f ./static/text/sysadmin.pub /home/sysadmin/.ssh/authorized_keys
    fi

# Backup restore utility
    # Fix files and directories permissions.
        # find $directorio -type d -exec chmod 755 {} +
        # find $directorio -type f -exec chmod 644 {} +
        # sudo chmod 755 ~/.ssh
        # sudo chmod 600 ~/.ssh/id_rsa
        # sudo chmod 600 ~/.ssh/id_rsa.pub
        # sudo chmod 644 ~/.ssh/known_hosts

    #Clean
    sudo apt autoremove -y -q=2

    # Listo
    PrintMsg "All done!"
    cd `cat ~/.config/user-dirs.dirs | grep XDG_DESKTOP_DIR |cut -d '=' -f 2| envsubst| sed -e 's/^"//' -e 's/"$//'`
    cp -f ${INSTALLDIR}/static/text/README.txt README.txt
    exit 0
}
