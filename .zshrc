eval "$(starship init zsh)"
source ~/.zsh_alias
source ~/.fzf.zsh

#path variables
export PATH="${PATH:+${PATH}:}/Users/satwikshresth/toolchain/homebrew/bin/"
export PATH="${PATH:+${PATH}:}/Users/satwikshresth/bin"
export EDITOR='/Users/satwikshresth/toolchain/homebrew/bin/nvim'

source /Users/satwikshresth/.config/broot/launcher/bash/br

eval "$(direnv hook zsh)"
