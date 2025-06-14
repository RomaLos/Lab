#!/bin/bash

ETC_DIR="/etc"

if [ ! -d "$ETC_DIR" ]; then
    echo "Помилка: Каталог $ETC_DIR не існує!"
    exit 1
fi

echo "Аналіз каталогу: $ETC_DIR"
echo "================================"

regular_files=$(find "$ETC_DIR" -type f 2>/dev/null | wc -l)
echo "Звичайні файли: $regular_files"

directories=$(find "$ETC_DIR" -type d 2>/dev/null | tail -n +2 | wc -l)
echo "Каталоги: $directories"

symlinks=$(find "$ETC_DIR" -type l 2>/dev/null | wc -l)
echo "Символічні посилання: $symlinks"

hard_links=$(find "$ETC_DIR" -type f -links +1 2>/dev/null | wc -l)
echo "Жорсткі посилання: $hard_links"

total=$((regular_files + directories + symlinks))
echo "================================"
echo "Загальна кількість: $total"

echo ""
echo "Детальна статистика:"
echo "- Файли: $regular_files"
echo "- Каталоги: $directories" 
echo "- Символічні посилання: $symlinks"
echo "- Жорсткі посилання: $hard_links"

output_file="etc_analysis_$(date +%Y%m%d_%H%M%S).txt"
{
    echo "Аналіз каталогу /etc - $(date)"
    echo "================================"
    echo "Звичайні файли: $regular_files"
    echo "Каталоги: $directories"
    echo "Символічні посилання: $symlinks"
    echo "Жорсткі посилання: $hard_links"
    echo "Загальна кількість: $total"
} > "$output_file"

echo ""
echo "Результати збережено у файл: $output_file"
