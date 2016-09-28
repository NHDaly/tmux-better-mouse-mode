#!/usr/bin/env sh

# Setup
tmux() {
  if [[ "$1" == "show-option" ]] ; then
    \tmux "$@"
  else 
    echo "$@"
  fi
}
export -f tmux

# ------ Unit Tests -----------------------


testBasicBindKeysAreCalled() {
  settings_output=$(bash scroll_copy_mode.tmux)

  assertNotNull "`echo $settings_output | grep 'bind-key -n WheelUpPane'`"
  assertNotNull "`echo $settings_output | grep 'bind-key -n WheelDownPane'`"
}

# --------- Run tests command -------------
. shunit2-2.1.6/src/shunit2
