###########################################################################################
# Script to build CNISUPPSVR02                                                            #
# Author: Dave Collier@21082013                                                           #
#                                                                                         #
# Installation instructions:                                                              #
# *************************************************************************************** #                   
# 1. Base installataion: CENTOS version 6.4 64bit minimal server build                    # 
# REQUIRED ADDITIONAL PACKAGES: Web server package with optional ssl_mod selected and     #
# PostgreSQL Server                                                                       #
#                                                                                         #
# 2. Setup network                                                                        #
#	Use system-config-network, or                                                     #
#	Setup manually. Assume network device is eth0                                     #
#	a. vi /etc/sysconfig/network-scripts/ifcfg-eth0 and add                           #
#		IPADDR=x.x.x.x                                                            #
#		BOOTPROTO=none                                                            #
#		NETMASK=255.255.255.0                                                     #
#		GATEWAY=x.x.x.x                                                           #
#		DNS1=x.x.x.x                                                              #
#		DNS2=x.x.x.x                                                              #
#		USERCTL=yes                                                               #
#	b. vi /etc/sysconfig/network and add                                              #
#		GATEWAY=x.x.x.x                                                           #
#	c. /etc/init.d/networking restart or ifup eth0                                    #
#                                                                                         #
# 3. yum install git                                                                      # 
#                                                                                         #
# 4. git clone https://github.com/lardelbow/server-diagnostic-centre-rails3.git           #
#    to /var/www and edit ./config/database.yaml with DB credentials                      #       
#	production:                                                                       #
#         adapter: postgresql                                                             #
#  	  encoding: unicode                                                               #
#  	  database: PG_DBNAME                                                             #
#  	  pool: 5                                                                         #
#  	  username: PG_USER                                                               #
#  	  password: PG_PASS                                                               #
#                                                                                         #
# 5. Setup the environment vairiables below                                               #
#                                                                                         #
# 6. ./environment_builds/build_centos_6_4_64_ror.ksh 2>&1 | tee ./installation.log       #
###########################################################################################

# Setup environment variables
setup_environment () 
{
 echo "*** SETUP ENVIRONMENT ***"
 export YAML_VER="0.1.4"
 export RUBY_VER="2.0.0-p247"
 export PASSENGER_VER="4.0.14"
 export BUILD_DIR="/usr/src"
 export APP_DIR="/var/www"
 export APP_PORT="80"
 export APP_NAME="server-diagnostic-centre-rails3"
 export PG_DBNAME="match to that setp in ./config/database.yaml"
 export PG_USER="match to that setp in ./config/database.yaml"
 export PG_PASS="match to that setp in ./config/database.yaml"
 sleep 2
 echo "*** COMPLETED SETUP ENVIRONMENT ***"
}

# Update current build with the latest software
update_distro_to_latest()
{
 echo "*** UPDATE DISTRO TO LATEST ***"
 yum -y update
 sleep 2
 echo "*** COMPLETED UPDATE DISTRO TO LATEST ***"
}

# Install tools for compiling software
install_dev_tools()
{
 echo "*** INSTALL DEV TOOLS ***"
 yum -y groupinstall "Development Tools"
 sleep 2
 echo "*** COMPLETED INSTALL DEV TOOLS ***"
}

# Install additional libraries
install_libs()
{
 echo "*** INSTALL LIBS ***"
 yum -y install zlib zlib-devel openssl-devel curl-devel httpd-devel apr-devel apr-util-devel ftp telnet wget postgresql-devel.x86_64 libxslt-devel libxml2-devel
 sleep 2
 echo "*** COMPLETED INSTALL LIBS ***"
}

# Download, build and install YMAL
install_yaml()
{
 echo "*** INSTALL YAML ***"
 cd $BUILD_DIR
 wget http://pyyaml.org/download/libyaml/yaml-$YAML_VER.tar.gz
 tar zxvf yaml-$YAML_VER.tar.gz
 cd yaml-$YAML_VER
 ./configure --prefix=/usr/local --enable-shared
 make clean
 make
 make install
 sleep 2
 echo "*** COMPLETED INSTALL YAML ***"
}

