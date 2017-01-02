#!/bin/bash

# Vérifications des mise à jour
sudo apt-get update

echo "Serveur mis à jour"

# Include
DIR="include"
. "$DIR"/variables.sh
#. "$DIR"/adduser.sh
. "$DIR"/apache.sh

# Log Installation
exec > >(tee "/tmp/seedbox/install.log") 2>&1

# Création de l'utilisateur et des répertoires
read -p 'Choisissez un nom d utilisateur:' new_user
#read -p 'Choisissez un mot de passe:' new_pass
#useradd $new_user -p $new_pass
mkdir -p /home/$new_user/{watch,torrents,.session}
chown -R $new_user:$new_user /home/$new_user
chmod 755 /home/$new_user

# Interdiction connection ssh
#Ajouter DenyUsers $new_user à /etc/ssh/sshd_config
#service ssh reload

# Création du fichier de configuration de rtorrent
cp /tmp/seedbox/.rtorrent.rc /home/$new_user/.rtorrent.rc
chown $new_user:$new_user /home/$new_user/.rtorrent.rc
sed -i 's/@user/'$new_user'/g' /home/$new_user/.rtorrent.rc

# Installations des paquets nécessaires
apt-get install -y build-essential subversion autoconf automake curl gcc g++ rtorrent screen gzip

echo "Paquets installés"

# Configuration de Rtorrent
cp /tmp/seedbox/rtorrent $RTORRENT
chmod +x $RTORRENT
update-rc.d rtorrent defaults 99
sed -i 's/@user/'$new_user'/g' $RTORRENT

echo 'Rtorrent configuré'

# Installation de Xmlrpc
#cd /tmp
#svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/stable xmlrpc-c
#cd xmlrpc-c/
#./configure --disable-wininet-client --disable-libwww-client --disable-abyss-server
#make
#make install

#echo "Xmlrpc installé"

# Installation de Rutorrent
cd $WWW
git clone https://github.com/Novik/ruTorrent
mkdir $CONF/$new_user
cp /tmp/seedbox/config/* $CONF/$new_user/
sed -i 's/@user/'$new_user'/g' $CONF/$new_user/config.php
sed -i 's/@port/5000/g' $CONF/$new_user/config.php
chown -R www-data:www-data $RUTORRENT
#rm -R /var/www/html/ruTorrent/plugins/*
