#! /bin/bash

apt update && apt -y remove bacula-* php-$PHP_BACULA_DB

rm -r /etc/profile.d/Bacula_Database.sh

apt update && apt -y remove baculum-common baculum-api baculum-api-apache2 baculum-web baculum-web-apache2 apache2

rm -r /etc/apt/sources.list.d/Bacula-Community.list

rm -r /etc/apt/sources.list.d/baculum.list

rm -r /etc/apt/trusted.gpg.d/bacula.gpg

apt-key del E9DF3643

rm -r /etc/apt/trusted.gpg.d/baculum.gpg

apt-key del 5C3DBD51

apt autoremove -y