#!/bin/bash
set -e

sudo apt-get update

sudo apt-get install -y openssh-server

echo "Ожидаем появления /vagrant/sr_key.pub от клиента..."
for i in {1..30}; do
    if [ -f /vagrant/sr_key.pub ]; then
        break
    fi
    sleep 1
done

if [ ! -f /vagrant/sr_key.pub ]; then
    echo "Файл /vagrant/sr_key.pub не найден!"
    exit 1
fi

cat /vagrant/sr_key.pub >> /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
echo "Ключ клиента добавлен в ~/.ssh/authorized_keys"

rm -f /vagrant/sr_key.pub

echo "Настройка сервера завершена."
