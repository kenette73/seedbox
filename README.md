# seedbox
Script d'installation d'une seedbox sur debian 8 avec Rtorrent, Apache2, ruTorrent, Pure-Ftpd.

Le script installe tous les logiciels depuis les depots
#####################
#   Installations   #
#####################
Assurez vous d'avoir les droits super-utilisateurs
On installe Git pour pouvoir recuperer les fichiers
 
 sudo apt-get install git
 
# On recupère les fichiers du script #
 
 cd /tmp
 sudo git clone https://github.com/kenette73/seedbox.git
 
# On va dans le dossier du script #

 cd seedbox
 
# On rend le script executable et on le lance #

 sudo chmod +x install.sh
 sudo ./install.sh
 
# Pendant l'installation #

Vous allez devoir rentrez un nom d'utilisateur ainsi que 3 mot de passe, un pour votre compte, un pour l'accès à ruTorrent et un pour le ftp.

 
 
