alias lsa="ls -a"
## alias cdc="cd ~/Dropbox/Lexi-Stefan/Countryman\ Tutoring/"
alias lst="ls -t | less"
alias lsta="ls -at | less"
## alias leximac="ssh alexisnelson@192.168.0.13"
alias editKeys="emacs ~/Dropbox/.environment/karabiner/Private.xml"
alias getimg="~/Pictures/.getimg/getimg"
alias sshpaywst="ssh -R 52698:localhost:52698 stecou8@173.236.227.218"
alias sftppaywst="sftp stecou8@173.236.227.218"
alias shellcharlie55="ssh -i ~/.charlie55.pem ec2-user@54.88.35.152"
alias destroyAdobeReader="sudo rm -dr /Library/Internet Plug-Ins/AdobePDF*; KILLALL Safari; Open /Applications/Safari.app"
alias renameEverythingWithLowercaseAndHyphens="~/rename.sh"

##
# Your previous /Users/Stefan/.bash_profile file was backed up as /Users/Stefan/.bash_profile.macports-saved_2014-04-29_at_20:33:54
##

# MacPorts Installer addition on 2014-04-29_at_20:33:54: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

export PATH=$PATH:~/bin
export EDITOR=emacs
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_71.jdk/Contents/Home/
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

# added by travis gem
[ -f /Users/Stefan/.travis/travis.sh ] && source /Users/Stefan/.travis/travis.sh
