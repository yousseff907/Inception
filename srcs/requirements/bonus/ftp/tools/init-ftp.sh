#!/bin/bash

useradd -m "${FTP_USER}" || true
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

exec /usr/sbin/vsftpd /etc/vsftpd.conf