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

  bash scroll_copy_mode.tmux

  # Make sure send-keys shows up correct number of times in up and down scroll bindings.
  assertEquals 'number of `send-keys` per scroll up not equal to user setting' $expectedValue `tmux list-keys -T root | grep 'WheelUpPane' | grep -o "'send-keys[^']*'" | head -n 1 | grep -o 'send-keys' | wc -l`
  assertEquals 'number of `send-keys` per scroll down not equal to user setting' $expectedValue `tmux list-keys -T root | grep 'WheelDownPane' | grep -o "'send-keys[^']*'" | head -n 1 | grep -o 'send-keys' | wc -l`
}

testValidIntegerScrollSpeeds() {
  checkScrollSpeedSetCorrectly 1 1
  checkScrollSpeedSetCorrectly 2 2
  checkScrollSpeedSetCorrectly 10 10
  checkScrollSpeedSetCorrectly 0 0
  checkScrollSpeedSetCorrectly 2.5 2
}

testInvalidIntegerScrollSpeeds() {
  checkScrollSpeedSetCorrectly "-1" 0
  checkScrollSpeedSetCorrectly "-10" 0
  checkScrollSpeedSetCorrectly "-0.1" 0
}

checkFractionalScrollSpeedSetCorrectly() {
  testSpeed="$1"
  expectedNumScrollsBeforeScroll="$2"
  tmux set -g @scroll-speed-num-lines-per-scroll $testSpeed

  bash scroll_copy_mode.tmux

  assertNotNull "`tmux list-keys -T root | grep 'WheelUpPane' | grep \"only_scroll_sometimes.sh $expectedNumScrollsBeforeScroll\"`"
  assertNotNull "`tmux list-keys -T root | grep 'WheelDownPane' | grep \"only_scroll_sometimes.sh $expectedNumScrollsBeforeScroll\"`"

  assertNotNull "`tmux show-environment __scroll_copy_mode__slow_scroll_count`"
}

testValidFractionalScrollSpeeds() {
  checkFractionalScrollSpeedSetCorrectly 0.5 2
  checkFractionalScrollSpeedSetCorrectly 0.25 4
  checkFractionalScrollSpeedSetCorrectly 0.33 3
}

# --------- Run tests command -------------
. shunit2-2.1.6/src/shunit2
