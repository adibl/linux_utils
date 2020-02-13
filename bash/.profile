# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi



# my changes -------------------------------------------
export NAVI_PATH="/home/adi/Documents/cheetsheet" # make navi my cheet sheet    s only
export PATH="$PATH:/home/adi/resources/bash/scripts"

# open bag: alias dont work in vim cmd
alias rpy="runPython.sh"


# change defult text editor to vim
export EDITOR='vim'
export VISUAL='vim'


# start tmux on system startup
tmux start-server

export PYTHONPATH=$HOME/PycharmProjects/algoritems/py_algoritems/:
# end of my changes --------------------------------

# Created by `userpath` on 2020-01-02 12:04:04
export PATH="$PATH:/home/adi/.local/bin"

