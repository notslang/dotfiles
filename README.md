# dotfiles

In the UNIX world, programs are configured in a couple different ways:

- shell arguments that are passed when you start a program
- shell scripts containing both commands and their args (like `.bashrc`)
- application-specific text configuration files (like INI, JSON, or YAML files)

Programs with many options (like window managers or text editors) are configured on a per-user basis with files in your home directory (`~`). In a UNIX-like OS, any file or directory with a name that starts with a period (`.`) is considered hidden, and in a default view will not be displayed. Thus the name "dotfiles".

It's been said of every console user:

> you are your dotfiles.

Since they dictate how your system will look and function, these files are very important, and need to be backed up, versioned, and shared. Git is quite good at all 3 of these things. However, keeping a git repo in the root of your home directory is a bad idea because everything below your home directory is considered a part of that repo. The solution is to use [GNU Stow](http://www.gnu.org/software/stow/), a free, portable, lightweight symlink farm manager. This allows you to keep a git repo of all your config files that are symlinked into place via a single command. This makes sharing these files among multiple systems super simple. and does not clutter your home directory with version control files.

# installing

Stow is available for all GNU/Linux distros and most UNIX-like OSes via your package manager.

- `sudo pacman -S stow`
- `sudo apt-get install stow`
- `brew install stow`

Or you can clone it [from source](https://savannah.gnu.org/git/?group=stow) and [build it](http://git.savannah.gnu.org/cgit/stow.git/tree/INSTALL) yourself.

# how it works

By default, the stow command will create symlinks for files in the parent directory of where you execute the command. This dotfiles setup makes no assumptions about where the repo is located, and runs all the stow commands with `Makefile`.

To install the configs, clone this repo to the location of your choice, `cd` into the repo directory, and run `make install`. This will run a series of stow commands to symlink all the config files in this repo to where they belong in your home directory.

If you don't want to install a particular set of config files, remove the corresponding line in `Makefile` and that directory will be omitted. For example, if you don't use [Atom](https://atom.io) you would remove the line `stow --target ~/.atom atom`.

Note: Stow can only create a symlink if a config file does not already exist. If a default file was created upon program installation you must delete it first before you can install a new one with stow. This does not apply to directories, only files.
