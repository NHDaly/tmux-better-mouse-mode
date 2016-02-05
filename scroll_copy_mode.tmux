#!/usr/bin/env sh

CURRENT_DIR="$( dirname "$0" )"

. "$CURRENT_DIR/scripts/helpers.sh"

scroll_down_exit_copy_mode_option="@scroll-down-exit-copy-mode"
scroll_in_moused_over_pane_option="@scroll-in-moused-over-pane"
scroll_without_changing_pane_option="@scroll-without-changing-pane"
scroll_speed_num_lines_per_scroll_option="@scroll-speed-num-lines-per-scroll"
prevent_scroll_for_fullscreen_alternate_buffer_option="@prevent-scroll-for-fullscreen-alternate-buffer"

bind_wheel_up_to_enter_copy_mode() {
  local scroll_down_to_exit=$(get_tmux_option "$scroll_down_exit_copy_mode_option" "on")
  local scroll_in_moused_over_pane=$(get_tmux_option "$scroll_in_moused_over_pane_option" "on")
  local scroll_without_changing_pane=$(get_tmux_option "$scroll_without_changing_pane_option" "off")
  local scroll_speed_num_lines_per_scroll=$(get_tmux_option "$scroll_speed_num_lines_per_scroll_option" "3")
  local prevent_scroll_for_fullscreen_alternate_buffer=$(get_tmux_option "$prevent_scroll_for_fullscreen_alternate_buffer_option" "off")

  local enter_copy_mode_cmd="copy-mode"
  local select_moused_over_pane_cmd=""
  local check_for_fullscreen_alternate_buffer=""
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
  if [ "$prevent_scroll_for_fullscreen_alternate_buffer" == 'on' ] ; then
    check_for_fullscreen_alternate_buffer="#{alternate_on}"
  fi

  send_keys_to_tmux_cmd=""
  if [ $(awk "BEGIN { print $scroll_speed_num_lines_per_scroll >= 1 }") -eq 1 ] ; then  # Positive whole number speed (round down).
    for i in `seq 1 "$scroll_speed_num_lines_per_scroll"` ; do
      send_keys_to_tmux_cmd=$send_keys_to_tmux_cmd"send-keys -M ; "
    done
  elif [ $(awk "BEGIN { print $scroll_speed_num_lines_per_scroll >= 0 }") -eq 1 ] ; then  # Positive decimal between 0 and 1 (treat as percent).
    # Skip enough scrolls so that we scroll only on the specified percent of scrolls.
    tmux set-environment __scroll_copy_mode__slow_scroll_count 0;
    send_keys_to_tmux_cmd="if -t = \\\"$CURRENT_DIR/only_scroll_sometimes.sh $scroll_speed_num_lines_per_scroll\\\" \\\"send-keys -M\\\" \\\"\\\"";
  fi


  # Start copy mode when scrolling up and exit when scrolling down to bottom.
  # The "#{mouse_any_flag}" check just sends scrolls to any program running that
  # has mouse support (like vim).
  tmux bind-key -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if-shell -Ft= '$check_for_fullscreen_alternate_buffer' 'send-keys -M' \"if -Ft= '#{pane_in_mode}' '$select_moused_over_pane_cmd $send_keys_to_tmux_cmd' '$select_moused_over_pane_cmd $enter_copy_mode_cmd'\""

  # Enable sending scroll-downs to the moused-over-pane.
  tmux bind-key -n WheelDownPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if-shell -Ft= '$check_for_fullscreen_alternate_buffer' 'send-keys -M' \"if -Ft= '#{pane_in_mode}' '$select_moused_over_pane_cmd $send_keys_to_tmux_cmd' '$select_moused_over_pane_cmd $send_keys_to_tmux_cmd'\""
}


bind_wheel_up_to_enter_copy_mode
