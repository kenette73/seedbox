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
read -p 'Choisissez un mot de passe:' new_pass
useradd $new_user -p $new_pass
mkdir /home/$new_user/
mkdir /home/$new_user/watch
mkdir /home/$new_user/torrents
mkdir /home/$new_user/.session
chown -R $new_user:$new_user /home/$new_user

# Interdiction connection ssh
#Ajouter DenyUsers $new_user à /etc/ssh/sshd_config
#service ssh reload

# Création du fichier de configuration de rtorrent
cp /tmp/seedbox/config/.rtorrent.rc /home/$new_user/.rtorrent.rc
chown $new_user:$new_user /home/$new_user/.rtorrent.rc
sed -i 's/user/'$new_user'/g' /home/$new_user/.rtorrent.rc

# Installations des paquets nécessaires
apt-get install -y build-essential subversion autoconf automake curl gcc g++ rtorrent screen

echo "Paquets installés"

# Configuration de Rtorrent
cp /tmp/seedbox/config/rtorrent /etc/init.d/rtorrent
chmod +x /etc/init.d/rtorrent
update-rc.d rtorrent defaults 99
sed -i 's/utilisateur/'$new_user'/g' /etc/init.d/rtorrent

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
cd /var/www/html
git clone https://github.com/Novik/ruTorrent
mkdir /var/www/html/ruTorrent/conf/users/$new_user/
cp /tmp/seedbox/config/config.php /var/www/html/ruTorrent/conf/users/$new_user/config.php
cp /tmp/seedbox/config/plugins.ini /var/www/html/ruTorrent/conf/users/$new_user/plugins.ini
chown -R www-data:www-data /var/www/html/ruTorrent/
#rm -R /var/www/html/ruTorrent/plugins/*
