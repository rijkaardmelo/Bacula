#! /bin/bash

rm -r /etc/apt/sources.list.d/Bacula-Community.list

rm -r /etc/apt/sources.list.d/baculum.list

rm -r /etc/apt/trusted.gpg.d/bacula.gpg

apt-key del E9DF3643

rm -r /etc/apt/trusted.gpg.d/baculum.gpg

apt-key del 5C3DBD51

apt update && apt -y install bacula-$DB php-$PHP_DB