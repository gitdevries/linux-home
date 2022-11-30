#!/bin/bash
# Joe's - Linux Env

readonly red="\033[1;31m"
readonly green="\033[1;32m"
readonly yellow="\033[1;33m"
readonly blue="\033[1;34m"
readonly purple="\033[1;35m"
readonly cyan="\033[1;36m"
readonly grey="\033[0;37m"
readonly r="\033[m"

readonly PLUG_LOC="~/.local/share/nvim/site/autoload/plug.vim"

checkPackage() {
    status="$(dpkg-query -W --showformat='${db:Status-Status}' "$1" 2>&1)"
    if [ ! $? = 0 ] || [ ! "$status" = installed ]; then
        return 0
    fi
    
    return 1
}

installFlatpak() {
    local package=$1
    local alias=${2:-$package}
    echo "${red}TODO: Implement${r}"
}

askConfirm() {
    read -p "$(echo -e $1) " answer
    case ${answer:0:1} in
        y|Y )
            return 1
        ;;
        * )
            return 0
        ;;
    esac
}

installDocker() {
    sudo apt remove docker-desktop
    sudo apt-get update -Y
}   

installExtra() {
    # Node
    askConfirm "${red}[?]${yellow} Install: Node.JS? (Y/n)${r}"
    if [ $? = 1 ]; then
        echo "Lets install some apps"
    else
        echo -e "${red}[!]${cyan} > Skipped: Node.JS${r}"
    fi
    
    # PHP
    askConfirm "${red}[?]${yellow} Install: PHP? (Y/n)${r}"
    if [ $? = 1 ]; then
        
        #sudo add-apt-repository ppa:ondrej/php -y
        #sudo apt-get update -y
        #sudo apt install -y php8.1 php8.1-curl php8.1-common php8.1-gd php8.1-xml php8.1-soap php8.1-mbstring php8.1-mysql php8.1-zip php8.1-gmp php8.1-redis php8.1-bcmath php8.1-imap
        
        echo "Lets install some apps"
    else
        echo -e "${red}[!]${cyan} > Skipped: PHP${r}"
    fi
    # # Node
    # sudo npm i -g pm2
}

installApps() {
    sudo apt install -yqq gnome-tweaks 
    # Boxes
    askConfirm "${red}[?]${yellow} Install: Boxes? (Y/n)${r}"
    if [ $? = 1 ]; then
        echo -e "${blue}[~]${grey} Installing: Boxes${r}"
        flatpak install flathub org.gnome.Boxes -y
    else
        echo -e "${red}[!]${cyan} > Skipped: Boxes${r}"
    fi

    # Github Desktop
    askConfirm "${red}[?]${yellow} Install: Github Desktop? (Y/n)${r}"
    if [ $? = 1 ]; then
        echo -e "${blue}[~]${grey} Installing: Github Desktop${r}"
        flatpak install flathub io.github.shiftey.Desktop -y
    else
        echo -e "${red}[!]${cyan} > Skipped: Github Desktop${r}"
    fi

    # Postman
    askConfirm "${red}[?]${yellow} Install: Postman? (Y/n)${r}"
    if [ $? = 1 ]; then
        echo -e "${blue}[~]${grey} Installing: Postman${r}"
        flatpak install flathub com.getpostman.Postman -y
    else
        echo -e "${red}[!]${cyan} > Skipped: Postman${r}"
    fi

    # Spotify
    askConfirm "${red}[?]${yellow} Install: Spotify? (Y/n)${r}"
    if [ $? = 1 ]; then
        echo -e "${blue}[~]${grey} Installing: Spotify${r}"
        flatpak install flathub com.spotify.Client -y
    else
        echo -e "${red}[!]${cyan} > Skipped: Spotify${r}"
    fi

    # Discord
    askConfirm "${red}[?]${yellow} Install: Discord? (Y/n)${r}"
    if [ $? = 1 ]; then
        echo -e "${blue}[~]${grey} Installing: Discord${r}"
        flatpak install flathub com.discordapp.Discord -y
    else
        echo -e "${red}[!]${cyan} > Skipped: Discord${r}"
    fi
}

# Install core
echo -e "${blue}[~]${yellow} Installing core requirements${r}"
sudo apt-get install -yqq software-properties-common ca-certificates lsb-release apt-transport-https curl
sudo apt-get update -yqq
echo -e "${green}[!]${purple} > Updated${r}"

# Download external dependencies
echo -e "${blue}[~]${grey} Installing: neovim plug${r}"
if [ -f $PLUG_LOC ]; then
    echo -e "${green}[!]${cyan} > Already installed${r}"
else 
    curl -fLo $PLUG_LOC -s --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo -e "${green}[!]${purple} > Installed${r}"
fi

# Install base packages
echo -e "${blue}[~]${grey} Installing: neovim${r}"
checkPackage "neovim"
if [ $? = 1 ]; then
    echo -e "${green}[!]${cyan} > Already installed${r}"
else
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo apt install -yqq neovim
    echo -e "${green}[!]${purple} > Installed${r}"
fi

echo -e "${blue}[~]${grey} Installing: keychain${r}"
checkPackage "keychain"
if [ $? = 1 ]; then
    echo -e "${green}[!]${cyan} > Already installed${r}"
else
    sudo apt install -yqq keychain
    echo -e "${green}[!]${purple} > Installed${r}"
fi

# Extras
echo -e "${blue}[~]${grey} Configurating utilities${r}"
mkdir ~/.config/nvim -p
cp ./linux_config/nvim/init.vim ~/.config/nvim/
rm -r ./linux_config

# Install Extra Setup
askConfirm "${red}[?]${yellow} Would you like to install extras? (Y/n)${r}"
if [ $? = 1 ]; then
    installExtra
else
    echo -e "${red}[!]${cyan} > Not installing: extras${r}"
fi

# Install Zorin Setup
askConfirm "${red}[?]${yellow} Would you like to install zorin apps? (Y/n)${r}"
if [ $? = 1 ]; then
    installApps
else
    echo -e "${red}[!]${cyan} > Not installing: zorin apps${r}"
fi

echo -e "${green}[!]${green} We are done!${r}"