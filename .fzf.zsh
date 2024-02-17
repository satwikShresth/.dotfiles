# Setup fmux
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

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --ansi'

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'

export FZF_COMPLETION_TRIGGER='?'

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fmux "$@" --preview 'tree -C {} | head -200' ;;
    nvim)         fmux --preview 'bat --style=numbers --color=always --line-range :500 {}';;
    *)            fmux "$@" ;;
  esac
}

sshf(){
  hosts=$(grep "^Host " ~/.ssh/config | awk '{print $2}' | grep -v "*" | grep -v "*$")
  selected_host=$(echo "$hosts" | fmux --height=50% --reverse --prompt="SSH into: ")
  if [ -n "$selected_host" ] 
  then 
    ssh "$selected_host" 
  fi
}

function fuzzy_brew_install() {
    local inst=$(brew formulae | fmux --query="$1" -m --preview $FB_FORMULA_PREVIEW --bind $FB_FORMULA_BIND)

    if [[ $inst ]]; then
        for prog in $(echo $inst); do; brew install $prog; done;
    fi
}

function fuzzy_brew_uninstall() {
    local uninst=$(brew leaves | fmux --query="$1" -m --preview $FB_FORMULA_PREVIEW --bind $FB_FORMULA_BIND)

    if [[ $uninst ]]; then
        for prog in $(echo $uninst);
        do; brew uninstall $prog; done;
    fi
}

function fuzzy_cask_install() {
    local inst=$(brew casks | fmux --query="$1" -m --preview $FB_CASK_PREVIEW --bind $FB_CASK_BIND)

    if [[ $inst ]]; then
        for prog in $(echo $inst); do; brew install --cask $prog; done;
    fi
}

function fuzzy_cask_uninstall() {
    local inst=$(brew list --cask | fmux --query="$1" -m --preview $FB_CASK_PREVIEW --bind $FB_CASK_BIND)

    if [[ $inst ]]; then
        for prog in $(echo $inst); do; brew uninstall --cask $prog; done;
    fi
}

function fuzzy_show_json_file(){
  local filename=$1
  if [[ $filename ]]; then
    command cat $filename | fmux --preview 'echo {} | jq -C'
  fi

}

  function frg {
      result=$(rg --ignore-case --color=always --line-number --no-heading "$@" |
        fmux --ansi \
            --color 'hl:-1:underline,hl+:-1:underline:reverse' \
            --delimiter ':' \
            --preview "bat --color=always {1} --theme='Solarized (light)' --highlight-line {2}" )
      file=${result%%:*}
      linenumber=$(echo "${result}" | cut -d: -f2)
      if [[ -n "$file" ]]; then
              $EDITOR +"${linenumber}" "$file"
      fi
    }


function sd()
{
  local dirr=$(fd --color=always $@ | fzf-tmux -p 70%,75% --preview " [[ -f {} ]] && bat -f {} || eza -lah --color=always --tree {}")
  [[ -f $dirr ]] && nvim $dirr && return
  [[ -d $dirr ]] && cd $dirr && return
}

function ta()
{
  local sess=$(tmux list-sessions | fmux |sed -E 's/:.*$//')
  [[ $sess ]] && tmux a -t $sess 2> /dev/null || tmux switchc -t $sess
}

alias fcj='fuzzy_show_json_file'
alias fjq='fmux --preview "echo {} | jq -C"'
alias fjq='fd'
alias fbi=fuzzy_brew_install
alias fbui=fuzzy_brew_uninstall
alias fci=fuzzy_cask_install
alias fcui=fuzzy_cask_uninstall

