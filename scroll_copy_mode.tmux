#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

scroll_down_exit_copy_mode_option="@scroll-down-exit-copy-mode"
scroll_in_moused_over_pane_option="@scroll-in-moused-over-pane"
scroll_without_changing_pane_option="@scroll-without-changing-pane"

bind_wheel_up_to_enter_copy_mode() {
  local scroll_down_to_exit=$(get_tmux_option "$scroll_down_exit_copy_mode_option" "on")
  local scroll_in_moused_over_pane=$(get_tmux_option "$scroll_in_moused_over_pane_option" "on")
  local scroll_without_changing_pane=$(get_tmux_option "$scroll_without_changing_pane_option" "off")

  local enter_copy_mode_cmd="copy-mode"
  local select_moused_over_pane_cmd=""
  if [ "$scroll_down_to_exit" == 'on' ] ; then
      enter_copy_mode_cmd="copy-mode -e"
  fi
  if [ "$scroll_in_moused_over_pane" == 'on' ] ; then
      select_moused_over_pane_cmd="select-pane -t= ;"
  fi
  if [ "$scroll_without_changing_pane" == 'on' ] ; then
    enter_copy_mode_cmd="$enter_copy_mode_cmd -t="
    select_moused_over_pane_cmd=""
  fi


  # Start copy mode when scrolling up and exit when scrolling down to bottom.
  # The "#{mouse_any_flag}" check just sends scrolls to any program running that
  # has mouse support (like vim).
  tmux bind-key -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' \"$select_moused_over_pane_cmd $enter_copy_mode_cmd\""

  # Enable sending scroll-downs to the moused-over-pane.
  tmux bind-key -n WheelDownPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' \"$select_moused_over_pane_cmd send-keys -M\""
}


bind_wheel_up_to_enter_copy_mode
