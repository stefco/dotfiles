# load API tokens with ".active" suffix
if [ -e ~/.tokens ]; then
    for token in $(find ~/.tokens -name '*.active'); do
        source "${token}"
    done
fi

# keep track of history for longer, please
HISTFILESIZE=10000

# load iterm shell integration if available
if [ -e "${HOME}/.iterm2_shell_integration.bash" ] \
  && [ "$TERM" != 'eterm-color' ]; then
    source "${HOME}/.iterm2_shell_integration.bash"
fi

# add a function for pulling updates to directories in ~/dev
pull () {
    if [ "$#" -ne 1 ]; then
        echo 'illegal number of arguments. pass only a dir name.'
        return 1
    fi
    pushd "$1"
    if [ "$(parse_git_dirty)"z = z ]; then
        echo pulling "$1"...
        git pull
        popd
    else
        echo 'not clean. in dir now, `popd` to go back when done fixing.'
    fi
}
alias pulldot="pull ~/dev/dotfiles"
alias pulldata="pull ~/dev/geco_data"

# user-specific executables:
export PATH="~/dev/dotfiles/bin:~/bin:$PATH"
export PATH="$PATH:/Library/TeX/Distributions/Programs/texbin"

# GECo-specific executables:
export PATH="~/dev/geco_data:$PATH"

# configuration file home
export XDG_CONFIG_HOME="~/.config"

# force ipython to look in ~/.config
export IPYTHONDIR="~/.config/ipython"

# get a better PATH (only if `pathsorter` executable exists for this purpose)
type -f 1>/dev/null 2>&1 pathsorter \
    && export PATH="$(pathsorter port sys conda)"

# add colors, set `vim` as default editor
export EDITOR=vim
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

## vi mode
set -o vi

# some ipython profile aliases
alias ipy='ipython'
alias imath='ipython --profile=math'
alias iastro='ipython --profile=astro'
alias igrace='ipython --profile=grace'
alias igwpy='ipython --profile=gwpy'
alias igwhen='ipython --profile=gwhen'
alias iheavy='ipython --profile=heavy'

# add color to some utilities
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# two-sided print
alias lpdub="lp -o sides=two-sided-long-edge"

# vim aliases prevent XQuartz from opening
alias view='DISPLAY="" view'
alias vi='DISPLAY="" vi'
alias vim='DISPLAY="" vim'
alias vimdiff='DISPLAY="" vimdiff'
alias vimtutor='DISPLAY="" vimtutor'

# url encode and decode from stdin
alias urlencode="python -c 'import urllib, sys; print urllib.quote(sys.stdin.read())'"
alias urldecode="python -c 'import urllib, sys; print urllib.unquote(sys.stdin.read())'"
alias queryencode="python -c 'import urllib, sys; print urllib.quote_plus(sys.stdin.read())'"

# workaround; vim saves files in a way that pisses off crontab
alias crontab="VIM_CRONTAB=true crontab"

# pick the PATH to use with this function and/or configure a virtual env
path () {
    newpath="$(pathsorter "$@")" && export PATH="$newpath"
    # kill existing virtualenv
    if [[ "$CONDA_DEFAULT_ENV" != "" ]]; then
        source deactivate
    fi
    # if the path choice requires a virtualenv, activate that
    for pick in "$@"; do
        case "$pick" in
            intel) source activate idp ;;
        esac
    done
    printf 'Path is now:\n  '
    sed $'s/:/\\\n  /g' <<<"$PATH"
}

# command prompt, modified from http://ezprompt.net/
function nonzero_return() {
	RETVAL=$?
	[ $RETVAL -ne 0 ] && echo " $RETVAL"
}
# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo " [${BRANCH}${STAT}] "
	else
		echo ""
	fi
}
# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}
# get the last exit status; if nonzero, print it out
function print_bad_exit_status {
    exitcode="$?"
    if [[ $exitcode != 0 ]]; then
        printf '%s' ' WhOopS! ¯\_(ツ)_/¯ '$exitcode' '
    fi
}

