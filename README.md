# Tmux Scroll Copy Mode
Restores pre-2.1 behavior of entering and exiting copy-mode with the scroll wheel.

Enter `copy-mode` by scrolling up, and (optionally) exit `copy-mode` by scrolling back all the way down.

Also adds simple options to tweak mouse-mode behavior.

### Requirements

This plugin is intended for `tmux` version 2.1 (or higher). It does not work for 2.0 or below, but also is not needed since this is already the default behavior for older versions.

This plugin only *changes* the mouse-mode options, but does not enable mouse-mode.

To enable mouse-mode in tmux 2.1, put the following line in your `~/.tmux.conf`:

    set-option -g mouse on

### Key bindings

In tmux "normal" mode:

- `WheelUpPane` - Enters `copy-mode`.

In tmux `copy-mode`:

- `WheelDownPane` - If scrolls to the bottom of scrollback history, exits `copy-mode`. (To disable this feature, see Configuration.

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @plugin 'nhdaly/tmux-scroll-copy-mode'

Hit `prefix + I` to fetch the plugin and source it. You should now be able to
use the plugin.

To enable mouse-mode in tmux 2.1, put the following line in your `~/.tmux.conf`:

    set-option -g mouse on

### Manual Installation

Clone the repo:

    $ git clone https://github.com/nhdaly/tmux-scroll-copy-mode ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/tmux_scroll_copy_mode.tmux

Reload TMUX environment:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

You should now be able to use the plugin.

### Configuration

Set options in `.tmux.conf`. ie `set -g @scroll-down-exit-copy-mode "off"` to disable scrolling down exits copy-mode. 

- `scroll-down-exit-copy-mode` - When enabled, the pane exits `copy-mode` when scrolling hits the bottom of the scroll-back history.
  - "on" (default)  - Scrolling can exit `copy-mode`.
  - "off"           - Scrolling to bottom will stay in `copy-mode`.

- `scroll-in-moused-over-pane` - When enabled, scroll events are passed to the moused-over pane instead of the currently selected pane.
  - "on" (default)  - Scroll events are sent to moused-over pane.
  - "off"           - Scroll events stay in currently selected pane.

- `scroll-without-changing-pane` - When enabled, scrolling the mouse will not select the moused-over pane, allowing you to scroll a window just to read previous output and then keep typing in the current pane. Enabling this feature breaks from `tmux 2.0` settings, but may be an improvement.
  - "on"            - Scroll events are sent to moused-over pane.
  - "off" (default) - Scroll events stay in currently selected pane.

### Inspiration

Inspired by David Verhasselt's in depth article on Tmux 2.1's changes to Mouse support and scrolling:
http://www.davidverhasselt.com/better-mouse-scrolling-in-tmux/

### License
[MIT](LICENSE.md)

