#!/bin/bash

useradd -m "${FTP_USER}" || true
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

usermod -aG www-data "${FTP_USER}"
chmod -R 775 /var/www/html
usermod -d /var/www/html "${FTP_USER}"

exec /usr/sbin/vsftpd /etc/vsftpd.conf
