#!/bin/bash

# Log Installation
exec > >(tee "/tmp/seedbox/install.log") 2>&1

# Installations des depots pour ffmpeg
apt-get install -y software-properties-common
apt-add-repository "deb http://mirrors.online.net/debian jessie-backports main non-free contrib"

# Vérifications des mise à jour
sudo apt-get update

# Installations des paquets nécessaires à Rtorrent et Rutorrent
apt-get install -y build-essential subversion curl gcc g++ rtorrent screen gzip mediainfo ffmpeg unrar zip \
                   apache2 apache2.2-common apache2-utils libapache2-mod-scgi libapache2-mod-php5 \
                   pure-ftpd

# Include
source ./include/variables.sh

# Création de l'utilisateur et des répertoires
read -p "Choisissez un nom d utilisateur:" new_user
useradd -s /bin/bash $new_user
passwd $new_user
mkdir -p /home/$new_user/{watch,torrents,.session}

# Création du fichier de configuration de rtorrent
cd /home/$new_user
cp /tmp/seedbox/config/.rtorrent.rc /home/$new_user/
sed -i "s/@user/$new_user/g" .rtorrent.rc
sed -i "s/@port/5000/g" .rtorrent.rc

# Configuration de Rtorrent
cp /tmp/seedbox/config/rtorrent /etc/init.d/
chmod +x /etc/init.d/rtorrent
sed -i "s/@user/$new_user/g" /etc/init.d/rtorrent
update-rc.d rtorrent defaults 99

# Configuration de apache
a2enmod ssl auth_digest scgi
echo "servername localhost" >> /etc/apache2/apache2.conf
echo "SCGIMount /RCP2 127.0.0.1:5000" >> /etc/apache2/apache2.conf
service apache2 restart

# Création du certificat ssl
mkdir /etc/apache2/ssl
openssl req \
       -newkey rsa:2048 -nodes -keyout /etc/apache2/ssl/rutorrent.key \
       -x509 -days 365 -out /etc/apache2/ssl/rutorrent.crt
chmod 644 /etc/apache2/ssl/rutorrent.crt
chmod 600 /etc/apache2/ssl/rutorrent.key

# Accès Rutorrent
cp /tmp/seedbox/config/rutorrent.conf /etc/apache2/sites-available/
sed -i "s/@ip/$get_ip/g" /etc/apache2/sites-available/rutorrent.conf
a2ensite rutorrent

# Création de l'utilisateur ruTorrent
mkdir /etc/apache2/passwd
sudo htdigest -c /etc/apache2/passwd/.rutorrent rutorrent $new_user

# Installation de Rutorrent
cd /var/www/html
git clone https://github.com/Novik/ruTorrent rutorrent
mkdir rutorrent/conf/users/$new_user
cp /tmp/seedbox/config/users/* rutorrent/conf/users/$new_user/
sed -i "s/@user/$new_user/g" rutorrent/conf/users/$new_user/config.php
sed -i "s/@port/5000/g" rutorrent/conf/users/$new_user/config.php

# Suppression des thèmes
cd /var/www/html/rutorrent/plugins/theme/themes
rm -R {Acid,Blue,Dark,Excel}

# Gestions des droits des fichiers & dossiers
chown -R $new_user:$new_user /home/$new_user
chown root:$new_user /home/$new_user
chmod -R 755 /home/$new_user
chown -R www-data:www-data /var/www/html/rutorrent
chmod -R 755 /var/www/html/rutorrent

# Configurations du serveur FTP
groupadd ftpgroup
useradd -g ftpgroup -d /dev/null -s /usr/sbin/nologin ftpuser
sudo ln -s /etc/pure-ftpd/conf/PureDB /etc/pure-ftpd/auth/50pure
ln -s /etc/pure-ftpd/conf/PureDB /etc/pure-ftpd/auth/75puredb

# Création de l'utilisateur FTP
pure-pw useradd $new_user -u ftpuser -g ftpgroup -d /home/$new_user/torrents
pure-pw mkdb

#Démarrage de rtorrent & Apache2 & Pure-ftpd
/etc/init.d/rtorrent start
service apache2 restart
/etc/init.d/pure-ftpd restart

exit 0
