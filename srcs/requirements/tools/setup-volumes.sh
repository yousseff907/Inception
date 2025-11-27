#!/bin/bash

sudo mkdir -p /home/$USER/data/mariadb
sudo mkdir -p /home/$USER/data/wordpress
sudo chown -R $USER:$USER /home/$USER/data/
echo "Volumes created!"