let s:commonFdDict= {'window':{'width':0.9,'height':0.9},'tmux': '-p 70%,75%','source': 'fd .','sink': 'tabnew','options':'--preview " [[ -f {} ]] && bat -f {} || eza -lah --color=always --tree {}"'}
let s:commonRgDict= {'window':{'width':0.9,'height':0.9},'tmux': '-p 70%,75%','source': 'rg --ignore-case  --line-number --no-heading "."','sink': 'tabnew','options':"--ansi --color 'hl:-1:underline,hl+:-1:underline:reverse' --delimiter ':' --preview \"bat --color=always {1} --theme='Solarized (light)' --highlight-line {2}\""}

function! FuzzyCurBuffDir()
  let l:localDict =copy(s:commonFdDict)
  let l:localDict['dir']= expand('%:p:h')
  call fzf#run(fzf#wrap(l:localDict))
endfunction

function! FuzzyCurWorkDir()
  let l:localDict =copy(s:commonFdDict)
  let l:localDict['dir']= getcwd()
  call fzf#run(fzf#wrap(l:localDict))
endfunction

function! FuzzyRipCurrWorkDir()
  let l:localDict =copy(s:commonRgDict)
  let l:localDict['dir']= getcwd()
  call fzf#run(fzf#wrap(l:localDict))
endfunction

function! FuzzyRipCurrBuffDir()
  let l:localDict =copy(s:commonRgDict)
  let l:localDict['dir']= expand('%:p:h')
  call fzf#run(fzf#wrap(l:localDict))
endfunction

function! s:gotoLine(str)
  call cursor(split(a:str[0],':')[0],bufnr('%'))
endfunction

function! FuzzyRipCurrBuff()
  let l:localDict =copy(s:commonRgDict)
  let l:currBuff = expand('%:p')
  let l:localDict['source']= 'cat '. l:currBuff .' | '.s:commonRgDict['source']
  call remove(l:localDict,'sink')
  let l:localDict['sink*']= function('s:gotoLine')
  let l:localDict['options']= "--ansi --color 'hl:-1:underline,hl+:-1:underline:reverse' --delimiter ':' --preview \"bat " .l:currBuff. " --color=always --theme='Solarized (light)' --highlight-line {1}\""
  call fzf#run(fzf#wrap(l:localDict))
endfunction


function! s:gotoBufLine(str)
  let l:listBuf =split(a:str[0],':')
  execute 'buffer' l:listBuf[0]
  call cursor(l:listBuf[1],0)
endfunction

function! FuzzyRipAllCurrBuff()
  let l:dict = {}
  for bufnr in range(1, bufnr('$'))
    if buflisted(bufnr)
      let dict[fnamemodify(bufname(bufnr), ':p')] = bufnr 
    endif
  endfor


  let l:keys = keys(l:dict)

  let l:localDict =copy(s:commonRgDict)
  let l:localDict['source']= "rg --ignore-case --line-number --no-heading \".\" ".join(l:keys," ")
  echo l:localDict['source']
  call remove(l:localDict,'sink')
  let l:localDict['sink*']= function('s:gotoBufLine')
  call fzf#run(fzf#wrap(l:localDict))
endfunction


