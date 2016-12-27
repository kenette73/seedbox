#!/bin/bash

# Vérifications des mise à jour
sudo apt-get update

echo "Serveur mis à jour"

# Installations des paquets nécessaires
apt-get install -y subversion autoconf automake curl gcc g++	

echo "Paquets installés"

# Installation de Xmlrpc
cd /tmp
svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/stable xmlrpc-c
cd xmlrpc-c/
./configure --disable-wininet-client --disable-libwww-client --disable-abyss-server
make
make install
make clean
rm -R /xmlrpc-c

echo "Xmlrpc installé"

# Installation des pacquets pour Rtorrent et Libtorrent
apt-get install -y git-core libtool libncurses5

echo "Paquets installés"

# Installation et compilation de Rtorrent
cd /tmp
git clone https://github.com/rakshasa/rtorrent.git
cd rtorrent
./autogen.sh
./configure --with-xmlrpc-c
make
make install
make check
#make clean



# Installation et compilation de Libtorrent


