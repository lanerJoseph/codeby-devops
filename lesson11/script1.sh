#!/bin/bash

WORK_DIR="$HOME/myfolder"

FILE1="$WORK_DIR/file1.txt"
FILE2="$WORK_DIR/file2.txt"
FILE3="$WORK_DIR/file3.txt"
FILE4="$WORK_DIR/file4.txt"
FILE5="$WORK_DIR/file5.txt"

mkdir -p "$WORK_DIR" || exit 1

echo "Привет!" > "$FILE1"
date >> "$FILE1"

touch "$FILE2"
chmod 777 "$FILE2"

tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 20 > "$FILE3"
echo >> "$FILE3"

touch "$FILE4"
touch "$FILE5"

exit 0