# Download, build and install Ruby
install_ruby()
{
 echo "*** INSTALL RUBY ***"
 cd $BUILD_DIR
 wget ftp://ftp.ruby-lang.org/pub/ruby/`echo $RUBY_VER | cut -c 1,2,3`/ruby-$RUBY_VER.tar.gz
 tar xvfz ruby-$RUBY_VER.tar.gz
 cd ruby-$RUBY_VER
 ./configure
 make clean
 make
 make install
 sleep 2
 echo "*** COMPLETED INSTALL RUBY ***"
}

# Install bundler and passenger gems
install_gems()
{
 echo "*** INSTALL GEMS ***"
 gem install bundler
 gem install passenger --version "$PASSENGER_VER"
 passenger-install-apache2-module
 sleep 2
 echo "*** COMPLETED INSTALL GEMS ***"
}

# Configure passenger
config_passenger()
{
 echo "*** CONFIG PASSENGER ***"
 echo "LoadModule passenger_module /usr/local/lib/ruby/gems/`echo $RUBY_VER | cut -c 1,2,3,4,5`/gems/passenger-$PASSENGER_VER/buildout/apache2/mod_passenger.so" > /etc/httpd/conf.d/passenger.conf
 echo "PassengerRoot /usr/local/lib/ruby/gems/`echo $RUBY_VER | cut -c 1,2,3,4,5`/gems/passenger-$PASSENGER_VER" >> /etc/httpd/conf.d/passenger.conf
 echo "PassengerRuby /usr/local/bin/ruby" >> /etc/httpd/conf.d/passenger.conf
 echo "*** COMPLETED CONFIG PASSENGER ***"
 sleep 2
 echo "*** COMPLETED CONFIG PASSENGER ***"
}

# Configure postgresql
config_pg()
{
 echo "*** CONFIG PG ***"
 cd /tmp
 sudo -u postgres initdb -D /var/lib/pgsql/data
 sleep 10
 service postgresql start
 sudo -u postgres createuser -D -R -S $PG_USER
 sudo -u postgres createdb $PG_DBNAME -O $PG_USER
 sleep 2
 echo "*** COMPLETED CONFIG PG ***"
}

# Install App
config_app() 
{
 echo "*** CONFIG APP ***"
 chmod 755 -R $APP_DIR/$APP_NAME
 cd $APP_DIR/$APP_NAME
 bundle install
 bundle exec rake assets:precompile
 bundle exec rake db:schema:load
 bundle exec rake db:seed
 mkdir /etc/httpd/sites-available
 mkdir /etc/httpd/sites-enabled
 echo "<VirtualHost *:$APP_PORT>" > /etc/httpd/sites-available/$APP_NAME.conf
 echo "  	ServerName localhost" >> /etc/httpd/sites-available/$APP_NAME.conf
 echo "  	DocumentRoot /var/www/server-diagnostic-centre-rails3/public" >> /etc/httpd/sites-available/$APP_NAME.conf
 echo "  	<Directory /var/www/server-diagnostic-centre-rails3>" >> /etc/httpd/sites-available/$APP_NAME.conf
 echo "     		AllowOverride all" >> /etc/httpd/sites-available/$APP_NAME.conf
 echo "     		Options -MultiViews" >> /etc/httpd/sites-available/$APP_NAME.conf
 echo "  	</Directory>" >. /etc/httpd/sites-available/$APP_NAME.conf
 echo "</VirtualHost>" >> /etc/httpd/sites-available/$APP_NAME.conf
 ln -s /etc/httpd/sites-available/$APP_NAME.conf /etc/httpd/sites-enabled/$APP_NAME.conf
 sleep 2
 echo "*** COMPLETED CONFIG APP ***"
}

# Configure Firewall and Security and start httpd server
config_fw_sec_httpd()
{
 echo "*** CONFIG FW SEC HTTPD ***"
 iptables -I INPUT 4 -p tcp --dport 80 -j ACCEPT
 iptables -L
 service iptables save
 setenforce 0
 service httpd start
 setenforce 1
 sestatus
 sleep 2
 echo "*** COMPLETED CONFIG FW SEC HTTPD ***"
}

# Main Script
setup_environment
update_distro_to_latest
install_dev_tools
install_libs
install_yaml
install_ruby
install_gems
config_passenger
config_pg
config_app
config_fw_sec_httpd

echo 'Script completed...all done!'

# All Done!
