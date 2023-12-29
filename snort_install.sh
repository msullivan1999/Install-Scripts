#update ubuntu
sudo apt-get update && sudo apt-get dist-upgrade -y

#install dependencies
sudo apt install build-essential libpcap-dev libpcre3-dev libnet1-dev zlib1g-dev luajit hwloc libdnet-dev libdumbnet-dev bison flex liblzma-dev openssl libssl-dev pkg-config libhwloc-dev cmake cpputest libsqlite3-dev uuid-dev libcmocka-dev libnetfilter-queue-dev libmnl-dev autotools-dev libluajit-5.1-dev libunwind-dev libfl-dev -y
mkdir ~/snort_src && cd ~/snort_src
git clone https://github.com/snort3/libdaq.git
cd libdaq
./bootstrap
./configure
make
sudo make install
cd ../
wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.9.1/gperftools-2.9.1.tar.gz
tar xzf gperftools-2.9.1.tar.gz
cd gperftools-2.9.1/
./configure
make
sudo make install

#Download and install from source code
cd..
wget https://github.com/snort3/snort3/archive/refs/heads/master.zip
unzip master.zip
cd snort3-master
./configure_cmake.sh --prefix=/usr/local --enable-tcmalloc
cd build
make
sudo make install

#update shared libraries after install
sudo ldconfig

#verify that snort is running correctly
snort -V

#test snort with default config file 
snort -c /usr/local/etc/snort/snort.lua

#create directroy for rules
sudo mkdir /etc/snort
sudo mkdir /etc/snort/rules
sudo mkdir /var/log/snort
sudo touch /etc/snort/snort.conf

#set up demo using ICMP to test snort
sudo chmod
sudo chmod 777 /etc/snort/snort.conf
cp /Documents/"Installation Scripts"/snort.conf /etc/snort/snort.conf
echo "include /etc/snort/rules/icmp.rules" > /etc/snort/snort.conf
sudo touch /etc/snort/rules/icmp.rules
sudo chmod 777 /etc/snort/rules/icmp.rules
echo "alert icmp any any -> any any (msg:"ICMP Packet"; sid:477; rev:1;)" > /etc/snort/rules/icmp.rules

#execute snort for the ICMP rule
snort -c /etc/snort/snort.conf -l /var/log/snort/

#note: for this alert to trigger, the host will need to be pinged




