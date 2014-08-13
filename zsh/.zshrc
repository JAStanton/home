# Configuration
# -------------

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Stop co-opting `!`, I'd rather have more exciting comments without launching vim!
setopt nobanghist

# Theme
ZSH_THEME="robbyrussell"

# Let me set my own terminal titles, thank you very much.
DISABLE_AUTO_TITLE="true"

# Autocorrect is annoying as hell.
DISABLE_CORRECTION="true"

# My brain is hardcoded to use sublime instead of st.
alias sublime="st"

# Quick server
alias serve="python -m SimpleHTTPServer & open http://0.0.0.0:8000"

# hack
# alias java="/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin/java"
 export CLOSURE_PATH="/Users/jstanton/Sites/closure-compiler"

# Plugins
# -------

# Git because it's delicious.
plugins+=(git)

# Brew because it's delicious.
plugins+=(brew)

# colored-man because why not.
plugins+=(colored-man)

# history-substring-search because I would die without it.
plugins+=(history-substring-search)

# sublime because it's how I roll.
plugins+=(sublime)

# Kicking things off right.
source $ZSH/oh-my-zsh.sh

export PATH="/Users/jstanton/google-cloud-sdk/bin:/Users/jstanton/scripts:/Users/jstanton/homebrew/bin:/Users/jstanton/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin/g4bin"

# Use brew's ZSH.
PATH+="/usr/local/bin/zsh"

# I seem to be the only one with this issue with history-substring-search.
# Possibly because I use iTerm?
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# ZSH gcloud stuff
#
# https://github.com/littleq0903/gcloud-zsh-completion
fpath=(/Users/jstanton/Sites/home/zsh/gcloud-zsh-completion/src $fpath)

autoload -U compinit compdef
compinit

