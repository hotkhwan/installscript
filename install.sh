#!/bin/bash

# Update the package list
sudo apt update

# Install dependencies to allow apt to use a repository over HTTPS
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    tmux \
    git-flow \
    vim \
    curl \
    software-properties-common

# Add the Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add default paste to vim
echo "set paste" \
   | sudo tee ~/.vimrc > /dev/null

# Set vi default vim
ln -sf /usr/bin/vim.basic /usr/bin/vi

# Add the Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package list (again)
sudo apt update

# Install Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Add your user to the "docker" group to run Docker commands without sudo
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose

# Apply executable permissions to Docker Compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Node.js
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Node-RED
#sudo npm install -g --unsafe-perm node-red
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)

sudo cp ./settings.js /root/.node-red/settings.js
sudo cp ./flows.json /root/.node-red/flows.json
sudo cp ./icon.png /root/.node-red/

# Install some Packet 
cd /root/.node-red
sudo npm install crypto-js uuid util rimraf node-red-contrib-mongodb4 node-red-contrib-ip @ridort/node-red-contrib-socketio-simple node-red-contrib-image-tools ttb-node-red-counter

# Enable Node-RED as a service
sudo systemctl enable nodered.service

# Start Node-RED service
sudo systemctl start nodered.service

# Print the Node-RED service status
sudo systemctl status nodered.service

# Print Docker and Docker Compose versions
docker --version
docker-compose --version
