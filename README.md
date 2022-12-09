# Linux Home (WIP)
Base configuration and apps I most likely use on servers or desktop

## Getting Started
1. Clone the repository
2. Move all repositroy files into your home folder
3. `chmod +x install.sh`
4. Run the installation script

### Base Installation
This is the bast I use on all linux based setups. Think of terminal, aliases etc.

### Zorin Installation
Is the alternative to Windows and macOS designed to make your computer faster, more powerful, secure, and privacy-respecting. Therefore I have to setup some basic apps I often use on my Laptops or Desktops. 

**Includes**
- PHPStorm
- Github Desktop
- Postman
- Spotify
- Discord

## Windows WSL
https://djoowe.notion.site/Ubuntu-Home-fda09c17b55b45059fed00a233a67d52

## SSL Local dev
```
openssl req -x509 -sha256 -nodes -newkey rsa:2048 -keyout localhost.key -out localhost.crt
sudo cp localhost.crt /usr/local/share/ca-certificates/localhost.crt
sudo update-ca-certificates
sudo chown joe:www-data localhost.*
```
