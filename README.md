# Tmux Better Mouse Mode
A tmux plugin to better manage the mouse.

Provides options to control mouse behavior in tmux, so it will behave exactly how you want:
 - Emulate mouse-support for full-screen programs like `less` that don't provide built in mouse support. 
 - Exit `copy-mode` and return to your prompt by scrolling back all the way down to the bottom.
 - Adjust your scrolling speed.
 - And more!

Finally, `tmux` version 2.1 introduced backwards-incompatible changes to the mouse behavior, and this plugin restores the old mouse behavior. `tmux` version 2.2 mostly restores the 2.0 mouse behavior, but this plugin improves tmux mouse mode beyond those changes and provides you with more control.

### Requirements

This plugin is intended for `tmux` version 2.1 and higher. It does not work for 2.0 or below.

NOTE: This plugin provides options to *change* the mouse-mode behavior, but does not enable mouse-mode.

To enable mouse-mode in tmux 2.1+, put the following line in your `~/.tmux.conf`:

    set-option -g mouse on

### Key bindings

This plugin will overwrite the values for `WheelUpPane` and `WheelDownPane` in tmux in order to configure mouse scrolling.

To see your current setting for these variables, check the output of `tmux list-keys -T root`.

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

1. Add this plugin to the list of TPM plugins in `.tmux.conf`:

        set -g @plugin 'nhdaly/tmux-better-mouse-mode'

1. Press `prefix` + <kbd>I</kbd> or run `$TMUX_PLUGIN_MANAGER_PATH/tpm/scripts/install_plugins.sh` to fetch the plugin and source it. You should now be able to
use the plugin.

1. To enable mouse-mode in tmux 2.1+, put the following line in your `.tmux.conf`:

        set-option -g mouse on

### Manual Installation

1. Clone the repo:

        $ git clone https://github.com/nhdaly/tmux-better-mouse-mode ~/clone/path

1. Add this line to the bottom of `.tmux.conf`:

        run-shell ~/clone/path/scroll_copy_mode.tmux

1. Reload TMUX environment:

        # type this in terminal
        $ tmux source-file ~/.tmux.conf

You should now be able to use the plugin.

### Configuration

Set these options in `.tmux.conf`. For example, `set -g @scroll-down-exit-copy-mode "off"` to disable scrolling down exits copy-mode. 

- `scroll-down-exit-copy-mode` - When enabled, the pane exits `copy-mode` when scrolling hits the bottom of the scroll-back history.
  - "on" (default)  - Scrolling can exit `copy-mode`.
  - "off"           - Scrolling to bottom will stay in `copy-mode`.

- `scroll-without-changing-pane` - When enabled, scrolling the mouse will not select the moused-over pane, allowing you to scroll a window just to read previous output and then keep typing in the current pane. Enabling this feature is a change from `tmux 2.0` settings, but may be an improvement.
  - "on"            - Scroll events are sent to moused-over pane.
  - "off" (default) - Scroll events stay in currently selected pane.

- `scroll-in-moused-over-pane` - When enabled, scrolling with your mouse over a pane will perform the scroll in that pane, instead of the currently selected one. If `scroll-without-changing-pane` is set to `"off"`, this will also select the moused-over pane.
  - "on" (default)  - Scroll events select and scroll the moused-over pane.
  - "off"           - Scroll events are ingored unless the mouse is over the currently selected pane.

- `scroll-speed-num-lines-per-scroll` - Sets the number of lines to scroll per mouse wheel scroll event. The default option is 3, which was the scroll speed in `tmux 2.0`. Larger numbers scroll faster. To slow down scrolling to slower than one line per wheel click, set the value to a decimal between 0.0 and 1.0. With a decimal value, only that fraction of wheel events will take effect. The value must be > 0. Examples:
  - "3" (default)   - Scroll three lines per every mouse wheel click.
  - "1"             - One line per mouse wheel scroll click (smoothest).
  - "0.5"           - Scroll one line only on every other mouse wheel scroll click.
  - "0.25"           - Scroll one line only on every fourth mouse wheel scroll click.

- `emulate-scroll-for-no-mouse-alternate-buffer` - When enabled, tmux will emulate scrolling for "full-screen", alternate buffer programs, such as `less`, `man`, or `vi` that don't themselves already support mouse interactions. It will not enter `copy-mode` and will not scroll through pane output history, but will instead send `<up-arrow>` (<kbd>&uparrow;</kbd>) and `<down-arrow>`(<kbd>&downarrow;</kbd>) keys to the application. The scroll speed is also set by `@scroll-speed-num-lines-per-scroll` above.
This option defaults to "off", which matches the behavior in `tmux 2.0`. Note, though, that this default behavior may be undesirable since the pane history gets munged when entering a full-screen alternate buffer program. It's a pretty great option is all I'm saying.
  - "on"            - <kbd>&uparrow;</kbd> and <kbd>&downarrow;</kbd> keys are passed to the alternate buffer program on scroll events.
  - "off" (default) - Scroll event causes scrollback in pane output.

### Inspiration

Inspired by David Verhasselt's in depth article on Tmux 2.1's changes to Mouse support and scrolling:
http://www.davidverhasselt.com/better-mouse-scrolling-in-tmux/

### License
[MIT](LICENSE.md)

