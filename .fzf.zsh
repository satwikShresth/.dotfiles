# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/satwikshresth/toolchain/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/satwikshresth/toolchain/homebrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
source "/Users/satwikshresth/toolchain/homebrew/opt/fzf/shell/completion.zsh"

# Key bindings
# ------------
source "/Users/satwikshresth/toolchain/homebrew/opt/fzf/shell/key-bindings.zsh"

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

export FZF_COMPLETION_TRIGGER='?'

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    nvim)         fzf --preview 'bat --style=numbers --color=always --line-range :500 {}';;
    *)            fzf "$@" ;;
  esac
}

sshf(){
  hosts=$(grep "^Host " ~/.ssh/config | awk '{print $2}' | grep -v "*" | grep -v "*$")
  selected_host=$(echo "$hosts" | fzf --height=50% --reverse --prompt="SSH into: ")
  if [ -n "$selected_host" ] 
  then 
    ssh "$selected_host" 
  fi
}

function fuzzy_brew_install() {
    local inst=$(brew formulae | fzf --query="$1" -m --preview $FB_FORMULA_PREVIEW --bind $FB_FORMULA_BIND)

    if [[ $inst ]]; then
        for prog in $(echo $inst); do; brew install $prog; done;
    fi
}

function fuzzy_brew_uninstall() {
    local uninst=$(brew leaves | fzf --query="$1" -m --preview $FB_FORMULA_PREVIEW --bind $FB_FORMULA_BIND)

    if [[ $uninst ]]; then
        for prog in $(echo $uninst);
        do; brew uninstall $prog; done;
    fi
}

function fuzzy_cask_install() {
    local inst=$(brew casks | fzf --query="$1" -m --preview $FB_CASK_PREVIEW --bind $FB_CASK_BIND)

    if [[ $inst ]]; then
        for prog in $(echo $inst); do; brew install --cask $prog; done;
    fi
}

function fuzzy_cask_uninstall() {
    local inst=$(brew list --cask | fzf --query="$1" -m --preview $FB_CASK_PREVIEW --bind $FB_CASK_BIND)

    if [[ $inst ]]; then
        for prog in $(echo $inst); do; brew uninstall --cask $prog; done;
    fi
}

function fuzzy_show_json_file(){
  local filename=$1
  if [[ $filename ]]; then
    command cat $filename | fzf --preview 'echo {} | jq -C'
  fi

}

  function frg {
      result=$(rg --ignore-case --color=always --line-number --no-heading "$@" |
        fzf --ansi \
            --color 'hl:-1:underline,hl+:-1:underline:reverse' \
            --delimiter ':' \
            --preview "bat --color=always {1} --theme='Solarized (light)' --highlight-line {2}" )
      file=${result%%:*}
      linenumber=$(echo "${result}" | cut -d: -f2)
      if [[ -n "$file" ]]; then
              $EDITOR +"${linenumber}" "$file"
      fi
    }

alias fcj='fuzzy_show_json_file'
alias fjq='fzf --preview "echo {} | jq -C"'
alias fbi=fuzzy_brew_install
alias fbui=fuzzy_brew_uninstall
alias fci=fuzzy_cask_install
alias fcui=fuzzy_cask_uninstall

