install:
	ln -sf /data/.{armory,bitcoin,gnupg,password-store,smartgit,ssh} -t ~
	ln -sf /data/{books,irclogs,resources} -t ~
	ln -sf /data/{document,download,junk,movie,music,picture,video} -t ~
	stow --target ~ git
	stow --target ~ i3
	stow --target ~ irc
	stow --target ~ shell
	stow --target ~/.atom atom
	stow --target ~/.config clipit
	stow --target ~/.config desktop
	stow --target ~/.config powerline
	stow --target ~/.config terminator
	stow --target ~/.config rofi
	stow --target ~/.config/systemd/user/ units
	#stow --target ~/.lein lein
	stow --target ~/.ssh ssh
