#!/bin/bash

# sudo -i
# apt update && apt install -y open-vm-tools-desktop squashfs-tools

# Создание рабочего каталога
mkdir -p /home/user/clonezilla/custom; cd /home/user/clonezilla
# Ожидание нажатия любой клавиши для продолжения
echo Подключите .iso образ к виртуальной машине и нажмите любую клавишу для продолжения...; read -n 1
# Копирование Squashfs-образа в ранее созданный каталог
cp /media/user/2.8.1-12-amd64/live/filesystem.squashfs /home/user/clonezilla/filesystem.squashfs
# Распаковка образа
unsquashfs filesystem.squashfs
# Внесение изменений в скрипт ../squashfs-root/usr/share/drbl/sbin/ocs-functions
sed -i '/    initrd_tool="update-initramfs"/a \  elif [ -e "$mnt_pnt/$extra_root_path/usr/sbin/make-initrd" ]; then\n    initrd_tool="make-initrd"' /home/user/clonezilla/squashfs-root/usr/share/drbl/sbin/ocs-functions
sed -i '/  case "$initrd_tool" in/a \    # initrd_tool for ALT Education 10.2 or earlier x86_64 (from 26.09.2024 by Kravenrus)\n    "make-initrd")\n      mkinitrd_cmd="make-initrd --kernel=$(ls $mnt_pnt/$extra_root_path/lib/modules | grep alt)" ;;' /home/user/clonezilla/squashfs-root/usr/share/drbl/sbin/ocs-functions
# Запаковка образа
mksquashfs squashfs-root/ custom/filesystem.squashfs
# Ожидание нажатия любой клавиши для продолжения
echo Сохраните копию Squashfs-образа в папке custom и нажмите любую клавишу для продолжения...; read -n 1
# Удаление рабочего каталога
rm -R /home/user/clonezilla
