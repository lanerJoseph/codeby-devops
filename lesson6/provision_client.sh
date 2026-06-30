#!/bin/bash
set -e

sudo apt-get update

sudo apt-get install -y openssh-server

KEY_PATH="/home/vagrant/.ssh/sr_key"
if [ ! -f "$KEY_PATH" ]; then
    ssh-keygen -t rsa -b 2048 -f "$KEY_PATH" -N ""
    echo "Ключ создан: $KEY_PATH"
else
    echo "Ключ уже существует"
fi

cp "$KEY_PATH.pub" /vagrant/sr_key.pub
echo "Публичный ключ скопирован в /vagrant/sr_key.pub"

SR_IP="192.168.56.10"
if ! grep -q "$SR_IP sr" /etc/hosts; then
    echo "$SR_IP sr" | sudo tee -a /etc/hosts
    echo "Запись для sr добавлена в /etc/hosts"
else
    echo "Запись для sr уже есть"
fi

echo "Настройка клиента завершена."
