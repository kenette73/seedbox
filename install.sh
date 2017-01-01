#!/bin/bash

# Vérifications des mise à jour
sudo apt-get update

echo "Serveur mis à jour"

# Include
DIR="include"
. "$DIR"/adduser.sh
. "$DIR"/apache.sh

# Installations des paquets nécessaires
apt-get install -y build-essential subversion autoconf automake curl gcc g++ rtorrent screen

echo "Paquets installés"

# Installation des paquets pour Rtorrent
#apt-get install -y rtorrent screen

#echo "Rtorrent & Screen installé installés"

# Suppression de la version de xmlrpc-c
apt-get remove xmlrpc-c

echo "Xmlrpc-c Supprimé"

# Configuration de Rtorrent
cp /tmp/seedbox/config/rtorrent /etc/init.d/rtorrent
chmod +x /etc/init.d/rtorrent
update-rc.d rtorrent defaults 99
sed -i 's/utilisateur/$new_user/g' /etc/init.d/rtorrent

echo 'Rtorrent configuré'

# Installation de Xmlrpc
cd /tmp
svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/stable xmlrpc-c
cd xmlrpc-c/
./configure --disable-wininet-client --disable-libwww-client --disable-abyss-server
make
make install

echo "Xmlrpc installé"

# Installation de Rutorrent
cd /var/www/html
git clone https://github.com/Novik/ruTorrent
mkdir /var/www/html/ruTorrent/conf/users/$new_user/
cp /tmp/seedbox/config/config.php /var/www/html/ruTorrent/conf/users/$new_user/config.php
cp /tmp/seedbox/config/plugins.ini /var/www/html/ruTorrent/conf/users/$new_user/plugins.ini
chown -R www-data:www-data /var/www/html/ruTorrent/
#rm -R /var/www/html/ruTorrent/plugins/*
