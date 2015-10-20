# Tmux Scroll Copy Mode
Restores pre-2.1 behavior of entering and exiting copy-mode with the scroll wheel.

Enter `copy-mode` by scrolling up, and (optionally) exit `copy-mode` by scrolling back all the way down.

### Requirements

This plugin is intended for `tmux` version 2.1 (or higher). It does not work for 2.0 or below, but also is not needed since this is already the default behavior for older versions.

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

- `scroll-down-exit-copy-mode` - Enable/disable exiting `copy-mode` when scrolling hits the bottom of the scroll-back history.
  - "on" (default) - Scrolling can exit `copy-mode`.
  - "off"          - Scrolling to bottom will stay in `copy-mode`.

Put `set -g @scroll-down-exit-copy-mode "off"` in `tmux.conf` to disable.

### Inspiration

Inspired by David Verhasselt's in depth article on Tmux 2.1's changes to Mouse support and scrolling:
http://www.davidverhasselt.com/better-mouse-scrolling-in-tmux/

### License
[MIT](LICENSE.md)

