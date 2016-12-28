# Installation des pacquets pour Rtorrent et Libtorrent
apt-get install -y git-core libtool libncurses5-dev libncursesw5-dev libcurl4-openssl-dev libcppunit-dev libssl-dev pkg-config

echo "Paquets installés"

# Installation et compilation de Libtorrent
cd /tmp
git clone https://github.com/rakshasa/libtorrent.git
cd libtorrent
./autogen.sh
./configure --without-zlib
make
make install
make clean
rm -R /tmp/libtorrent

echo "Libtorrent installée"
