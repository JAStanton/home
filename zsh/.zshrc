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

# Git because it's delicious.
plugins=(git)

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

# pretty standard stuff here
export PATH="/Users/jstanton/homebrew/bin:/Users/jstanton/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin/g4bin"

# Sometimes history-substring-search doesn't play nice with iTerm.
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
