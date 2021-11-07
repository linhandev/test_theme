---
title: Manjaro/Arch折腾笔记
author: Lin Han
date: 2021-01-05T15:24:00.000Z
categories:
  - Linux
tags:
  - Arch
  - Manjaro
published: false
---

装软件的时候或多或少都会装上一些不用的东西，再加上一些其他原因电脑容易越来越卡。个人比较喜欢干净所以经常重装系统，记录一些常用的步骤。

# 启动盘
首先万能的[清华源](https://mirrors.tuna.tsinghua.edu.cn/)有Manjaro/Arch的iso，下载比较快。[Arch镜像官方下载](https://archlinux.org/download/)。[Etcher](https://www.balena.io/etcher/)非常适合做任何Linux Distro的iso，用起来很简单，一般都是一次成功。如果手上已经有一个之前的镜像也尽量做一个新的，之前遇到过使用一个月之前的镜像进行安装出现一些小问题，新的镜像可以避免麻烦。

# 开始安装

### 联网
如果有网线直接插上应该是最简单的方法，不需要进行额外操作。连接wifi可以用iwctl。
```shell
ip link set wlan0 up/down # 先打开硬件
iwctl # 进入iwctl
device list # 列出所有网络设备，一般会有一个lo是环回的，需要用的设备大概叫wlan0
station wlan0 scan
station wlan0 get-networks
station wlan0 connect [wifi name]
ping google.com
```


## Arch
Arch的基本安装步骤非常简单，跟着[官方教程](https://wiki.archlinux.org/title/installation_guide)做就可以。下面列出一些写的比较通俗易懂的。

[Arch安装教程](https://itsfoss.com/install-arch-linux/)(不包含swap)

[带swap的Arch](https://frontpagelinux.com/tutorials/how-to-install-arch-linux-installation-guide/)

[iwctl连接wifi](https://wiki.archlinux.org/title/Iwd)

### 格盘

### 桌面
xfce4桌面
```shell
pacman -S xorg
pacman -S xfce4 xfce4-goodies lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
systemctl enable lightdm
systemctl start lightdm
```
## Manjaro
[Manjaro安装教程]()

Manjaro选驱动的时候推荐版权的驱动，曾经有两次选免费的驱动开机之后黑屏。

安装过程中主要在格盘和装软件上有过问题。
- 磁盘格式推荐ext4
- 如果软件依赖有冲突避免安装前换源

# 网络
网络设置可能需要自己安装，参考[教程](https://linuxhint.com/arch_linux_network_manager/)


# 换源
pacman的下载源列表在 /etc/pacman.d/mirrorlist，可以手动添加特定的源。reflector可以自动对源进行测速，选择最快的。
```shell
reflector --verbose -l 200 --sort rate --save /etc/pacman.d/mirrorlist
```

# 中文输入法
```shell
sudo pacman -Rs $(pacman -Qsq fcitx) # 删除已有fcitx
sudo pacman -S fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool fcitx5-chinese-addons
```
修改 `~/.config/fcitx5/profile`
```shell
[Groups/0]
# Group Name
Name=Default
# Layout
Default Layout=us
# Default Input Method
DefaultIM=pinyin

[Groups/0/Items/0]
# Name
Name=keyboard-us
# Layout
Layout=

[Groups/0/Items/1]
# Name
Name=pinyin
# Layout
Layout=

[GroupOrder]
0=Default
```
修改 `~/.pam_environment`
```shell
GTK_IM_MODULE=fcitx5
QT_IM_MODULE=fcitx5
XMODIFIERS="@im=fcitx5"
```
启动fcitx


[参考博客](https://jeffreytse.net/computer/2020/11/19/how-to-use-fcitx5-elegantly-on-arch-linux.html)
# 时间
```shell
timedatectl status
timedatectl list-timezones
timedatectl set-timezone Asia/Shanghai
```

# zsh
```shell
sudo pacman -S zsh # 安装zsh
zsh --version # 验证安装
chsh -s $(which zsh) # 该默认shell
# 退出重新登录或者直接重启
echo $SHELL # 输出应该带zsh

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # oh my zsh
```

# vi
vi的键位比较奇特，上手难度比较高，一般vim对新手比较友好。
```shell
sudo pacman -S vim
```
之后可以在需要编辑东西的时候打vim或者直接在 /usr/bin 里把vi删了，用vim替代。
```shell
cd /usr/bin
sudo rm vi
sudo ln -s vim vi
```

# yay
yay是一个十分好用的包管理工具。他一些具体的安装过程会调用pacman，命令行参数也基本一样，主要是多了AUR的支持。AUR里基本能找到所有常用的软件。
```shell
sudo pacman -Syyu # 全系统更新
sudo pacman -S git
git clone https://aur.archlinux.org/yay.git # 下载yay代码
cd yay
makepkg -si # 编译并安装
yay # 更新所有的包，测试安装

yay package_name # 如果是pacman是需要准确的包名，但是直接yay第一步是搜索，所以不需要准确
yay -S pkg_name # 和pacman一样是直接安装这个包
yay -R pkg_name # 删除一个包

vi /etc/makepkg.conf # PKGEXT 把后面的 .xz 去掉，这样本地编译的包不需要压缩直接安装，快很多
```
如果安装的过程中报一些找不到或者缺少fakeroot，build utils之类的binary，是因为缺少一些依赖，装上就好使。
```shell
sudo pacman -S base-devel
```

# 显卡相关
做深度学习和游戏开发都用到显卡，驱动也是给我折腾的死去活来。首先和驱动无关的一个软件，inxi 是查看硬件信息的，我的笔记本是一个集显一个独显(再买一定不买带集显的…..)
```shell
inxi -G
inxi -MCmdAGn
```
因为我之前已经折腾过很多次驱动，所以环境并不干净。清理环境的做法是暴力的在 添加删除软件 里面卸掉了所有名字带 nvidia optimus bumblebee 的软件，之后重启。因为有软件依赖这些东西所以一起被卸掉了，小心不要误删。

在 Manjaro 动驱动最推荐的方式是 mhwd

mhwd # 显示所有可以安装的驱动版本
sudo mhwd -i pci video-hybrid-intel-nvidia-440xx-prime # 到20年4月这个是最新的驱动
跑深度学习都需要cuda环境，之前centos+tensorflow的时候显卡是给我折腾的死去活来。这次也有点小问题但是找到了 optimus-manager ，感觉比单用bumblebee 好用。我也不是很在乎一个session的开着独显费电，一行代码搞定才省头发不是。介绍的原文在这
```shell
optimus-manager --switch nvidia  --no-confirm
optimus-manager --switch intel  --no-confirm
optimus-manager --status # 查看当前使用的显卡
```
在装cuda的时候遇到一个问题，提示 /tmp 分区的空间不够了。cuda编译过程中需要的暂存目录空间比较大。查网上的资料，cuda是可以指定这个 tempdir 的，但是编辑 buildfile 因为版本不同好像参数格式也不一样。于是尝试对 /tmp 目录做手脚。可以给 tmp 目录更大的空间，但是我这尝试了 umount 占用。于是直接简单粗暴发挥两块固态的优势，把平时存数据的固态mount 到 /tmp 上。

fdisk -l  # 先要知道要mount的盘叫什么
mount /dev/urdiskname /tmp # 注意替换盘的名称

# 亮度调节
装完显卡驱动之后终于能在本机上跑深度学习了，但是坑爹的是新的驱动下屏幕亮度调节坏了，又不想重装显卡驱动，因此通过命令行调节屏幕亮度。首先查看屏幕亮度的最大值
```shell
cat  /sys/class/backlight/intel_backlight/max_brightness
# 我这是7500
# 之后写入一个你觉得可以的值，范围是1到上面显示的最大值。注意这里可能需要却换到root执行，sudo在我这不好使
echo 800 >> /sys/class/backlight/intel_backlight/brightness
```
闪瞎双眼的亮度终于降下来了。。。

# 安装deb包
很多软件发布的时候都只提供deb和rpm这种主流distro的安装包，debtap可以作出arch的安装包之后就可以直接安装deb包了。大多数情况下是好使的
```shell
# 安装debtap
yay -S debtap

# 换源
sudo vi /usr/bin/debtap

替换：http://ftp.debian.org/debian/dists
https://mirrors.tuna.tsinghua.edu.cn/debian/dists

替换：http://archive.ubuntu.com/ubuntu/dists
https://mirrors.tuna.tsinghua.edu.cn/ubuntu/dists/

# 第一次用一般需要更新
sudo debtap -u

# 这一步会将deb的包转换成pacman的包
sudo debtap  xxxx.deb

# 利用pacman安装
sudo pacman -U x.tar.xz
```

# 磁盘挂载
https://www.cnblogs.com/along21/p/7410619.html
function md() {
        sudo mount /dev/nvme1n1p1 /data/
}

# 声音
发现电脑外放音量正常，但是插耳机或者连蓝牙都没声。肯定是驱动或者设置的问题，网上找到一个方案

echo "options snd-hda-intel model=auto" >> /etc/modprobe.d/alsa-base.conf
之后重启，插线应该就好使了。如果连接蓝牙之后还是在外放声音，打开Volume Control，里面的output device看看是不是设成 Headphone(Unplugged)，可能只是电脑没有把声音交给蓝牙耳机。

可能有时候看的视频声音特别小，这个插件可以让音量超过100%，慎用可能损坏硬件，但是如果你确定音量全程都很小问题不大
```shell
yay xfce4-pulseaudio-plugin
```

# 数学
mathpix可以截屏识别数学公式，打印的基本都没问题，手写的公整也可以。

```shell
yay mathpix
```
mathpix是需要截屏的，如果是想直接用鼠标写然后识别可以用myscript网页版

画函数图像可以用desmos

不同设备之间发送文字可以用 clipboard.ninja

# Conda


# 软件
freedownload manager下载很方便

# 虚拟机
```shell
sudo pacman -Syy
sudo pacman -S archlinux-keyring
sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat
sudo pacman -S ebtables iptables
sudo pacman -S libguestfs
sudo systemctl start libvirtd.service
```
