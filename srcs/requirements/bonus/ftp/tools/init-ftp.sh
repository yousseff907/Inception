#!/bin/bash

# Create user (if it already exists, skip)
useradd -m "${FTP_USER}" || true
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

# Give the FTP user access to WordPress files
usermod -aG www-data "${FTP_USER}"

# Make WordPress directory readable AND writable for the group (www-data)
chmod -R 775 /var/www/html

# Change the FTP user's home directory
usermod -d /var/www/html "${FTP_USER}"

exec /usr/sbin/vsftpd /etc/vsftpd.conf
