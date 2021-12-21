# Basic installation.


        PrintMsg "installing PIP (2 & 3)"
        # pip2
        curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
        sudo python2 get-pip.py
        rm get-pip.py
        # pip3
        curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
        sudo python3 get-pip.py
        rm get-pip.py


        # Make Visual Studio Code default plain-text editor.
        PrintMsg "Making Visual Studio Code default plain-text editor..."
        xdg-mime default code.desktop text/plain

        # Configure Visual Studio Code.
        PrintMsg "Configuring Visual Studio Code..."
        yes | cp -rf ./static/vscode/{settings.json,keybindings.json} ~/.config/Code/User/
        #yes | cp -rf ./static/vscode/settings.json ~/.config/Code/User/
        yes | cp -rf ./static/text/{pycodestyle,flake8} ~/.config/

        # Increase fs.inotify.max_user_watches value.
        PrintMsg "Increase fs.inotify.max_user_watches value..."
        sudo sh -c 'echo "fs.inotify.max_user_watches=524288" > /etc/sysctl.conf'

        # Install PyLint for Python 2 and Python 3
        PrintMsg "Installing PyLint for Python 2 and Python 3"
        sudo pip2 install pylint && sudo pip2 install --upgrade git+https://github.com/oca/pylint-odoo.git
        sudo pip3 install --upgrade git+https://github.com/oca/pylint-odoo.git

        # Install flake8 and pep8 for Python 2 and Python 3.
        PrintMsg "Installing Flake8 and Pep8 for Python 2 and Python 3"
        sudo pip2 install -U flake8 --user
        sudo pip3 install -U flake8 --user
        sudo pip2 install -U pep8 --user
        sudo pip3 install -U pep8 --user
        # Pre-commit
        #sudo pip2 install pre-commit
        sudo pip3 install pre-commit

        PrintMsg "Set python defaults"
        # Hacemos el update alternatives para que python2 corra por defecto (mas alto es mayor)
        sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 2
        sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1

        # Install Yakuake.
        PrintMsg "Installing Yakuake..."
        AptInstall yakuake
        yes | cp -rf ./static/text/yakuakerc ~/.config/
        mkdir -p ~/.local/share/konsole
        yes | cp -rf ./static/text/'Profile 1.profile' ~/.local/share/konsole/

        # Branding.
        PrintMsg "Branding..."
        sudo cp ./static/images/{logotipo_adhoc.png,isotipo_adhoc.png} /usr/share/backgrounds/
        sudo chmod 666 /usr/share/backgrounds/{isotipo_adhoc.png,logotipo_adhoc.png}
        dconf write /org/gnome/desktop/background/picture-options "'centered'"
        dconf write /org/gnome/desktop/background/picture-uri "'file:///usr/share/backgrounds/isotipo_adhoc.png'"
        dconf write /org/gnome/desktop/background/primary-color "'#EEEEEC'"
        dconf write /org/gnome/desktop/screensaver/picture-options "'centered'"
        dconf write /org/gnome/desktop/screensaver/picture-uri "'file:///usr/share/backgrounds/logotipo_adhoc.png'"
        dconf write /org/gnome/desktop/screensaver/primary-color "'#EEEEEC'"
        # Improve performance of UI
        gsettings set org.gnome.desktop.interface clock-show-seconds false
        gsettings set org.gnome.desktop.interface enable-animations false
        gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
        gsettings set org.gnome.desktop.interface cursor-theme 'DMZ-Black'
        gsettings set org.gnome.desktop.interface icon-theme 'ubuntu-mono-dark'
        # Determina si el cambio entre áreas de trabajo debería suceder para las ventanas en todos los monitores o sólo para ventanas en el monitor primario.
        gsettings set org.gnome.mutter workspaces-only-on-primary true
        # Shortcuts
        gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Shift><Super>F1']"
        gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Shift><Super>F2']"
        gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Shift><Super>F3']"
        gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Shift><Super>F4']"
        gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>F1']"
        gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>F2']"
        gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>F3']"
        gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>F4']"

        # Configure UI and improve UX.

        # Install the Extensions using https://github.com/cyfrost/install-gnome-extensions/
        PrintMsg "Install Gnome extensions"
        AptInstall curl wget jq unzip
        rm -f ./install-gnome-extensions.sh
        wget -N -q "https://raw.githubusercontent.com/cyfrost/install-gnome-extensions/master/install-gnome-extensions.sh" -O ./install-gnome-extensions.sh && chmod +x install-gnome-extensions.sh
        yes | ./install-gnome-extensions.sh --enable --overwrite --file ./static/text/gnome-ext.txt
        rm -f ./install-gnome-extensions.sh

        # Configuring Ext
        dconf write /org/gnome/shell/extensions/wsmatrix/num-columns 2
        dconf write /org/gnome/shell/extensions/wsmatrix/num-rows 2
        dconf write /org/gnome/shell/extensions/wsmatrix/show-overview-grid true
        dconf write /org/gnome/shell/extensions/openweather/city "'-32.9575, -60.639444>Rosario, Santa Fe>-1'"
        dconf write /org/gnome/shell/extensions/openweather/unit "'celsius'"
        dconf write /org/gnome/shell/extensions/openweather/wind-speed-unit "'m/s'"
        dconf write /org/gnome/shell/extensions/openweather/pressure-unit "'hPa'"
        dconf write /org/gnome/shell/extensions/dash-to-dock/scroll-action "'cycle-windows'"
        dconf write /org/gnome/shell/extensions/dash-to-dock/isolate-workspaces true
        dconf write /org/gnome/shell/extensions/dash-to-dock/multi-monitor true
        dconf write /org/gnome/shell/window-switcher/current-workspace-only true
        dconf write /org/gnome/shell/app-switcher/current-workspace-only true
        dconf write /org/gnome/desktop/interface/clock-show-date true
        dconf write /org/gnome/desktop/interface/show-battery-percentage true
        dconf write /org/gnome/mutter/dynamic-workspaces false
        dconf write /org/gnome/desktop/wm/preferences/num-workspaces 4


        # Install keylock indicator.
        PrintMsg "Installing keylock indicator..."
        $ADDAPTREPOSITORY ppa:tsbarnes/indicator-keylock
        $UPDATE
        AptInstall indicator-keylock

        # Install Indicator Sound Switcher
        PrintMsg "Installing indicator-sound-switcher..."
        $ADDAPTREPOSITORY ppa:yktooo/ppa
        $UPDATE
        AptInstall indicator-sound-switcher

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


        # Enable battery saver app
        PrintMsg "Enable Bat. Savers"
        sudo tlp start

        # Install Slack
        PrintMsg "Installing Slack snap package"
        sudo snap install slack --classic


        # Enable history-search with arrows
        PrintMsg "Set other user configs"
        yes | cp -rf ./static/text/.inputrc ~/
        echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc
        echo 'export HISTSIZE=1000000' >> ~/.bashrc
        echo 'export HISTFILESIZE=1000000000' >> ~/.bashrc
        echo 'export HISTIGNORE="ls:ll:cd:pwd:bg:fg:history"' >> ~/.bashrc
        echo 'shopt -s histappend' >> ~/.bashrc

        PrintMsg "Global DNS Config"
        # More info https://andrea.corbellini.name/2020/04/28/ubuntu-global-dns/
        yes | sudo cp -rf ./static/dns/resolved.conf /etc/systemd/resolved.conf
        sudo systemctl restart systemd-resolved.service
        yes | sudo cp -rf ./static/dns/dns.conf /etc/NetworkManager/conf.d/dns.conf
        sudo systemctl reload NetworkManager.service
        # Add Default DNSs
        # https://vdemir.github.io/app/2018/06/16/Dnsmasq.html
        # Default DNS
        # yes | sudo cp -rf ./static/text/resolv-dnsmasq.conf /etc/resolvconf/resolv.conf.d/base
        # sudo resolvconf -u

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
