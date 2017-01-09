#!/bin/bash

# Variables
USER="keny"

userdel $USER
rm -R /home/$USER/watch
rm -R /home/$USER/torrents
rm -R /home/$USER/.session
rm /home/$USER/.rtorrent.rc

rm -R /var/www/html/rutorrent

rm /etc/init.d/rtorrent

rm -R /tmp/seedbox

echo 'Fichiers supprimés'*

sudo apt-get purge -y apt-get install -y build-essential subversion autoconf automake curl gcc g++ rtorrent screen gzip mediainfo ffmpeg unrar zip apache2 apache2.2-common apache2-utils libapache2-mod-scgi libapache2-mod-php5

# Installations

cd /tmp
git clone https://github.com/kenette73/seedbox.git
cd seedbox
chmod +x install.sh
./install.sh
