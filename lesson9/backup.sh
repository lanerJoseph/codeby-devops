#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p /opt/mysql_backup

mysqldump --no-tablespaces -u backup -pBackup123! lesson9_db > /opt/mysql_backup/lesson9_db__$DATE.sql

rsync -av /opt/mysql_backup/ vagrant@192.168.56.20:/opt/store/mysql/
