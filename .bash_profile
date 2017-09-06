source ~/.bash_local.sh

if [ -f ~/Dropbox/.environment/bash/.bashrc ]; then
	source ~/Dropbox/.environment/bash/.bashrc
elif [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# MacPorts Installer addition on 2016-12-21_at_19:13:29: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


# added by Anaconda2 4.4.0 installer
# modified to put the Anaconda2 path at the end of PATH by default
export PATH="$PATH:/Users/Stefan/anaconda2/bin"

# pick the python path to use with this function
pypick () {
    newpath="$(python -c '
import os, sys

pathchoices = {
    "port": "/opt/local/bin",
    "conda": "/Users/Stefan/anaconda2/bin",
    "sys": "/usr/bin"
}

try:
    chosenpath = pathchoices[sys.argv[1]]
except KeyError:
    sys.stderr.write("BAD INPUT: Must pick from following keys:\n")
    sys.stderr.write("\n".join(pathchoices.keys()))
    exit(1)

# remove duplicate paths
path = os.environ["PATH"].split(":")
newpath = list()
for i in range(len(path)):
    if not path[i] in path[:i]:
        newpath.append(path[i])

# move chosen path to front
newpath.remove(chosenpath)
newpath.insert(0, chosenpath)
print ":".join(newpath)
    ' "$1")" && export PATH="$newpath"
}
