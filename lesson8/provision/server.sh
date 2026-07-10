#!/bin/bash


DOMAIN="lesson8.local"


apt update

apt install -y apache2 openssl



mkdir -p /etc/apache2/ssl


openssl req \
-x509 \
-nodes \
-days 365 \
-newkey rsa:2048 \
-keyout /etc/apache2/ssl/$DOMAIN.key \
-out /etc/apache2/ssl/$DOMAIN.crt \
-subj "/C=RU/ST=Moscow/L=Moscow/O=Company/CN=$DOMAIN"



a2enmod ssl
a2enmod rewrite



mkdir -p /var/www/$DOMAIN


echo "

<h1>
Lesson 8 HTTPS Server
</h1>

<p>
Domain: $DOMAIN
</p>

" > /var/www/$DOMAIN/index.html



cat > /etc/apache2/sites-available/$DOMAIN.conf <<EOF

<VirtualHost *:80>

ServerName $DOMAIN
ServerAlias www.$DOMAIN

RewriteEngine On

RewriteRule ^/(.*)$ https://$DOMAIN/\$1 [R=301,L]

</VirtualHost>



<VirtualHost *:443>

ServerName www.$DOMAIN

SSLEngine On

SSLCertificateFile /etc/apache2/ssl/$DOMAIN.crt

SSLCertificateKeyFile /etc/apache2/ssl/$DOMAIN.key


RewriteEngine On

RewriteCond %{HTTP_HOST} ^www\.$DOMAIN$ [NC]

RewriteRule ^/(.*)$ https://$DOMAIN/\$1 [R=301,L]


</VirtualHost>





<VirtualHost *:443>

ServerName $DOMAIN


DocumentRoot /var/www/$DOMAIN


SSLEngine On


SSLCertificateFile /etc/apache2/ssl/$DOMAIN.crt

SSLCertificateKeyFile /etc/apache2/ssl/$DOMAIN.key



<Directory /var/www/$DOMAIN>

AllowOverride All

Require all granted

</Directory>


</VirtualHost>


EOF



a2dissite 000-default.conf

a2ensite $DOMAIN.conf



systemctl restart apache2
