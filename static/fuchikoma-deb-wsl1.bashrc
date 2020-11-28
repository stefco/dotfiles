# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Colors
_ESC_SEQ="\x1b["
_COL_RESET=$_ESC_SEQ"39;49;00m"
_COL_RED=$_ESC_SEQ"31;01m"
_COL_GREEN=$_ESC_SEQ"32;01m"
_COL_YELLOW=$_ESC_SEQ"33;01m"
_COL_BLUE=$_ESC_SEQ"34;01m"
_COL_MAGENTA=$_ESC_SEQ"35;01m"
_COL_CYAN=$_ESC_SEQ"36;01m"

cat >/dev/null <<"EOF"
                                                                                
                                          -osooyyo+:`
FUCHIKOMA                            -:ohhNNMMMMMMMNs-
                                     /yNNNNMMNMMMMMMMNm-
                                 .--:yNdhdmNNMMMMNMMMMM/.
                        .-.   .-:/o/yNdoshdNNNNNNNNNNMMd-
                       -...-.-::/+/hN/sssydNNNNNNNNmmMNo-
                      ::--:/:/:/o:/dMNhyhdNNNNNNNNNmmh-//
                     :s/..o/::+s/..sNmydNNddhyysdhdNms-/s.-.  .
                    -sy:-.--//yo--/oyhddm++o:+/-+/yMmysoo-//--.
                    +yh:./++/sy::ssyhdmmNh-:./+--:mMdhdysooo:-.
                    oyyysysyshy-hhhhyydmNmhy-.--+dNMmmmhyso//:o/.
                    :oy+oyyyyd++dyhs+:/smyhdNdydmmmNmNsysooydmNho/.
                    `:/+/oshyhyh+/---.-/syshdMNmhmmysms+/:.sMMNmyo+-
                     `..```+yhmysos:--/s+hyhymdmMMNNdmdhy:-.smMMmdyy/
                      ..-+shmmmmhhhs/+hy+/dhhosNMMMMMmddmdhho-ohmmhhh-.
                     -odNMMMMMMdddhyooshydNmMNdMNmmhhsoo+-oyo```/ydhhy+`.
                   :ymNNNNNNMMMNys+/++/oyMMMNNNNydMMMNmds/-.`````.ddhdysos--
                ./ymNNNNNNNMMMMm++--``..-yNNddmNNMMMMMMMMMNdo:.```hyyddoyy:-/
               .ydsmNNNNNNMMMMMMo::/::-..+MMMMMMMMMMMMMMMMMMMNdo-`:soo+oo/--.
                ymdmNNMMMMMMMMMMddNNNh+ds+hdNMMMMMMMMMMMMMNNmhyNdhs+.-.  ``-.
              .+mmNNNMMMNNyo/:::/NMMNNmym/ `-+yddmmmNNMMMMMNNNmNhhmNs``
             /dNNmNMMMNho/.```..:hdMMNNhyho/.`  ``..-:/smMMMMMMMNNNN-
           .omNdodNMMM+...-..-----:mNNNmdhhhyo/---.````:yMMMNMMNNNmy
           sNNM/+mMMMy...----------oNNmhhyyhhddmy/yho/+hmNNNNNmy:/-
          :NNMydMMMMy.....--------::/shhyhhddNdmhsyNNmdhhhhmmdmdh+-
         .sNMMNMMMm+........-------:---oyhsdmmyydNhdssdddsyhNmNNNyhh
         /NMMMNNNs-...........``..-----:/+:+Nms//msd+:+/myssshmhhdmh-
        :dNMNddys-........``     `..------.+hyo:/mNddso+-```..::::-`
       :hmmddyy+............`      ``....``hsys+hd+.-
      :+NNmmdy/..........``               `hhyhNN/
    :/yhNNmmy:...........`                .ddddNh
    :shmhmmd+`.............``             `hmdhs-
  .:hdmNNdyy/ ``............. 
