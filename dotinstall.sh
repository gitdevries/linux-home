#!/bin/bash

PHP_VERSION="8.1"
NODE_MAJOR_VERSION="16"

# Install core
sudo apt-get install software-properties-common ca-certificates lsb-release apt-transport-https curl -y

sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo add-apt-repository ppa:ondrej/php -y

sudo apt-get update -y

# Download external dependencies
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install Neovim
sudo apt install neovim -y

# Install Node
sudo apt install nodejs -y

# Install PHP8.1
sudo apt install php8.1 php8.1-curl php8.1-common php8.1-gd php8.1-xml php8.1-soap php8.1-mbstring php8.1-mysql php8.1-zip php8.1-gmp php8.1-redis php8.1-bcmath php8.1-imap -y

# Extras
mkdir ~/.config/nvim -p
sudo npm i -g pm2