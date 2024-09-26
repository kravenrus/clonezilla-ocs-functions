#!/bin/bash

# sudo -i
# apt update && apt install -y open-vm-tools-desktop git squashfs-tools
# cd /tmp
# git clone https://github.com/kravenrus/clonezilla-ocs-functions.git
# cd clonezilla-ocs-functions
# chmod +x change.clonezilla-live-amd64-3.1.3-16-and-20240715-noble.ocs-functions.sh
# ./change.clonezilla-live-amd64-3.1.3-16-and-20240715-noble.ocs-functions.sh

# Создание рабочего каталога
mkdir -p /home/ubuntu/clonezilla/custom; cd /home/ubuntu/clonezilla
# Ожидание нажатия любой клавиши для продолжения
echo Подключите .iso образ к виртуальной машине и нажмите любую клавишу для продолжения...; read -n 1
# Копирование Squashfs-образа в ранее созданный каталог
#cp /media/ubuntu/3.1.3-16-amd64/live/filesystem.squashfs /home/ubuntu/clonezilla/filesystem.squashfs
#cp /media/ubuntu/20240715-noble-amd64/live/filesystem.squashfs /home/ubuntu/clonezilla/filesystem.squashfs
# Путь к первой и второй версиям файлов
location1="/media/ubuntu/3.1.3-16-amd64/live/filesystem.squashfs"
location2="/media/ubuntu/20240715-noble-amd64/live/filesystem.squashfs"

# Директория назначения
destination="/home/ubuntu/clonezilla/filesystem.squashfs"

# Проверка наличия первого файла
if [ -f "$location1" ]; then
    echo "Определено расположение: $location1"
    cp "$location1" "$destination"
    echo "Файл скопирован"
# Проверка наличия второго файла, если первый не найден
elif [ -f "$location2" ]; then
    echo "Определено расположение: $location2"
    cp "$location2" "$destination"
    echo "Файл скопирован"
# Если ни один из файлов не найден
else
    echo "Ни одно расположение не найдено!"
fi
# Распаковка образа
unsquashfs filesystem.squashfs
# Внесение изменений в скрипт ../squashfs-root/usr/share/drbl/sbin/ocs-functions
sed -i '/    initrd_tool="update-initramfs"/a \  elif [ -e "$mnt_pnt/$extra_root_path/usr/sbin/make-initrd" ]; then\n    initrd_tool="make-initrd"' /home/ubuntu/clonezilla/squashfs-root/usr/share/drbl/sbin/ocs-functions
sed -i '/  case "$initrd_tool" in/a \    # initrd_tool for ALT Education 10.2 or earlier x86_64 (from 26.09.2024 by Kravenrus)\n    "make-initrd")\n      mkinitrd_cmd="make-initrd --kernel=$(ls $mnt_pnt/$extra_root_path/lib/modules | grep alt)" ;;' /home/ubuntu/clonezilla/squashfs-root/usr/share/drbl/sbin/ocs-functions
# Запаковка образа
mksquashfs squashfs-root/ custom/filesystem.squashfs
# Ожидание нажатия любой клавиши для продолжения
echo Сохраните копию Squashfs-образа в папке custom и нажмите любую клавишу для продолжения...; read -n 1
# Удаление рабочего каталога
rm -R /home/ubuntu/clonezilla
