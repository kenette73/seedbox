#!/bin/bash

#Installations des depots pour Fmpeg
apt-get install -y software-properties-common
apt-add-repository "deb http://www.deb-multimedia.org jessie main non-free"

# Vérifications des mise à jour
sudo apt-get update
echo "Serveur mis à jour"

# Include
DIR="include"
. "$DIR"/variables.sh
. "$DIR"/apache.sh

# Log Installation
exec > >(tee "/tmp/seedbox/install.log") 2>&1

# Création de l'utilisateur et des répertoires
read -p 'Choisissez un nom d utilisateur:' NEW_USER
#read -p 'Choisissez un mot de passe:' new_pass
#useradd $new_user -p $new_pass
mkdir -p /home/$NEW_USER/{watch,torrents,.session}
chown -R $NEW_USER:$NEW_USER /home/$NEW_USER
chmod 755 /home/$NEW_USER

# Interdiction connection ssh
#Ajouter DenyUsers $new_user à /etc/ssh/sshd_config
#service ssh reload

# Création du fichier de configuration de rtorrent
cp /tmp/seedbox/.rtorrent.rc /home/$NEW_USER/.rtorrent.rc
chown $NEW_USER:$NEW_USER /home/$NEW_USER/.rtorrent.rc
sed -i 's/@user/'$NEW_USER'/g' /home/$NEW_USER/.rtorrent.rc
sed -i 's/@port/5000/g' /home/$NEW_USER/.rtorrent.rc

#Installations des depots pour Fmpeg
apt-get install -y software-properties-common


# Installations des paquets nécessaires à Rtorrent et Rutorrent
apt-get install -y build-essential subversion autoconf automake curl gcc g++ rtorrent screen gzip mediainfo ffmpeg unrar zip

echo "Paquets installés"

# Configuration de Rtorrent
cp /tmp/seedbox/rtorrent $RTORRENT
chmod +x $RTORRENT
update-rc.d rtorrent defaults 99
sed -i 's/@user/'$NEW_USER'/g' $RTORRENT

echo 'Rtorrent configuré'

# Installation de Rutorrent
cd $WWW
git clone https://github.com/Novik/ruTorrent
mkdir $CONF/$NEW_USER
cp /tmp/seedbox/config/* $CONF/$NEW_USER/
#sed -i 's/@user/'$NEW_USER'/g' $CONF/$NEW_USER/config.php
sed -i 's/@port/5000/g' $CONF/$NEW_USER/config.php
chown -R www-data:www-data $RUTORRENT
#rm -R /var/www/html/ruTorrent/plugins/*
