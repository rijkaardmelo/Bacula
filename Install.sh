#! /bin/bash

# Install Bacula 13 in Debian 11

apt update && apt -y install gnupg

cd /tmp

wget https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc
    
apt-key add Bacula-4096-Distribution-Verification-key.asc
    
rm Bacula-4096-Distribution-Verification-key.asc

cd /

echo "deb [arch=amd64] https://bacula.org/packages/5f1e8eefd1016/bacula/debs/13.0.1 bullseye main" > /etc/apt/sources.list.d/Bacula-Community.list

apt update && apt -y install bacula-postgresql php7.4-pgsql 

# Install Baculum in Debian
wget -qO - http://www.bacula.org/downloads/baculum/baculum.pub | apt-key add -

echo "deb http://www.bacula.org/downloads/baculum/stable-11/debian bullseye main
deb-src http://www.bacula.org/downloads/baculum/stable-11/debian bullseye main" > /etc/apt/sources.list.d/baculum.list

apt update && apt -y install php7.4-bcmath php7.4-mbstring php7.4-dom php7.4-curl php7.4-ldap baculum-common baculum-api baculum-api-apache2

apt update && apt -y install baculum-common baculum-web baculum-web-apache2

a2enmod rewrite

a2ensite baculum-api

a2ensite baculum-web

echo "Defaults:www-data !requiretty
www-data ALL = (root) NOPASSWD: /opt/bacula/bin/bconsole
www-data ALL = (root) NOPASSWD: /opt/bacula/bin/bdirjson
www-data ALL = (root) NOPASSWD: /opt/bacula/bin/bsdjson
www-data ALL = (root) NOPASSWD: /opt/bacula/bin/bfdjson
www-data ALL = (root) NOPASSWD: /opt/bacula/bin/bbconsjson" > /etc/sudoers.d/baculum-api

chown www-data -R /opt/bacula/working

systemctl restart apache2