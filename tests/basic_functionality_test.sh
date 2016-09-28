#!/usr/bin/env sh

# Setup
#tmux() {
#  # Forward the "getter" calls to actual tmux, but change the setters to just
#  # echo, so we can test what its setting.
#  if [[ "$1" == "show-option" ]] ; then
#    tmux-2.2/tmux "$@"
#  else 
#    echo "$@"
#  fi
#}
tmux() {
  tmux-2.2/tmux "$@"
}
export -f tmux

# ------ Unit Tests -----------------------


testBasicBindKeysAreCalled() {
  bash scroll_copy_mode.tmux

  assertNotNull "`tmux list-keys -T root | grep 'WheelUpPane'`"
  assertNotNull "`tmux list-keys -T root | grep 'WheelDownPane'`"
}

checkScrollSpeedSetCorrectly() {
  testSpeed="$1"
  expectedValue="$2"
  tmux set -g @scroll-speed-num-lines-per-scroll $testSpeed

  settings_output=$(bash scroll_copy_mode.tmux)

  assertEquals 'number of `send-keys` per scroll not equal to user setting' $expectedValue `tmux list-keys -T root | grep 'WheelUpPane' | grep -o "'send-keys[^']*'" | head -n 1 | grep -o 'send-keys' | wc -l`
}

testValidIntegerScrollSpeeds() {
  checkScrollSpeedSetCorrectly 1 1
  checkScrollSpeedSetCorrectly 2 2
  checkScrollSpeedSetCorrectly 10 10
  checkScrollSpeedSetCorrectly 0 0
}

testInvalidIntegerScrollSpeeds() {
  checkScrollSpeedSetCorrectly "-1" 0
  checkScrollSpeedSetCorrectly "-10" 0
  checkScrollSpeedSetCorrectly "-0.1" 0
}


# --------- Run tests command -------------
. shunit2-2.1.6/src/shunit2
