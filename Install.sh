#! /bin/bash
SO=NULL
BACULA_DB=NULL
PHP_BACULA_DB=NULL

apt update && apt upgrade -y && apt -y install gnupg

clear

while [ $SO == NULL ]
do
    echo "Selecione o Sistema Operacional:"
    echo "1 - Debian 11 (Bullseye)"
    echo "2 - Ubuntu 10 (Buster)"
    echo "3 - Ubuntu 22.04 (Jammy Jellyfish)"
    echo "4 - Ubuntu 20.04 (Focal Fossa)"
    echo "5 - Exit"
    read SO
    for i in {1..5};
    do
        if [ $SO -eq $i ];
        then
            break 2
        fi
    done
    SO=NULL
    clear
done

case $SO in
    1)
        echo "Debian 11 (Bullseye)"
        echo "deb [arch=amd64] https://bacula.org/packages/5f1e8eefd1016/bacula/debs/13.0.1 bullseye main" > /etc/apt/sources.list.d/Bacula-Community.list
        echo "deb http://www.bacula.org/downloads/baculum/stable-11/debian bullseye main
        deb-src http://www.bacula.org/downloads/baculum/stable-11/debian bullseye main" > /etc/apt/sources.list.d/baculum.list
        ;;
    2)
        echo "Debian 10 (Buster)"
        echo "deb [arch=amd64] https://bacula.org/packages/5f1e8eefd1016/bacula/debs/13.0.1 buster main" > /etc/apt/sources.list.d/Bacula-Community.list
        echo "deb http://www.bacula.org/downloads/baculum/stable-11/debian buster main
        deb-src http://www.bacula.org/downloads/baculum/stable-11/debian buster main" > /etc/apt/sources.list.d/baculum.list
        
        ;;
    3)
        echo "Ubuntu 22.04 (Jammy Jellyfish)"
        echo "deb [arch=amd64] https://bacula.org/packages/5f1e8eefd1016/bacula/debs/13.0.1 jammy main" > /etc/apt/sources.list.d/Bacula-Community.list
        echo "deb [ arch=amd64 ] http://www.bacula.org/downloads/baculum/stable-11/ubuntu focal main
        deb-src http://www.bacula.org/downloads/baculum/stable-11/ubuntu focal main" > /etc/apt/sources.list.d/baculum.list
        ;;
    4)
        echo "Ubuntu 20.04 (Focal Fossa)"
        echo "deb [arch=amd64] https://bacula.org/packages/5f1e8eefd1016/bacula/debs/13.0.1 focal main" > /etc/apt/sources.list.d/Bacula-Community.list
        echo "deb [ arch=amd64 ] http://www.bacula.org/downloads/baculum/stable-11/ubuntu focal main
        deb-src http://www.bacula.org/downloads/baculum/stable-11/ubuntu focal main" > /etc/apt/sources.list.d/baculum.list
        ;;
    5)
        echo "Saindo ..."
        exit 0
        ;;    
esac

while [ $BACULA_DB == NULL ]
do
    echo "Selecione o Database:"
    echo "1 - MySQL"
    echo "2 - PostgreSQL"
    echo "3 - Exit"
    read BACULA_DB
    for i in {1..3};
    do
        if [ $BACULA_DB -eq $i ];
        then
            break 2
        fi
    done
    BACULA_DB=NULL
done

case $BACULA_DB in
    1)
        echo "MySQL"
        BACULA_DB=mysql
        PHP_BACULA_DB=mysql
        ;;
    2)
        echo "PostgreSQL"
        BACULA_DB=postgresql
        PHP_BACULA_DB=pgsql
        echo
        ;;
    3)
        echo "Saindo ..."
        exit 0
        ;;    
esac

echo "export BACULA_DB=$BACULA_DB
export PHP_BACULA_DB=$PHP_BACULA_DB" > /etc/profile.d/Bacula_Database.sh

wget https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc
    
apt-key add Bacula-4096-Distribution-Verification-key.asc 

rm Bacula-4096-Distribution-Verification-key.asc

apt-key export E9DF3643 | gpg --dearmour -o /etc/apt/trusted.gpg.d/bacula.gpg --yes
 
wget -qO - http://www.bacula.org/downloads/baculum/baculum.pub | apt-key add - 

apt-key export 5C3DBD51 | gpg --dearmour -o /etc/apt/trusted.gpg.d/baculum.gpg --yes

apt update

apt -y install bacula-$BACULA_DB php-$PHP_BACULA_DB

apt -y install php-bcmath php-mbstring php-dom php-curl php-ldap baculum-common baculum-api baculum-api-apache2 baculum-web baculum-web-apache2

a2enmod rewrite

a2ensite baculum-api

a2ensite baculum-web

echo "Defaults:www-data !requiretty
www-data ALL = (root) NOPASSWD: /opt/bacula/bin/bconsole
www-data ALL = (root) NOPASSWD: /opt/bacula/bin/bdirjson
www-data ALL = (root) NOPASSWD: /opt/bacula/bin/bsdjson
www-data ALL = (root) NOPASSWD: /opt/bacula/bin/bfdjson
www-data ALL = (root) NOPASSWD: /opt/bacula/bin/bbconsjson
www-data ALL = (root) NOPASSWD: /usr/bin/systemctl start bacula-dir
www-data ALL = (root) NOPASSWD: /usr/bin/systemctl stop bacula-dir
www-data ALL = (root) NOPASSWD: /usr/bin/systemctl restart bacula-dir
www-data ALL = (root) NOPASSWD: /usr/bin/systemctl start bacula-sd
www-data ALL = (root) NOPASSWD: /usr/bin/systemctl stop bacula-sd
www-data ALL = (root) NOPASSWD: /usr/bin/systemctl restart bacula-sd
www-data ALL = (root) NOPASSWD: /usr/bin/systemctl start bacula-fd
www-data ALL = (root) NOPASSWD: /usr/bin/systemctl stop bacula-fd
www-data ALL = (root) NOPASSWD: /usr/bin/systemctl restart bacula-fd" > /etc/sudoers.d/baculum-api

chown www-data -R /opt/bacula/working

systemctl restart apache2
