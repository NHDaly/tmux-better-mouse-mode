#!/usr/bin/env bash

# Start copy mode when scrolling up and exit when scrolling down to bottom.
# The "#{mouse_any_flag}" check just sends scrolls to any program running that
# has mouse support (like vim).
tmux bind-key -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e'"

