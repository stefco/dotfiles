########################################################################
# ENV VARIABLES AND PREFS
########################################################################

# keep track of history for longer, please
export HISTFILESIZE=100000
export HISTSIZE=100000

# configuration file home
export XDG_CONFIG_HOME=~/".config"
export XDG_DATA_HOME=~/".local/share"
export XDG_CACHE_HOME=~/".cache"

# force ipython to look in ~/.config
export IPYTHONDIR="~/.config/ipython"

# add colors, set `vim` as default editor
export EDITOR=vim
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

# tell GPG which TTY to use
export GPG_TTY=$(tty)

# vi mode
set -o vi

# fix italics for tmux
export TERM=screen-256color

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
declare -A _func_sources
declare -A _alias_sources

record_func_source () {
    # See which functions have been declared since the last time this function
    # was called and manually mark $1 as their source file in _func_sources.
    # If no arg is provided, indicate that no source is registered.
    [ $# -eq 0 ] && set -- "NO_SOURCE_FILE_REGISTERED"
    if [ $# -eq 1 ]; then
        # if no funcs manually provided, just register funcs that have appeared
        # since this function was last called
        for func in $(declare -F | sed 's/^.* .* //' | sort); do
            if ! test "${_func_sources["${func}"]+isset}"; then
                _func_sources["${func}"]="$1"
            fi
        done
    else
        # args following $1 are funcnames whose sources are manually specified
        for func in "${@:2}"; do
            _func_sources["${func}"]="$1"
        done
    fi
}

record_alias_source () {
    # See which aliases have been declared since the last time this function
    # was called and manually mark $1 as their source file in _alias_sources.
    # If no arg is provided, indicate that no source is registered.
    [ $# -eq 0 ] && set -- "NO_SOURCE_FILE_REGISTERED"
    if [ $# -eq 1 ]; then
        # if no aliases manually provided, just register aliases that have
        # appeared since this function was last called
        for alias in $(alias | sed 's/^alias \([^=]*\)=.*$/\1/'); do
            if ! test "${_alias_sources["${alias}"]+isset}"; then
                _alias_sources["${alias}"]="$1"
            fi
        done
    else
        # args following $1 are funcnames whose sources are manually specified
        for alias in "${@:2}"; do
            _alias_sources["${alias}"]="$1"
        done
    fi
}

dotsource () {
    # function for sourcing bash code from dotfile directory
    for arg in "$@"; do
        local script="${DOTFILEBASHSRC}"/"${arg}"
        # echo "Timing ${script}"
        source "${script}"
        record_func_source "${script}"
        record_alias_source "${script}"
    done
}

dotlist () {
    # list bash code in bashfuncs dotfile directory
    ls ~/dev/dotfiles/bashfuncs
}

record_func_source
record_alias_source
record_func_source "${DOTFILEBASHRC}" dotsource record_func_source

########################################################################
# SOURCE CONFIGURATION GRANULARLY
########################################################################

# MacOS-specific crap
if [[ $OSTYPE == darwin* ]]; then
    dotsource macos
    # load MacOS-specific functions
    dotsource emacsg opent
elif [[ $OSTYPE = linux* ]]; then
    dotsource linux
    if [[ -v WSL_DISTRO_NAME ]]; then
        dotsource wsl
    fi
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

# load navigation functions
dotsource navigate

# load my aliases
dotsource aliases

# load the command prompt
dotsource promptline

# load q console settings for kdb+
# dotsource qconfig

# define simple functions (their names are the same as the source files)
dotsource \
    path \
    cpln \
    vimex \
    # nohupw \
    # cp-last-screen \
    # imap \
    # colorgrid \
    # prepend_date \
    # instagram_tools \
    # tun \

# load UWM-specific initialization scripts if on UWM
hostname="$(hostname -f)"
for i in {1..3}; do
    if [ "${hostname}"z = pcdev${i}.nemo.uwm.eduz ]; then
        dotsource uwm
    fi
done
