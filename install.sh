#!/bin/bash

# Log Installation
exec > >(tee "/tmp/seedbox/install.log") 2>&1

# Installations des depots pour ffmpeg
apt-get install -y software-properties-common
apt-add-repository "deb http://mirrors.online.net/debian jessie-backports main non-free contrib"

# Vérifications des mise à jour
sudo apt-get update

# Création de l'utilisateur et des répertoires
read -p 'Choisissez un nom d utilisateur:' new_user
useradd -m $new_user
passwd $new_user
mkdir -p /home/$new_user/{watch,torrents,.session}
chown -R $new_user:$new_user /home/$new_user
chmod -R 755 /home/$new_user

# Interdiction connection ssh
#Ajouter DenyUsers $new_user à /etc/ssh/sshd_config
#service ssh reload

# Include
dir="include"
. "$dir"/variables.sh

# Installations des paquets nécessaires à Rtorrent et Rutorrent
apt-get install -y build-essential subversion autoconf automake curl gcc g++ rtorrent screen gzip mediainfo ffmpeg unrar zip apache2 apache2.2-common apache2-utils libapache2-mod-scgi libapache2-mod-php5

# Création du fichier de configuration de rtorrent
cp /tmp/seedbox/.rtorrent.rc /home/$new_user/.rtorrent.rc
chown $new_user:$new_user /home/$new_user/.rtorrent.rc
sed -i 's/@user/"$new_user"/g' /home/$new_user/.rtorrent.rc
sed -i 's/@port/5000/g' /home/$new_user/.rtorrent.rc
#sed -i 's/@rutorrent/"$rutorrent"/g' /home/$new_user/.rtorrent.rc

# Configuration de Rtorrent
cp /tmp/seedbox/rtorrent /etc/init.d/
chmod +x /etc/init.d/rtorrent
sed -i 's/@user/"$new_user"/g' /etc/init.d/rtorrent
update-rc.d rtorrent defaults 99

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
sudo htdigest -c /etc/apache2/.htpasswd rutorrent $new_user

# Redémarrage Apache2
service apache2 restart

# Installation de Rutorrent
cd $www
git clone https://github.com/Novik/ruTorrent rutorrent
mkdir $conf/$new_user
cp /tmp/seedbox/config/config.php $conf/$new_user/
cp /tmp/seedbox/config/plugins.ini $conf/$new_user/
sed -i 's/@user/"$new_user"/g' $conf/$new_user/config.php
sed -i 's/@port/5000/g' $conf/$new_user/config.php
chown -R www-data:www-data $rutorrent
chmod -R 755 $RUTORRENT

#Démarrage de rtorrent
/etc/init.d/rtorrent start
