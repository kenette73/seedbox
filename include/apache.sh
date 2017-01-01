# Installations d'apache 
apt-get install -y apache2 apache2.2-common apache2-utils libapache2-mod-scgi

echo "Apache installé"

a2enmod ssl
service apache2 force-reload

# Création du certificat ssl
cd /etc/ssl
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr

# Signature du certificat ssl
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
