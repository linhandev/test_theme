# 完成分盘

pacman -Syy # 更新pacman数据库
pacman -S reflector --noconfirm
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bk # 备份镜像列表
reflector -c "US" -l 20 -n 10 --sort rate --save /etc/pacman.d/mirrorlist

mount /dev/nvme1n1p2 /mnt
pacstrap /mnt base linux linux-firmware vim sudo base-devel # 往主分区里安装，几分钟
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

timedatectl list-timezones # 显示所有时区
timedatectl set-timezone Asia/Shanghai
timedatectl set-ntp true # 开启联网时间校准

echo """
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
""" >> /etc/locale.gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

echo linArch >> /etc/hostname
echo """
127.0.0.1 localhost
::1 localhost
127.0.1.1 linArch
""" >> /etc/hosts

pacman -S grub efibootmgr --noconfirm
mkdir /boot/efi
mount /dev/nvme1n1p1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi # 注意那个x是小写的
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S xorg xfce4 xfce4-goodies lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm
systemctl enable lightdm
pacman -S wpa_supplicant wireless_tools networkmanager --noconfirm

pacman -S nm-connection-editor network-manager-applet --noconfirm
systemctl enable NetworkManager.service
systemctl disable dhcpd.service # todo: dhcpd not found
systemctl enable wpa_supplicant.service

useradd lin
echo "lin ALL=(ALL) ALL" >> /etc/sudoers
mkdir /home/lin
chown -R lin:lin /home/lin

