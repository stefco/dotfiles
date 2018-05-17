########################################################################
# ENV VARIABLES AND PREFS
########################################################################

# keep track of history for longer, please
export HISTFILESIZE=10000
export HISTSIZE=10000

# configuration file home
export XDG_CONFIG_HOME=~/".config"

# force ipython to look in ~/.config
export IPYTHONDIR="~/.config/ipython"

# add colors, set `vim` as default editor
export EDITOR=vim
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

## vi mode
set -o vi

########################################################################
# DOTFILE DIR CONFIG
########################################################################

# dotfile directory
export DOTFILEDIR=~/dev/dotfiles

# bash source files directory
export DOTFILEBASHSRC="${DOTFILEDIR}/bashfuncs"

# function for sourcing bash code from dotfile directory
dotsource () {
    pushd "${DOTFILEBASHSRC}" >/dev/null
    while [ $# -gt 0 ]; do
        source "$1"
        shift
    done
    popd >/dev/null
}

########################################################################
# SOURCE CONFIGURATION GRANULARLY
########################################################################

# MacOS-specific crap
if [[ $OSTYPE == darwin* ]]; then
    dotsource macos
    # load MacOS-specific functions
    dotsource emacsg opent
fi

#check if this is an ssh session
dotsource sessiontype

# load any existing API tokens
dotsource tokens

# load colors for pretty printing
dotsource colors

# load iterm shell integration if available
dotsource iterm

# initialize the PATH variable
dotsource pathinit

# load my aliases
dotsource aliases

# load navigation functions and use `nd` instead of `cd`
dotsource navigate
alias cd=nd

# load the command prompt
dotsource promptline

# load q console settings for kdb+
dotsource qconfig

# define simple functions (their names are the same as the source files)
dotsource l nohupw path cpln vimex cp-last-screen imap colorgrid prepend_date

# load UWM-specific initialization scripts if on UWM
hostname="$(hostname -f)"
for i in {1..3}; do
    if [ "${hostname}"z = pcdev${i}.nemo.uwm.eduz ]; then
        dotsource uwm
    fi
done
