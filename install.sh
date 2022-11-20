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

checkPackage() {
    status="$(dpkg-query -W --showformat='${db:Status-Status}' "$1" 2>&1)"
    if [ ! $? = 0 ] || [ ! "$status" = installed ]; then
        return 0
    fi
    
    return 1
}

checkFlatpak() {
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

# Install core
echo -e "${blue}[~]${yellow} Installing core requirements${r}"
sudo apt-get install -yqq software-properties-common ca-certificates lsb-release apt-transport-https curl
sudo apt-get update -yqq
echo -e "${green}[!]${purple} > Updated${r}"

# Download external dependencies
echo -e "${blue}[~]${grey} Installing: neovim plug${r}"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install base packages
echo -e "${blue}[~]${grey} Installing: neovim${r}"
checkPackage "neovim"
if [ $? = 1 ]; then
    echo -e "${green}[!]${cyan} > Already installed${r}"
else
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

# Install Extra Setup
askConfirm "${red}[?]${yellow} Would you like to install extras? (Y/n)${r}"
if [ $? = 1 ]; then
    echo "Install the extra's"
else
    echo -e "${red}[!]${cyan} > Not installing: extras${r}"
fi

# Install Zorin Setup
askConfirm "${red}[?]${yellow} Would you like to install zorin apps? (Y/n)${r}"
if [ $? = 1 ]; then
    echo "Lets install some apps"
else
    echo -e "${red}[!]${cyan} > Not installing: zorin apps${r}"
fi

installExtra() {
    # Dependencies
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo add-apt-repository ppa:ondrej/php -y
    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    
    sudo apt-get update -y
    
    # Node
    sudo apt install -y nodejs
    sudo npm i -g pm2
    
    # PHP8.1
    sudo apt install -y php8.1 php8.1-curl php8.1-common php8.1-gd php8.1-xml php8.1-soap php8.1-mbstring php8.1-mysql php8.1-zip php8.1-gmp php8.1-redis php8.1-bcmath php8.1-imap
}

installZorin() {
    #flatpak install flathub com.jetbrains.PhpStorm
    #flatpak install flathub io.github.shiftey.Desktop
    #flatpak install flathub com.getpostman.Postman
    #flatpak install flathub com.spotify.Client
    #flatpak install flathub com.discordapp.Discord
}