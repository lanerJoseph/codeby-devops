#!/bin/bash

WORK_DIR="$HOME/myfolder"

FILE2="$WORK_DIR/file2.txt"

[ -d "$WORK_DIR" ] || exit 0

echo "Количество файлов: $(find "$WORK_DIR" -maxdepth 1 -type f | wc -l)"

if [ -f "$FILE2" ]; then
    chmod 664 "$FILE2"
fi

find "$WORK_DIR" -maxdepth 1 -type f -empty -delete

for CURRENT_FILE in "$WORK_DIR"/*; do
    [ -f "$CURRENT_FILE" ] || continue

    TEMP_FILE="${CURRENT_FILE}.tmp"

    head -n 1 "$CURRENT_FILE" > "$TEMP_FILE"
    mv "$TEMP_FILE" "$CURRENT_FILE"
done

exit 0
