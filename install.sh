#!/bin/bash

# Log Installation
exec > >(tee "/tmp/seedbox/install.log") 2>&1

#Installations des depots pour ffmpeg
apt-get install -y software-properties-common
apt-add-repository "deb http://mirrors.online.net/debian jessie-backports main non-free contrib"

# Vérifications des mise à jour
sudo apt-get update
echo "Serveur mis à jour"

# Création de l'utilisateur et des répertoires
read -p 'Choisissez un nom d utilisateur:' NEW_USER
useradd -m $NEW_USER
passwd $NEW_USER
mkdir -p /home/$NEW_USER/{watch,torrents,.session}
chown -R $NEW_USER:$NEW_USER /home/$NEW_USER
chmod -R 755 /home/$NEW_USER

echo ' utilisateur crée'

# Interdiction connection ssh
#Ajouter DenyUsers $new_user à /etc/ssh/sshd_config
#service ssh reload

# Include
DIR="include"
. "$DIR"/variables.sh
. "$DIR"/apache.sh

# Création du fichier de configuration de rtorrent
cp /tmp/seedbox/.rtorrent.rc /home/$NEW_USER/.rtorrent.rc
chown $NEW_USER:$NEW_USER /home/$NEW_USER/.rtorrent.rc
sed -i 's/@user/'$NEW_USER'/g' /home/$NEW_USER/.rtorrent.rc
sed -i 's/@port/5000/g' /home/$NEW_USER/.rtorrent.rc
sed -i 's/@rutorrent/'$RUTORRENT'/g' /home/$NEW_USER/.rtorrent.rc

echo 'Rtorrent configuré'

# Installations des paquets nécessaires à Rtorrent et Rutorrent
apt-get install -y build-essential subversion autoconf automake curl gcc g++ rtorrent screen gzip mediainfo ffmpeg unrar zip

# Configuration de Rtorrent
cp /tmp/seedbox/rtorrent $RTORRENT
chmod +x $RTORRENT
update-rc.d rtorrent defaults 99
sed -i 's/@user/'$NEW_USER'/g' $RTORRENT

echo 'Rtorrent configuré'

# Installation de Rutorrent
cd $WWW
git clone https://github.com/Novik/ruTorrent rutorrent
mkdir $CONF/$NEW_USER
cp /tmp/seedbox/config/config.php $CONF/$NEW_USER/
cp /tmp/seedbox/config/plugins.ini $CONF/$NEW_USER/
sed -i 's/@user/'$NEW_USER'/g' $CONF/$NEW_USER/config.php
sed -i 's/@port/5000/g' $CONF/$NEW_USER/config.php
chown -R www-data:www-data $RUTORRENT
chmod -R 755 $RUTORRENT
#rm -R /var/www/html/ruTorrent/plugins/*

#Démarrage de rtorrent
service rtorrent start