-:omNMNMMNh/`   ```........-.`
:ooyNsohmds        `....-----`
/shhhmmdds`      `...-----:-.
.:oysso/`       `.....-----.

EOF

# Motoko GITS:SAC
cat >/dev/null <<"EOF"
                                       ....--::--`                              
                                   `-/ossysyyyyyyys+-                           
                                  /ymmsssoosssyyyyyyyo                          
                                  shmmhyysssooosssyyyy/                         
                                 `yhNdhsshyyyyyyssssoos:                        
                                -/hmmdy/+hyhh+shyyyyyyy+                        
                              `/dsdNNmsoy++ysssohdyyyyy:                        
                            `--:odmdmNo-:-.+-/o-/hhyyys                         
                          `os+:/+dyoNNo.:..-....+yyyyyo                         
                           hmmsyhmhymmd:-:-...-:soshho+                         
                          :dmmmmmmmh:hdh:-..-:/ssyhhs                           
                         `oddmmmmmdsohddho+++++hhhy..                           
                         yhhhdmmdddddddhh+////oshy+:-.`                         
                        /yhdddmmddhhdmh+/-----:sy+:..---.``                     
                       `:-:/ohmdhhhhdo+-----:::y+:-:---.--.-`                   
                      `--...+dddhhdd+-......-.-/..-::-.....`:`                  
                     `--....yddddmmh-........-.........--....:                  
                    `:......ddddddo/.-..-..--.----....-+/:..--                  
                    :....-.-mmddh:...---/-::-...-.---/+///../                   
                    :...:/-ommdy-`......:/-...`-...-/oo:-:.::                   
                   .-..-//+hmmds++//:--....---::--..ooo-...::                   
                   :...:++odmmddsoooooo:`.++++ooooo+yos....-y+.                 
                   ::-:+oydmmmddmhsooo/.``:+++oooosssdh....-hhyo.               
                   `.-+ydddhmddmdmh/:-.``...:/+ooooshmd-...-hdhhh/              
                      `-++..dddmdmm:.:..`.-...-/--/smmm/-..:dmddddo`            
                           `dddhdmmy--..`..--..-..oymmmo:../dmmhddds            
                           :hddhmmmd:..-....-..--:osmmmo/--+hmmhdddd`           
                           -ddhhmmmmy-..-......-/::+dmms+//+ymdhhddd/           
                            +mmdmmmh+/:--------::--:+shs+++ymdhhhddds           
                ````````...../dmmmmo-+/.--../::..+---:shhddmdhhhddmm+           
      .-...............-:.....-:soso:so///::++/--o////+dmmmmddhdmmd:            
     :..................:-......-:..-+s--:--::dy::....-/hmmmmmmmmmo             
    -:.......:--........-:.......:---+hs/::+syd/.......-/mmmmmmmddh/`           
   `:.`.......-:::-.-....:-......-+//+dhhyhhhds-........-smmmmmdddddy/..`       
   -...............-:++/-::---....::/+yhhyhhhd/-........:+dmmmmmmddddhddhs:     
   `--............../oyhysssssoo++//-:+hhhhhhs-.........-/smddddmmmdddhdddds:`  
     `-:::-..-://:/syyy/:osooosssss+///ydhhds---.........:+ddmdyhmmmdhdhhhhhho. 
        `-+/:////syyho-..-+oooooos++++++dmds--------.....-+hmmmhhddddso+/-`     
           /++/:::+o++/....+ooooo++++++++s-..``...-::---.:+sdddddo++s--:-.      
             -++/:::://+:...ss+--:/+/////-..``.......-::/++`   ``               
               `:++/:::/+++syhy/.:.``..:---::--........:+o+                     
                  `-/+//:oyhy+++yhyo:` /:-...--::-...../s/`                     
                      ./+//ss+oyyyyhdo:-.........-:-../o/                       
                         -yy+yyyyyhmdmh............/+oo:                        
                          -ydysyhdhyhm:............/yo-                         
                          `/hdmmysyyys............:o/.                          
                            `:+shoyyh-...........:o/                            
                               /yoyyy.........../o:    
EOF

