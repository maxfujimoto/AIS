#!/bin/sh

#
# MF Artix Install Script
#

# Check for sudo privleges
sudo -n true
test $? -eq 0 || exit 1 "Sudo privleges are required to run this script."


# Error Messages
set -eu -o pipefail


BASESTRAP_APPS="base base-devel linux-firmware emacs vim man-db dash git github-cli grub efibootmgr gnupg artix-archlinux-support"

LINUX="linux"
LTS="linux-lts"

DUALBOOT_APPS="os-prober"

RUNIT_APPS="runit elogind-runit networkmanager-runit"
OPENRC_APPS="openrc elogind-openrc networkmanager-openrc"

NETWORK_APPS="networkmanager dhcpcd wpa_supplicant nmconnection-editor"

XORG_APPS="xorg-server xorg-init xorg-xset xorg-xrandr"

POST_CHROOT_APPS="bat ripgrep grep stow fzf"



# Checks if first arguemnt dir exist, if no clones second arguemnt URLs git repo into $1.
check_git () 
{
	if [ ! -d "$1" ] ; then
		git clone $2 $1
	fi
}

echo "Making Direcotries"

mkdir -p ~/Documents
mkdir -p ~/Downlaods/AUR
mkdir -p ~/Pictures
mkdir -p .config
mkdir -p .Trash

echo "Directories Complete"


echo "Enabling Arch Support"

cp ./pacman.conf /etc/pacman.conf

echo "Orthotics Complete"


echo "Updating System"

# Pacman Update & Upgrade
pacman -Syyu

echo "System Updte Complete"


echo "Instaling Post-Instalation Packages"

pacman -S $POST_CHROOT_APPS

echo "Post-Instalation Packages Complete"



echo "Installing .dotfiles"

check_git $HOME/.dotfiles https://github.com/maxfujimoto/.dotfiles

stow -t $HOME -d $HOME/.dotfiles .

source $HOME/.bashrc
xrdb $HOME/.Xresources

echo ".dotfiles Installed"
