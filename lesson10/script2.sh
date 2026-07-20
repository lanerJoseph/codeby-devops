#!/bin/bash

DIR="$HOME/myfolder"

[ -d "$DIR" ] || exit 0

echo "Количество файлов: $(find "$DIR" -maxdepth 1 -type f | wc -l)"

if [ -f "$DIR/file2.txt" ]; then
    chmod 664 "$DIR/file2.txt"
fi

find "$DIR" -maxdepth 1 -type f -empty -delete

for file in "$DIR"/*; do
    [ -f "$file" ] || continue
    head -n 1 "$file" > "$file.tmp"
    mv "$file.tmp" "$file"
done
