echo >&2 "Entering helpers.sh"

log() {
  echo >&2 "$1"
}

get_tmux_option() {
  log "Calling get_tmux_option($1, $2)"

  local option="$1"
  local default_value="$2"
  local option_value=$(tmux show-option -gqv "$option")
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}


