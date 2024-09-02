# Installing Arch

Boot from a Live CD and find the disk that you're installing Arch on. In my case it's `/dev/sda`.

Begin making the partition table with parted and then format the partitions:

```bash
sudo parted /dev/sda
(parted) mklabel gpt
(parted) mkpart primary 0% 2M
(parted) set 1 bios_grub on
(parted) mkpart primary btrfs 512M 100%
(parted) quit
sudo mkfs.vfat -F32 /dev/sda1
sudo cryptsetup -y luksFormat /dev/sda2
sudo cryptsetup luksOpen /dev/sda2 cryptroot
sudo mkfs.btrfs -f /dev/mapper/cryptroot
sudo btrfs fi label /dev/mapper/cryptroot DATA
```

```bash
sudo mount /dev/mapper/cryptroot /mnt
sudo mkdir /mnt/boot
sudo mount /dev/sda1 /mnt/boot
sudo pacstrap /mnt base base-devel neovim
sudo genfstab -U -p /mnt >> /mnt/etc/fstab
sudo arch-chroot /mnt
```

Open this file and uncomment `en_US.UTF-8 UTF-8`, or whatever locale you want to use.

```bash
nvim /etc/locale.gen
```

Then run:

```bash
locale-gen
```

Set the default language on boot and apply it for your current session too:

```bash
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
```

Link the preferred time zone to `/etc/localtime`:

```bash
ln -s /usr/share/zoneinfo/Zone/SubZone /etc/localtime
hwclock --systohc --utc
echo nice-system > /etc/hostname
pacman -S dhcpcd
systemctl enable dhcpcd
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
nvim /boot/loader/entries/arch.conf
```

```
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options rd.luks.name=59b76ec8-f0fd-4e01-9013-4b3a9da6e00f=cryptroot root=/dev/mapper/cryptroot rw elevator=deadline quiet splash nmi_watchdog=0
```


```bash
echo "default arch" > /boot/loader/loader.conf
```
