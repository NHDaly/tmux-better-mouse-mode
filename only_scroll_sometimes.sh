#!/usr/bin/env sh

num_scrolls_to_scroll=$1

get_count_cmd=`tmux show-environment -g __scroll_copy_mode__slow_scroll_count`
eval $get_count_cmd

# Save the current count so we can use it in the return statement at the end.
CURRENT_COUNT=$__scroll_copy_mode__slow_scroll_count

# Now increment and loop around if we've finished the scroll cycle.
__scroll_copy_mode__slow_scroll_count=$(( (__scroll_copy_mode__slow_scroll_count + 1) % num_scrolls_to_scroll))


# Store the new value in tmux.
tmux set-environment -g __scroll_copy_mode__slow_scroll_count $__scroll_copy_mode__slow_scroll_count

# Return true if this is the first scroll for this scroll-cycle, and false if we haven't hit the end of the cycle.
[ $CURRENT_COUNT -eq 0 ]



