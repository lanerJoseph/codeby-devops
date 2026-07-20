#!/bin/bash

DIR="$HOME/myfolder"

mkdir -p "$DIR"

echo "Привет!" > "$DIR/file1.txt"
date >> "$DIR/file1.txt"

touch "$DIR/file2.txt"
chmod 777 "$DIR/file2.txt"

tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 20 > "$DIR/file3.txt"
echo >> "$DIR/file3.txt"

touch "$DIR/file4.txt"
touch "$DIR/file5.txt"
