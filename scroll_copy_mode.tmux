#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

scroll_down_exit_copy_mode_option="@scroll-down-exit-copy-mode"

bind_wheel_up_to_enter_copy_mode() {
  local scroll_down_to_exit=$(get_tmux_option "$scroll_down_exit_copy_mode_option" "on")

  local enter_copy_mode_cmd="copy-mode"
  case "$scroll_down_to_exit" in
    'on') enter_copy_mode_cmd="copy-mode -e" ;;
    *)    enter_copy_mode_cmd="copy-mode" ;;
  esac

  # Start copy mode when scrolling up and exit when scrolling down to bottom.
# The "#{mouse_any_flag}" check just sends scrolls to any program running that
# has mouse support (like vim).
  tmux bind-key -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' \"$enter_copy_mode_cmd\""
}

bind_wheel_up_to_enter_copy_mode
