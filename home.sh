#!/bin/bash
# Joe's - Home Install

readonly red="\033[1;31m"
readonly green="\033[1;32m"
readonly yellow="\033[1;33m"
readonly blue="\033[1;34m"
readonly purple="\033[1;35m"
readonly cyan="\033[1;36m"
readonly grey="\033[0;37m"
readonly r="\033[m"

readonly PLUG_LOC=".local/share/nvim/site/autoload/plug.vim"

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    OS=Debian
    VER=$(cat /etc/debian_version)
else
    OS=$(uname -s)
    VER=$(uname -r)
fi


# Update System and add repositories
updateSystem() {
    sudo apt-get install -yqq software-properties-common ca-certificates lsb-release apt-transport-https curl
    sudo apt-get update -y

    sudo add-apt-repository -y ppa:ondrej/php
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo apt-get update -y
}

# Prepare some things
prepareSystem() {
    # Remove Apache
    sudo service apache2 stop
    sudo apt remove apache2.* -y
    sudo apt-get purge apache2
    if [ -d "/etc/apache2" ]; then rm -Rf /etc/apache2; fi
    sudo apt autoremove -y
}

# Cleanup leftovers from Linx Home
cleanupHome() {
  rm -rf ./home/$NORMAL_USER/linux_home
  rm -rf ./home/$NORMAL_USER/.git
}

installPackages() {
    # NeoVIM
    sudo apt install -yqq neovim
    curl -fLo $PLUG_LOC -s --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    mkdir /home/$NORMAL_USER/.config/nvim -p
    sudo cp /home/$NORMAL_USER/linux_home/nvim/init.vim /home/$NORMAL_USER/.config/nvim/
    sudo chown $NORMAL_USER:$NORMAL_USER /home/$NORMAL_USER/.config/ -R

    # Keychain
    sudo apt install -yqq keychain
    
    # NGINX
    sudo apt install -yqq nginx
    sudo chown -R $NORMAL_USER:www-data /etc/nginx
    sudo usermod -aG www-data $NORMAL_USER
    sudo chmod 764 -R /etc/nginx

    # PHP
    sudo apt install -yqq php8.1 php8.1-curl php8.1-common php8.1-fpm php8.1-gd php8.1-xml php8.1-soap php8.1-mbstring php8.1-mysql php8.1-zip php8.1-gmp php8.1-redis php8.1-bcmath php8.1-imap
    sudo cp /home/$NORMAL_USER/linux_home/php/local.ini /etc/php/8.1/fpm/conf.d/local.ini
    
    # Docker
    sudo addgroup --system docker
    sudo adduser $NORMAL_USER docker
    newgrp docker
    sudo snap install docker
    sudo snap disable docker
    sudo snap enable docker
}

installSoftware() {
    echo -e "${blue}[~]${grey} Installing: Postman${r}"
    sudo snap install postman

    echo -e "${blue}[~]${grey} Installing: Spotifu${r}"
    sudo snap install spotify

    echo -e "${blue}[~]${grey} Installing: VSCode${r}"
    sudo snap install --classic code

    echo -e "${blue}[~]${grey} Installing: Beekeeper Studio${r}"
    sudo snap install beekeeper-studio

    echo -e "${blue}[~]${grey} Installing: Bitwarden${r}"
    sudo snap install bitwarden

    echo -e "${blue}[~]${grey} Installing: Github Desktop${r}"
    flatpak install flathub io.github.shiftey.Desktop -y

    echo -e "${blue}[~]${grey} Installing: Discord${r}"
    flatpak install flathub com.discordapp.Discord -y
}

# Install tweaks + Maybe tweak some
tweakSettings() {
    sudo apt install -yqq gnome-tweaks
}

# Pre-start
if [ "$EUID" -ne 0 ]; then
    echo -e "${red}[!]${grey} Missing: Root permissions${r}"
    exit
else
    echo -e -n "${purple}[?]${yellow} What is your username: ${r}"
    read NORMAL_USER
fi

if ! command -v snap &> /dev/null; then
    echo -e "${red}[!]${grey} Missing: Snapstore${r}"
    exit
fi

# Start
echo -e "${blue}[~]${grey} Updating your system${r}"
updateSystem

echo -e "${blue}[~]${grey} Preparing your system${r}"
prepareSystem

# Work
installPackages
if [ "$OS" = "Zorin OS" ]; then
    installSoftware
    tweakSettings
fi

# End
echo -e "${blue}[~]${grey} Cleaning up some left overs${r}"
cleanupHome
