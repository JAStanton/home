# Configuration
# -------------

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Editor
export VISUAL=vim
export EDITOR="$VISUAL"

# Set vim mode for terminal
set -o vi

# Theme
ZSH_THEME="robbyrussell"

# Helpful aliases
# Quick server
alias serve="python -m SimpleHTTPServer & open http://0.0.0.0:8000"

killport() {
  PORT_NUMBER="${1}"
  PID="$(lsof -t -i:${PORT_NUMBER})" || echo "No process with port number ${PORT_NUMBER}"

  if [[ "${PID}" ]]; then
    echo "killing PID ${PID}"
    kill -9 ${PID}
  fi
}

alias killport='killport'


# Plugins
# -------

plugins+=(git)
plugins+=(history-substring-search)

source $ZSH/oh-my-zsh.sh
