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
  ["ackrc"]=".ackrc"
  ["bashrc"]=".bashrc"
  ["gitconfig"]=".gitconfig"
  ["gtkrc-2.0-kde4"]=".gtkrc-2.0-kde4"
  ["hgrc"]=".hgrc"
  ["vimrc"]=".vimrc"
  ["Xdefaults"]=".Xdefaults"
  ["sublime/Default (Linux).sublime-keymap"]=".config/sublime/Default (Linux).sublime-keymap"
  ["sublime/Distraction Free.sublime-settings"]=".config/sublime/Distraction Free.sublime-settings"
  ["sublime/Preferences.sublime-settings"]=".config/sublime/Preferences.sublime-settings"
  ["tmux/tmux.conf"]=".tmux.conf"
  ["tmux/dev.conf"]=".config/tmux/dev.conf"
  ["systemd/i3.service"]=".config/systemd/user/i3.service"
  ["systemd/xorg@.service"]=".config/systemd/user/xorg@.service"
  ["systemd/xorg@.socket"]=".config/systemd/user/xorg@.socket"
  ["i3/config"]=".i3/config"
  ["i3/i3status.conf"]=".i3/i3status.conf"
)

for file in "${!files[@]}"
do
  link "$(pwd)/${file}" "${HOME}/${files[${file}]}"
done

