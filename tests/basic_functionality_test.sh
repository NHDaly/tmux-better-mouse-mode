#!/usr/bin/env sh

# Setup
tmux() {
  # Forward the "getter" calls to actual tmux, but change the setters to just
  # echo, so we can test what its setting.
  if [[ "$1" == "show-option" ]] ; then
    tmux-2.2/tmux "$@"
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
