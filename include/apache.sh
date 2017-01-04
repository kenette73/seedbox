# Installations d'apache 
apt-get install -y apache2 apache2.2-common apache2-utils libapache2-mod-scgi libapache2-mod-php5

echo "Apache installé"

a2enmod ssl proxy_scgi auth_digest
service apache2 force-reload

# Création du certificat ssl
mkdir /etc/apche2/ssl
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/apache2/ssl/rutorrent.pem -out /etc/apache2/ssl/rutorrent.pem
chmod 600 /etc/apache2/ssl/rutorrent.pem

# Accès Rutorrent
cp /tmp/seedox/config/rutorrent.conf /etc/apache2/sites-available/
a2ensite rutorrent
rm /etc/apache2/ports.conf
cp /tmp/seedbox/config/ports.conf /etc/apache2/

# Créations de l'utilisateur
sudo htdigest -c /etc/apache2/.htpasswd rutorrent $NEW_USER

# Redémarrage Apache2
service apache2 restart
