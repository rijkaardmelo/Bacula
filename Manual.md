# Install Bacula 13 in Ubuntu 22.04

## Additional Package Installation

    apt update && apt -y install apt-transport-https

    deb [arch=amd64] https://bacula.org/packages/5f1e8eefd1016/bacula/debs/13.0.1 jammy main

## Import the GPG key

    cd /tmp

    wget https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc
    
    apt-key add Bacula-4096-Distribution-Verification-key.asc
    
    rm Bacula-4096-Distribution-Verification-key.asc

## `apt` Package Manager Configuration

### Create a new sources list file:

    /etc/apt/sources.list.d/Bacula-Community.list

### and write the following repositories in it
    
    #Bacula Community
    deb [arch=amd64] https://bacula.org/packages/5f1e8eefd1016/bacula/debs/13.0.1 jammy main

# Install Baculum in Ubuntu Focal

## Import the public key into the APT trusted key list:

    wget -qO - http://www.bacula.org/downloads/baculum/baculum.pub | apt-key add -

## Create a new sources list file:

    /etc/apt/sources.list.d/baculum.list

## and write the following repositories in it

    deb [ arch=amd64 ] http://www.bacula.org/downloads/baculum/stable/ubuntu focal main
    deb-src http://www.bacula.org/downloads/baculum/stable/ubuntu focal main

## Baculum API

### Baculum API with Apache web server

    apt-get install baculum-common baculum-api baculum-api-apache2

#### After installation you must enable the rewrite Apache module:

    a2enmod rewrite

#### There is also required to enable the baculum-api virtual host site:

    a2ensite baculum-api

#### At the end please restart (or reload) the new Apache web server configuration:

    systemctl restart apache2

### ou Baculum API with Lighttpd web server

    apt-get install baculum-common baculum-api baculum-api-lighttpd

#### After installation please start the Lighttpd web server:

    systemctl start baculum-api-lighttpd

## Baculum Web

### Baculum Web with Apache web server

    apt-get install baculum-common baculum-web baculum-web-apache2

#### After installation you must enable the rewrite Apache module:

    a2enmod rewrite

#### There is also required to enable the baculum-web virtual host site:

    a2ensite baculum-web

#### At the end please restart (or reload) the new Apache web server configuration:

    systemctl restart apache2

### ou Baculum Web with Lighttpd web server

    apt-get install baculum-common baculum-web baculum-web-lighttpd

#### After installation please start the Lighttpd web server:

    systemctl start baculum-web-lighttpd