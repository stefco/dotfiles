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

# location of current script
export DOTFILEBASHRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DOTFILEBASHRC="${DOTFILEBASHRCDIR}"/"$(basename "${BASH_SOURCE[0]}")"

# we want to keep track of where each bash function is defined using an
# associative array
declare -A _funcsources

recordfuncsource () {
    # see which functions have been declared since the last time this function
    # was called and manually mark $1 as their source file in _funcsources
    # if no arg is provided, indicate that no source is registered
    [ $# -eq 0 ] && set -- "NO_SOURCE_FILE_REGISTERED"
    if [ $# -eq 1 ]; then
        # if no funcs manually provided, just register funcs that have appeared
        # since this function was last called
        for func in $(declare -F | sed 's/^.* .* //' | sort); do
            if ! test "${_funcsources["${func}"]+isset}"; then
                _funcsources["${func}"]="$1"
            fi
        done
    else
        # args following $1 are funcnames whose sources are manually specified
        for func in "${@:2}"; do
            _funcsources["${func}"]="$1"
        done
    fi
}

dotsource () {
    # function for sourcing bash code from dotfile directory
    for arg in "$@"; do
        source "${DOTFILEBASHSRC}"/"$arg"
        recordfuncsource "${DOTFILEBASHSRC}"/"$arg"
    done
}

recordfuncsource
recordfuncsource "${DOTFILEBASHRC}" dotsource recordfuncsource

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
dotsource instagram_tools b32pass

# load UWM-specific initialization scripts if on UWM
hostname="$(hostname -f)"
for i in {1..3}; do
    if [ "${hostname}"z = pcdev${i}.nemo.uwm.eduz ]; then
        dotsource uwm
    fi
done
