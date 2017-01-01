#!/bin/bash

# Création du nom d'utilisateur

read -p 'Choisissez un nom d utilisateur:' new_user
adduser $new_user
mkdir /home/$new_user/
mkdir /home/$new_user/watch/
mkdir /home/$new_user/torrent/
mkdir /home/$new_user/sesion/
chown -R $new_user:$new_user /home/$new_user

# Interdiction connection ssh
#Ajouter DenyUsers $new_user à /etc/ssh/sshd_config
#
#service ssh reload

# Création du fichier de configuration de rtorrent
cp /tmp/seedbox/config/.rtorrent.rc /home/$new_user/torrent/.rtorrent.rc
chown $new_user:$new_user /home/$new_user/torrent/.rtorrent.rc
sed -i 's/user/$new_user/g' /home/$new_user/.rtorrent.rc
