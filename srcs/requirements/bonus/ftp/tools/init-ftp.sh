#!/bin/bash

useradd -m "${FTP_USER}" || true
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

chown -R ${FTP_USER}:${FTP_USER} /var/www/html

exec /usr/sbin/vsftpd /etc/vsftpd.conf