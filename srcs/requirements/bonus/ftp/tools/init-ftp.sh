#!/bin/bash

useradd -m "${FTP_USER}" || true
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

chown -R www-data:www-data /var/www/html
chmod -R 775 /var/www/html

exec /usr/sbin/vsftpd /etc/vsftpd.conf