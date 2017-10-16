#!/usr/bin/env bash

CURRENT_DIR="$( dirname "$0" )"

. "$CURRENT_DIR/scripts/helpers.sh"

scroll_down_exit_copy_mode_option="@scroll-down-exit-copy-mode"
scroll_in_moused_over_pane_option="@scroll-in-moused-over-pane"
scroll_without_changing_pane_option="@scroll-without-changing-pane"
scroll_speed_num_lines_per_scroll_option="@scroll-speed-num-lines-per-scroll"
deprecated_prevent_scroll_for_fullscreen_alternate_buffer_option="@prevent-scroll-for-fullscreen-alternate-buffer"
emulate_scroll_for_no_mouse_alternate_buffer_option="@emulate-scroll-for-no-mouse-alternate-buffer"

get_repeated_scroll_cmd() {
  local scroll_speed_num_lines_per_scroll=$(get_tmux_option "$scroll_speed_num_lines_per_scroll_option" "3")
  local cmd=""
  if echo - | awk "{ if ($scroll_speed_num_lines_per_scroll >= 1) { exit 0 } else { exit 1 } }" ; then  # Positive whole number speed (round down).
    for ((i = 1; i <= scroll_speed_num_lines_per_scroll; i++)); do
      cmd=$cmd"send-keys $1 ; "
    done
  elif echo - | awk "{ if ($scroll_speed_num_lines_per_scroll > 0) { exit 0 } else { exit 1 } }" ; then  # Positive decimal between 0 and 1 (treat as percent).
    # Skip enough scrolls so that we scroll only on the specified percent of scrolls.
    local num_scrolls_to_scroll=`echo - | awk "{print int( 1/$scroll_speed_num_lines_per_scroll ) }"`
    tmux set-environment __scroll_copy_mode__slow_scroll_count 0;
    cmd="if -t = \\\"$CURRENT_DIR/only_scroll_sometimes.sh $num_scrolls_to_scroll\\\" \\\"send-keys $1\\\" \\\"\\\"";
  fi
  echo "$cmd"
}

better_mouse_mode_main() {
  local scroll_down_to_exit=$(get_tmux_option "$scroll_down_exit_copy_mode_option" "on")
  local scroll_in_moused_over_pane=$(get_tmux_option "$scroll_in_moused_over_pane_option" "on")
  local scroll_without_changing_pane=$(get_tmux_option "$scroll_without_changing_pane_option" "off")
  local deprecated_prevent_scroll_for_fullscreen_alternate_buffer=$(get_tmux_option "$deprecated_prevent_scroll_for_fullscreen_alternate_buffer_option" "off")
  local emulate_scroll_for_no_mouse_alternate_buffer=$(get_tmux_option "$emulate_scroll_for_no_mouse_alternate_buffer_option" "$deprecated_prevent_scroll_for_fullscreen_alternate_buffer")

  local enter_copy_mode_cmd="copy-mode"
  local select_moused_over_pane_cmd=""
  local check_for_fullscreen_alternate_buffer=""
  if [ "$scroll_down_to_exit" = 'on' ] ; then
      enter_copy_mode_cmd="copy-mode -e"
  fi
  if [ "$scroll_in_moused_over_pane" = 'on' ] ; then
      select_moused_over_pane_cmd="select-pane -t= ;"
  fi
  if [ "$scroll_without_changing_pane" = 'on' ] ; then
    enter_copy_mode_cmd="$enter_copy_mode_cmd -t="
    select_moused_over_pane_cmd=""
  fi
  if [ "$emulate_scroll_for_no_mouse_alternate_buffer" = 'on' ] ; then
    check_for_fullscreen_alternate_buffer="#{alternate_on}"
  fi

  # Start copy mode when scrolling up and exit when scrolling down to bottom.
  # The "#{mouse_any_flag}" check just sends scrolls to any program running that
  # has mouse support (like vim).
  # NOTE: the successive levels of quoting commands gets a little confusing
  #   here. Tmux uses quoting to denote levels of the if-blocks below. The
  #   pattern used here for consistency is " \" ' \\\" \\\"  ' \" " -- that is,
  #   " for top-level quotes, \" for the next level in, ' for the third level,
  #   and \\\" for the fourth (note that the fourth comes from inside get_repeated_scroll_cmd).
  tmux bind-key -n WheelUpPane \
    if -Ft= "#{mouse_any_flag}" \
      "send-keys -M" \
      " \
        if -Ft= '$check_for_fullscreen_alternate_buffer' \
          \"$(get_repeated_scroll_cmd "-t= up")\" \
          \" \
            $select_moused_over_pane_cmd \
            if -Ft= '#{pane_in_mode}' \
              '$(get_repeated_scroll_cmd -M)' \
              '$enter_copy_mode_cmd ; $(get_repeated_scroll_cmd -M)' \
          \" \
      "
  # Enable sending scroll-downs to the moused-over-pane.
  # NOTE: the quoting pattern used here and in the above command for
  #   consistency is " \" ' \\\" \\\"  ' \" " -- that is, " for top-level quotes,
  #   \" for the next level in, ' for the third level, and \\\" for the fourth
  #   (note that the fourth comes from inside get_repeated_scroll_cmd).
  tmux bind-key -n WheelDownPane \
    if -Ft= "#{mouse_any_flag}" \
      "send-keys -M" \
      " \
        if -Ft= \"$check_for_fullscreen_alternate_buffer\" \
          \"$(get_repeated_scroll_cmd "-t= down")\" \
          \"$select_moused_over_pane_cmd $(get_repeated_scroll_cmd -M)\" \
      "

  # For tmux 2.4+ you have to set the mouse wheel options seperately for copy-mode than from root.
  local tmux_version=$(get_tmux_version)
  if echo - | awk "{ if ($tmux_version >= 2.4) { exit 0 } else { exit 1 } }" ; then  # Use copy-mode tables to set scroll speed.
		local scroll_speed_num_lines_per_scroll=$(get_tmux_option "$scroll_speed_num_lines_per_scroll_option" "3")
    tmux bind-key -Tcopy-mode WheelUpPane send -N"$scroll_speed_num_lines_per_scroll" -X scroll-up
		tmux bind-key -Tcopy-mode WheelDownPane send -N"$scroll_speed_num_lines_per_scroll" -X scroll-down
    tmux bind-key -Tcopy-mode-vi WheelUpPane send -N"$scroll_speed_num_lines_per_scroll" -X scroll-up
		tmux bind-key -Tcopy-mode-vi WheelDownPane send -N"$scroll_speed_num_lines_per_scroll" -X scroll-down
  fi
}

better_mouse_mode_main
