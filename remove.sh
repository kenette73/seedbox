#!/bin/bash
rm -R /home/keny/watch
rm -R /home/keny/torrents
rm -R /home/keny/.session
rm /home/keny/.rtorrent.rc

rm -R /var/www/html/rutorrent

rm /etc/init.d/rtorrent

rm -R /tmp/seedbox

echo 'Fichiers supprimés'*


# Installations

cd /tmp
git clone https://github.com/kenette73/seedbox.git
cd seedbox
chmod +x install.sh
./install.sh
