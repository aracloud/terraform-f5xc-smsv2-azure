#!/bin/bash

sudo apt update
sudo apt install ca-certificates curl screen apt-transport-https locales cron zsh git neofetch

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update 

# install docker
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -aG docker $USER
#sudo docker run -dit -p 8080:80 --name dvwa aracloud/docker-dvwa
sudo docker run -dit -p 8080:80 --name dvwa kaakaww/dvwa-docker:latest

# set locales
sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen
sudo /usr/sbin/locale-gen

# Export env vars
#echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
#echo "export LANG=en_US.UTF-8" >> ~/.bashrc
#echo "export LANGUAGE=en_US.UTF-8" >> ~/.bashrc