# Motoko GITS:SAC high contrast
cat >/dev/null <<"EOF"
                                       ..-.-:::--.                              
                                   `:/osyyyyyyyyyyyo-                           
                                  /yNNssyoosyyyyyyyyyo                          
                                  sdNNdhhsssoooysyyyyh/                         
                                 `ydMNdssdhhhyyyyssssos/                        
                                ./dNMNh:+dhdd/ydhhhyyyyo                        
                              `/mymMMNy+y++hyssohmhhyyh:                        
                            `---ommmMM+.-``+.:+.:ddyyhs                         
                          `oy+-:/myoMMo`-```````+hyyhhs                         
                           dNNsyhNdyNNm-.-.````-ssydms+                         
                          :mNMNNNNNd/dmd-.``.-:syyddy                           
                         `smmNNNNNNssmmmdo++///hddh..                           
                         hdmmmNNNNNmmmmhd+:/::osdh/:-.`                         
                        /hdmmmNNmmmmmNd//..`.`-yh/-```...``                     
                       `-.-/+dNmmmdmm+/.`...---h/-.-..```.`.`                   
                      `-````+mmmddmN/`````````.:```--.````` -`                  
                     `-`````hmmmmNNd-```````````````````.````:                  
                    `-``````mmNmNmo/`.``.```.``...````.//.``.-                  
                    :````.`.NNmmh:```...:.-:.```.`..`:/:::``/                   
                    -```-:`oNNmh-  `````-:.``  .````:+o-.-`-:                   
                   ..``./:/dNNms++/:-.`` ``..-::-.``o+o.```-:                   
                   -```-/+omMNNmyooosoo- `//++ooooo+yos````.h+.                 
                   --.-/ohmNMNmNNdsooo/`  -+++o+ossyydh````.hdhs.               
                   `.-+hmNmdNmmNNMh/-.`  ` `-/+oooosdNm.```.dNdmd/              
                      `-o+-.mmmNmMN-`-`` `.```.:../sNNN/```-dNNNmms`            
                           `mmmmmMNy..`.  `-.``.``oyNMNo-``:mMNmmmNs            
                           :dmmmNNMm-``.` `````.`-osNNMo/../hMNmmmmm`           
                           -mmddNNMNy.``.``````.:--/mNNo/://yNmdmmmm/           
                            oNNmNNMd+/-.-....`-:-.`-+sds//+yNNdmmmmmy           
                 ```````...../mNNNNo`//`..``::-``/...-ydhdmNNddmmmNN+           
      ...``````````````.:`  ``.-ssso:so:::::/+/..o::::/dMNNNmmdNNNm/            
     -``````````````````-.``````.-``-+s..-..--mh--````./dNNNNNNNNNs             
    -- ``````--`````````.:```````-...+my/--/yhm/````````:NMMMMNNmmd/`           
   `-` ```````.---.``````-.```````+/:+mddhdmmmy.````````.sMNMMNNmmmmh+-.`       
   -```````````````.-/+:-:-..`````--:/hdddddmm/`````````-/mMNNNNNNmmmmmmdy:     
   `..``````````````:shhyyysssoo++/:.-/dddddms.`````````./sNNNNNNNNNmmmmmmmy:`  
     `.-:-.``.-::-/shhh/-ssosssssss//:/ymmmms.```````````-/mNNNhdNNNmmmmdmddds. 
        `-/:-::-:sddho.``.++oooooo/////+dNms........`````./hNNNdhmmmNso+/-`     
           /++--.-/o//:````/o++oo////////s.`   ```.--..``-/ymmmmmo++s----.      
             -++:-..-://-```sy+--:///////.`   ```````.--:/+`   ``               
               `:++:---://+shdy/./.``..:...--..````````-+o+                     
                  `-/+/--+hdy+/+ydhs:` /-.```..--``````/s+                      
                      ./+::sy/shhhhdms:.`  ``````--.``/+/                       
                         -yh/hhhhddNmNd`  `````````/+++:                        
                          -hmhyydmdddN-  ``````````/yo-                         
                          `/hmNNhydhhy````````````-o/.                          
                            `:+sdohhd.```````````:o/                            
                               /dodhy```````````/+:   
EOF

# Motoko GITS:SAC zoomed, high contrast
# cat <<"EOF"
lolcat <<"EOF"
                                          `-///:/+ooo+/:-                       
                                       ./++syyyyyyyyyyyyyho:                    
                                     -+NNNsossoosyyyyyyyyyyys`                  
                                     :sNNNdhhy+oo+/+syyyyyyhhs                  
                                     ysmMNddydhhhhyysysossyooo+                 
                                   `.ohNMNds.ddhddsyhhhyyyyyyyh-                
                                 `.:odNMNNh//yyddhy:sdhdyhyyyyh-                
                                 ./NhsMMMMh+ys/:mohys+ymddyyyhy                 
                               -.--sNmNNMMy.-.``o..+o-.hmdyyhd-                 
                            ./o+---:dN:hMMy`..````````:hdyyyhd`                 
                            `dmNs++sdN+yMMm.`.````````oysyhddd.                 
                            .mNMNdmNNNmmhdNh.-:.````-/soyhmm:-                  
                            smNNMMMNNNm:/dNmh-```.::/yhhhmy+                    
                           .hmmNNNNNNNdyhmmmmdsoo+//+dddm+.`                    
                          :dmmmmNNNNNNNmmmmmdy+/://:ssdmo/:-.`                  
                         `hmmmmmNNNmmmmmmNmoo/.``-``:smo/-```...`               
                         .+:+yhhNNmmmmmmNhh:..--.-.-:ds/-..````.....`           
                        `-```.-yNmmmmdmNy-.``````....s..`.::-.``````-`          
                       `-`````/mNmmddmNd.```````````..````..```````  /          
                      .-``````ymmmmNNNNs```````````````````````..````/`         
                     .-```````hNmNmNNh/-````.````..``....`````://.```/          
                    `:`````.``mNmmmm+````....-`.:-...`....``.//:/:``./          
                    :`````--`:NMNmd/` ``````-/::.``  .````--+o/.-:``:-          
                    :````-/-:dNMmm+...```````.-```  `.  ```+os:``.`.+           
                    -````///+dNMNmyoooo+/:-.` `.-::/++/:-`.yoo-`````o.          
                   ..```-//+sNMNNNmyoooosss+  .+++++sooososysh-`````+do-        
                   --..-//sdNNMNmmNNdyooos/`   -++++o+oosyyydN-`````/mddy:      
                    .-:+ydNNNmNNmmNNMNo/:.`   ` `:/+++osssshNN+`````/Nmdmmo`    
                       .+hdh/-mmNNNmMMo``.`   `````.:+:-.oyNNNs.````oNNmmmmh-   
                          .   dmmmmmMNm-.-``  `.-````-``-ohNNNh:.``-oNNNmmNNm:  
                             `dmmmmmMMMo.````  ``-```.``/shNMMm/:``:oNMNmmmmNd` 
                             :ddmmmNNNMd-```-  ```````.-+osNNMd//..//NMNdmmmmN. 
                             .mmddmNNNMNs.``.````````.:-.-/NNMm//:///mNmdmmmmmo 
                              +NNmmNNNNdo/...-``````-:-.`./oyhN////+dNNdmmmmmmd 
                         ``````+mNNNNNN-.+:-.--..:/--.`/.....sd+oydNNNdmmmmmNNd 
     ```...````..........:-.....:oymmNN/-o/-`-.``:+-.``+:.-:/odNNMNNNmddmmNNNd- 
  /. ```````--.```````````:-````````-..`./mho:--/shmm/`````````./NMMNMMNNmmmd+` 
 :.`  ```````.-::-`````````:`````````+/::+mmddyhmmmms-``````````.yMNNMMNNmmNmmd/
