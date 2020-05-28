#!/bin/bash
# sh-labs
# create with good vibes by: @chaconmelgarejo
# description: menu utils

while true ; do
  clear

  #menu options
  echo "Choose 1, 2 or 3"
  echo "1: option 1"
  echo "2: option 2"
  echo "3: quit"

  # read only one character
  read -sn1

  # case options
  case "$REPLY" in
    1) echo "option 1"
    2) echo "option 2"
    3) exit 0;;
    *) echo "please choose again";;
  esac
  read -n1 -p "press any key to continue"
done
