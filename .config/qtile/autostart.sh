#!/bin/sh

main() {
   change-wallpaper &
   dunst &
   /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
   #picom & # --experimental-backends --vsync should prevent screen tearing on most setups if needed
   #eos-welcome &
}

#main "$@" 1> /dev/null 2>&1