`-````````````````..-/:-.``--````````./://hmddhddmmd:.``````````-/NMMMNNNNNmmmmm
`-```````````````````.ohhs+ooo+//:--.`:`-:+ddddddmmy.```````````-/yNNNNNNNNNmmmm
 `.-..````````..```./shhdysyyssssssssso--.:sdddddmh.````` ``````.//mNNNNNNMMMNmm
    .-:/:.``.-::::+yhhdy:`:soooossssss+////+mmmmmh.``````````````./yNNNNsydNNNNm
       `/+:-:/:-:sdddh+````.+++ooooos+//////sNNms-......-.````````/oMNNNmddNmNNy
         `o/+---.-+so//-`````+oooooo/////////+y.``   ````-:-.````-/omNNNNNh+++s/
           ./o+:--..-:://.````oso::///////////.``   ````````.----///`----:-.... 
              -+o/:----://:-.:yhdy`  `.-::::/.````````````````.-/+o`            
                 -/+/:---:/shhhhs+/:ys-`   -.-:---::-.`````````+so/             
                    .:++:--+hds+//ohhhdy+` ./`   ````.--``````-oy:              
                       `:++::oh++hhhhhhdNy/-`   ```````.--```:oo:               
 WELCOME TO               ./hh+sdhhhhhmNNNN-`  ``````````.+/+++-                
    ________  __________  ________ ______  __  ______ ````+ys+.                 
   / ____/ / / / ____/ / / /  _/ //_/ __ \/  |/  /   |```-oh+`                  
  / /_  / / / / /   / /_/ // // ,< / / / / /|_/ / /| |``-+o`                    
 / __/ / /_/ / /___/ __  // // /| / /_/ / /  / / ___ |`-+o.                     
/_/    \____/\____/_/ /_/___/_/ |_\____/_/  /_/_/  |_|/++`    
EOF

# prompt line
export PS1='\[\e[30;47m\]\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\h:\w\[\e[m\] '

# change to windows home directory
alias cdh='cd /mnt/c/Users/Stefan'

export PATH=/mnt/c/Users/Stefan/bin:~/bin:"$PATH"

# load dotfiles bashrc
source ~/dev/dotfiles/linkfiles/.bashrc
