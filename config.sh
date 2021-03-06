#!/bin/bash

# This method creates link alongside necessary parent directories.
# It accepts filename and destination link name.
link() {
    file=$1
    link=$2

    mkdir -p "$(dirname "${link}")"
    ln -vf -s "${file}" "${link}"
}

declare -A files
files=(
    #["ackrc"]=".ackrc"
    ["ptconfig.toml"]=".ptconfig.toml"
    ["gitconfig"]=".gitconfig"
    ["hgrc"]=".hgrc"
    ["vimrc"]=".vimrc"
    ["Xdefaults"]=".Xdefaults"
    #["fonts.conf"]=".config/fontconfig/fonts.conf"
    #["xbindkeysrc"]=".xbindkeysrc"
    ["bash/bash_profile"]=".bash_profile"
    ["bash/bashrc"]=".bashrc"
    ["code/settings.json"]=".config/Code/User/settings.json"
    #["sublime/Anaconda.sublime-settings"]=".config/sublime-text-3/Packages/User/Anaconda.sublime-settings"
    #["sublime/Default (Linux).sublime-keymap"]=".config/sublime-text-3/Packages/User/Default (Linux).sublime-keymap"
    #["sublime/Distraction Free.sublime-settings"]=".config/sublime-text-3/Packages/User/Distraction Free.sublime-settings"
    #["sublime/GoSublime.sublime-settings"]=".config/sublime-text-3/Packages/User/GoSublime.sublime-settings"
    #["sublime/MarkdownPreview.sublime-settings"]=".config/sublime-text-3/Packages/User/MarkdownPreview.sublime-settings"
    #["sublime/Package Control.sublime-settings"]=".config/sublime-text-3/Packages/User/Package Control.sublime-settings"
    #["sublime/Preferences.sublime-settings"]=".config/sublime-text-3/Packages/User/Preferences.sublime-settings"
    #["sublime/Side Bar.sublime-settings"]=".config/sublime-text-3/Packages/User/Side Bar.sublime-settings"
    #["sublime/SearchInProject.sublime-settings"]=".config/sublime-text-3/Packages/User/SearchInProject.sublime-settings"
    ["i3/config"]=".i3/config"
    ["i3/i3status.conf"]=".i3/i3status.conf"
    ["gtk/gtkrc-2.0"]=".gtkrc-2.0"
    ["gtk/settings3.ini"]=".config/gtk-3.0/settings.ini"
    #["firefox/userContent.css"]=".mozilla/firefox/*.default/chrome/userContent.css"
    ["clipitrc"]=".config/clipit/clipitrc"
)

declare -A cpfiles
cpfiles=(
    ["systemd/i3.service"]=".config/systemd/user/i3.service"
    ["systemd/xorg@.service"]=".config/systemd/user/xorg@.service"
    ["systemd/xorg@.socket"]=".config/systemd/user/xorg@.socket"
    ["systemd/checkbattery.service"]=".config/systemd/user/checkbattery.service"
    ["systemd/checkbattery.timer"]=".config/systemd/user/checkbattery.timer"
)

declare -A sudofiles
sudofiles=(
    ["i3/i3exit"]="/usr/local/bin"
    ["i3/checkbattery"]="/usr/local/bin"
)

for file in "${!files[@]}"
do
    link "$(pwd)/${file}" "${HOME}/${files[${file}]}"
done

for file in "${!cpfiles[@]}"
do
    cp -v "$(pwd)/${file}" "${HOME}/${cpfiles[${file}]}"
done

for file in "${!sudofiles[@]}"
do
    sudo cp -v "$(pwd)/${file}" "${sudofiles[${file}]}"
done
