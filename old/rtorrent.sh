# Installation et compilation de Rtorrent
cd /tmp
git clone https://github.com/rakshasa/rtorrent.git
cd rtorrent
./autogen.sh
./configure --with-xmlrpc-c
make
make install
make check
make clean
rm -R /tmp/rotrrent

echo " Rtorrent installé"
