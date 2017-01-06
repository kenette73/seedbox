#!/bin/bash

# Log Installation
exec > >(tee "/tmp/seedbox/install.log") 2>&1

# Installations des depots pour ffmpeg
apt-get install -y software-properties-common
apt-add-repository "deb http://mirrors.online.net/debian jessie-backports main non-free contrib"

# Vérifications des mise à jour
sudo apt-get update

# Création de l'utilisateur et des répertoires
read -p 'Choisissez un nom d utilisateur:' NEW_USER
useradd -m $NEW_USER
passwd $NEW_USER
mkdir -p /home/$NEW_USER/{watch,torrents,.session}
chown -R $NEW_USER:$NEW_USER /home/$NEW_USER
chmod -R 755 /home/$NEW_USER

# Interdiction connection ssh
#Ajouter DenyUsers $new_user à /etc/ssh/sshd_config
#service ssh reload

# Include
DIR="include"
. "$DIR"/variables.sh

# Installations des paquets nécessaires à Rtorrent et Rutorrent
apt-get install -y build-essential subversion autoconf automake curl gcc g++ rtorrent screen gzip mediainfo ffmpeg unrar zip apache2 apache2.2-common apache2-utils libapache2-mod-scgi libapache2-mod-php5

# Création du fichier de configuration de rtorrent
cp /tmp/seedbox/.rtorrent.rc /home/$NEW_USER/.rtorrent.rc
chown $NEW_USER:$NEW_USER /home/$NEW_USER/.rtorrent.rc
sed -i 's/@user/'$NEW_USER'/g' /home/$NEW_USER/.rtorrent.rc
sed -i 's/@port/5000/g' /home/$NEW_USER/.rtorrent.rc
sed -i 's/@rutorrent/'$RUTORRENT'/g' /home/$NEW_USER/.rtorrent.rc

# Configuration de Rtorrent
cp /tmp/seedbox/rtorrent $RTORRENT
chmod +x $RTORRENT
update-rc.d rtorrent defaults 99
sed -i 's/@user/'$NEW_USER'/g' $RTORRENT

# Configuration de apache
a2enmod ssl proxy_scgi auth_digest
service apache2 force-reload

# Création du certificat ssl
mkdir /etc/apache2/ssl
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/apache2/ssl/rutorrent.pem -out /etc/apache2/ssl/rutorrent.pem
chmod 600 /etc/apache2/ssl/rutorrent.pem

# Accès Rutorrent
cp /tmp/seedbox/config/rutorrent.conf /etc/apache2/sites-available/
a2ensite rutorrent
#rm /etc/apache2/ports.conf
#cp /tmp/seedbox/config/ports.conf /etc/apache2/

# Créations de l'utilisateur
sudo htdigest -c /etc/apache2/.htpasswd rutorrent $NEW_USER

# Redémarrage Apache2
service apache2 restart

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

#Démarrage de rtorrent
service rtorrent start
