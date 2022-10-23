#!/bin/sh

# fix Docker by adding the current user to the docker group
sudo gpasswd -a $USER docker

mkdir -p /data/.ssh
mkdir -p ~/.config/pgcli
mkdir -p ~/.config/systemd/user
mkdir -p ~/.vim/backup
mkdir -p ~/.vim/swap
mkdir -p ~/.vim/undodir
mkdir -p ~/.vim/vim-plug
mkdir -p ~/bin

ln -sf /data/.armory -t ~
ln -sf /data/.bitcoin -t ~
ln -sf /data/.gnupg -t ~
ln -sf /data/.password-store -t ~
ln -sf /data/.ssh -t ~
ln -sf /data/book -t ~
ln -sf /data/document -t ~
ln -sf /data/download -t ~
ln -sf /data/irclogs -t ~
ln -sf /data/junk -t ~
ln -sf /data/movie -t ~
ln -sf /data/music -t ~
ln -sf /data/picture -t ~
ln -sf /data/proj -t ~
ln -sf /data/resources -t ~
ln -sf /data/video -t ~

stow --target ~ asdf
stow --target ~ git
stow --target ~ irc
stow --target ~ mbsync
stow --target ~ shell
stow --target ~ wm
stow --target ~/.config alacritty
stow --target ~/.config desktop
stow --target ~/.config dunst
stow --target ~/.config fontconfig
stow --target ~/.config greenclip
stow --target ~/.config i3
stow --target ~/.config mpd
stow --target ~/.config neomutt
stow --target ~/.config nvim
stow --target ~/.config polybar
stow --target ~/.config powerline
stow --target ~/.config ranger
stow --target ~/.config rofi
stow --target ~/.config/pgcli pgcli
stow --target ~/.config/systemd/user/ units
stow --target ~/.ssh ssh
stow --target ~/bin script