# functions for navigating forward and backward
NAVIGATION_FWD=()
NAVIGATION_BWD=()

navigate_forward () {
    if [ ${#NAVIGATION_FWD[@]} -gt 0 ]; then
        NAVIGATION_BWD+=("$(pwd)")
        "cd" "${NAVIGATION_FWD[${#NAVIGATION_FWD[@]}-1]}"
        unset NAVIGATION_FWD[${#NAVIGATION_FWD[@]}-1]
    fi
}

navigate_backward () {
    if [ ${#NAVIGATION_BWD[@]} -gt 0 ]; then
        NAVIGATION_FWD+=("$(pwd)")
        "cd" "${NAVIGATION_BWD[${#NAVIGATION_BWD[@]}-1]}"
        unset NAVIGATION_BWD[${#NAVIGATION_BWD[@]}-1]
    fi
}

# 'navigate' directory, i.e. change directory but keep nav history
nd () {
    NAVIGATION_BWD+=("$(pwd)")
    NAVIGATION_FWD=()
    "cd" "$@"
}

# use nd as default directory changer
alias cd=nd

# set the actual command prompt variable based on the host
if [[ $OSTYPE == darwin* ]]; then
    if [ $(hostname) == 'Alexis-Nelsons-MacBook-Pro.local' ]; then
        export SHORT_HOST_NAME=mbp
    elif [ $(hostname) == 'Stefans-iMac.local' ]; then
        export SHORT_HOST_NAME=imac
    fi
    export PS1="\[\e[37;45m\]\`print_bad_exit_status\`\[\e[m\]\[\e[37;43m\] $SHORT_HOST_NAME \[\e[m\]\[\e[44m\] \${#NAVIGATION_BWD[@]} \[\e[m\]\[\e[37;41m\] \w \[\e[m\]\[\e[44m\] \${#NAVIGATION_FWD[@]} \[\e[m\]\[\e[37;42m\]\`parse_git_branch\`\[\e[m\]\[\e[30;47m\]\`nonzero_return\`\[\e[m\]\[\e[30;47m\] > \[\e[m\] "
fi

# ls, but with dem emoji
l () {
    ls --color=always -FC | sed '
        s_\([^\t ]*\)/_\1🗂_g;
        s_\([^\t ]*\)|_\1🏹_g;
        s_\([^\t ]*\)@_\1🔗_g;
        s_\([^\t ]*\)=_\1🔌_g;
        s_\([^\t ]*\)\*_\1☠️_g;
    '
}

# some MacOS-specific crap
if [[ $OSTYPE == darwin* ]]; then
    # donkey, get back in the heap!
    alias donkey="cat ~/dev/dotfiles/static/ogre.txt; say donkey get back in the heap;"

    # control whether hidden files show on MacOS
	alias hidehidden="defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder"
	alias showhidden="defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder"

    # Get globus running
    export GLOBUS_LOCATION=/opt/ldg
    if [ -f ${GLOBUS_LOCATION}/etc/globus-user-env.sh ] ; then
        . ${GLOBUS_LOCATION}/etc/globus-user-env.sh
    fi

    # Make "Save As..." the default for GUI apps, as it should be, rather than
    # this "duplicate" or whatever bullshit that they introduced recently
    defaults write -globalDomain NSUserKeyEquivalents -dict-add 'Save As...' '@$S'

    # turn on bash-completion
    if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
        . /opt/local/etc/profile.d/bash_completion.sh
    fi

    # a cryptic greeting from an old friend, if he is around...
    type -f 1>/dev/null 2>&1 fortune \
        && type -f 1>/dev/null 2>&1 cowsay \
        && [ -s ~/dev/dotfiles/static/shrek.cow ] \
        && fortune | cowsay -f ~/dev/dotfiles/static/shrek.cow \
        || echo "no fortune for you today..."
fi
