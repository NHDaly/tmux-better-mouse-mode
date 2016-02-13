#!/usr/bin/env sh

echo >&2 "Entering only_scroll_sometimes.sh"

log() {
  echo >&2 "$1"
}

num_scrolls_to_scroll=$1

log "About to get tmux environment variable"

get_count_cmd=`tmux show-environment -g __scroll_copy_mode__slow_scroll_count`
eval $get_count_cmd

# Save the current count so we can use it in the return statement at the end.
CURRENT_COUNT=$__scroll_copy_mode__slow_scroll_count

log "About to do mod math"

# Now increment and loop around if we've finished the scroll cycle.
((__scroll_copy_mode__slow_scroll_count = (__scroll_copy_mode__slow_scroll_count + 1 ) % num_scrolls_to_scroll))


log "About to set tmux environment variable"

# Store the new value in tmux.
tmux set-environment -g __scroll_copy_mode__slow_scroll_count $__scroll_copy_mode__slow_scroll_count

log "About to return"

# Return true if this is the first scroll for this scroll-cycle, and false if we haven't hit the end of the cycle.
[ $CURRENT_COUNT -eq 0 ]



