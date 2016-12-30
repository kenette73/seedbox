#!/bin/bash

# Vérifications des mise à jour
sudo apt-get update

echo "Serveur mis à jour"

# Include
Dir="include"
. $include/adduser.sh

# Installations des paquets nécessaires
apt-get install -y build-essential subversion autoconf automake curl gcc g++	

echo "Paquets installés"

# Installation des pacquets pour Rtorrent
apt-get install -y rtorrent screen

echo "Rtorrent & Screen installé installés"

# Installation de Xmlrpc
cd /tmp
svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/stable xmlrpc-c
cd xmlrpc-c/
./configure --disable-wininet-client --disable-libwww-client --disable-abyss-server
make
make install

echo "Xmlrpc installé"

# Installation des pacquets pour Rtorrent
apt-get install -y rtorrent patch

echo "Rtorrent installé installés"

# Configurations de Rtorrent
cp /tmp/seedbox/config/.rtorrent.rc /home/$new_user/torrent/.rtorrent.rc
chmod $new_user:$new_user /home/$new_user/torrent/.rtorrent.rc
