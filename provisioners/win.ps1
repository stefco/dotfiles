# vim: set syntax=ps1:
# run all this after deb.sh and installing git for windows

# DEPRECATED
# link winterm settings
# cmd /c 'mklink C:\Users\Stefan\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json \\wsl$\debian\home\s\dev\dotfiles\linkfiles\.winterm.json'

# clone dotfiles to windows home dir
cd ~
New-Item -ItemType "directory" dev -Force
cd dev
git clone git@github.com:stefco/dotfiles.git

# TODO install chocolatey
choco install win32yank
choco install fzf

# install neovim (pre-release version)
choco install neovim --pre
mkdir ~\AppData\Local\nvim
cmd /c 'mklink init.vim ..\..\..\dev\dotfiles\linkfiles\.vimrc'

# install vim plug (https://github.com/junegunn/vim-plug#windows-powershell)
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni $HOME/AppData/Local/nvim/autoload/plug.vim -Force

# Turn on Vi Mode in Powershell
Add-Content -Path $profile -Value "Set-PSReadLineOption -EditMode Vi"
