#!/bin/bash

# Création du nom d'utilisateur

read -p 'Choisissez un nom d utilisateur:' new_user
adduser $new_user
mkdir /home/$new_user/
chmod -R $new_user:$new_user /home/$new_user

# Interdiction connection ssh
Ajouter DenyUsers $new_user à /etc/ssh/sshd_config
service ssh reload

