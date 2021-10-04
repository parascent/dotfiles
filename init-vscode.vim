syntax on

" set guicursor=
set noshowmatch
set mouse=a
set relativenumber
let mapleader = " "

set nohlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nowrap
set ignorecase
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set foldmethod=indent
set nofoldenable
set wrap
set inccommand=split

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)
augroup END

"Custom tabstops
autocmd FileType vue setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType js setlocal tabstop=2 softtabstop=2 shiftwidth=2
"End Custom tabstops
"
"Switching buffers
:nnoremap <Tab> :bnext<CR>
:nnoremap <S-Tab> :bprevious<CR>

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c


call plug#begin('~/.config/nvim/plugged')

Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'tpope/vim-repeat'
Plug 'svermeulen/vim-easyclip'
Plug 'Shougo/neoyank.vim'
Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
Plug 'rhysd/clever-f.vim'
Plug 'tpope/vim-abolish'
Plug 'godlygeek/tabular'
Plug 'inkarkat/vim-ReplaceWithRegister'
call plug#end()




fun! GotoWindow(id)
    call win_gotoid(a:id)
    MaximizerToggle
endfun



"highlightedyank
let g:highlightedyank_highlight_duration = -1
nmap <C-s> :w<CR>


map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
" nmap s <Plug>(easymotion-overwin-f2)
" nnoremap s <Plug>Sneak_s
" nnoremap S <Plug>Sneak_S

nnoremap cs S
" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)
"
"icons
" let g:vem_tabline_show_icon = 0
"
"bufferline barbar
let bufferline = get(g:, 'bufferline', {})

nmap gcc <Plug>VSCodeCommentaryLine
vmap gcc <Plug>VSCodeCommentaryLine
nmap cc gcc
map cc gcc
vmap cc gcc

function! Get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  let selection = join(lines,'\n')
  return ":Ag /".selection."/"
  "return selection
  " let change = input('Change the selection with: ')
  " execute ":%s/".selection."/".change."/g"
endfunction

nnoremap gm m

nnoremap L $
nnoremap H ^
vnoremap L $
vnoremap H ^

"working with split windows
nnoremap <M-j> <C-W><C-j>
nnoremap <M-k> <C-W><C-k>
nnoremap <M-l> <C-W><C-l>
nnoremap <M-h> <C-W><C-h>
nmap <M-j> <C-W><C-j>
nmap <M-k> <C-W><C-k>
nmap <M-l> <C-W><C-l>
nmap <M-h> <C-W><C-h>
"insert mode arrow keys with hjkland alt

set clipboard=unnamed,unnamedplus
" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <Leader>ps :Rg<CR>
" nnoremap <C-p> :GFiles --exclude-standard --others --cached<CR>
" add below to fish config
" set -Ux FZF_DEFAULT_COMMAND 'fd --type f'
nnoremap <Leader><CR> :so ~/.config/nvim/init-vscode.vim<CR>
nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>
nnoremap <Leader>ee oif err != nil {<CR>log.Fatalf("%+v\n", err)<CR>}<CR><esc>kkI<esc>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
" nnoremap <C-b> :Buffers<CR>
" Vim with me
nnoremap <leader>vwm :colorscheme gruvbox<bar>:set background=dark<CR>
nmap <leader>vtm :highlight Pmenu ctermbg=gray guibg=gray

nnoremap x d
vnoremap x d
nnoremap xx dd
vnoremap xx dd

inoremap <C-c> <esc>

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Sweet Sweet FuGITive
nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>
nmap <leader>gs :G<CR>

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

"autocmd FileType typescript setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType pug setlocal shiftwidth=2 tabstop=2
autocmd Filetype typescript setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype vue setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype cs setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

autocmd FileType javascript setlocal commentstring=//\ %s
autocmd FileType typescript setlocal commentstring=//\ %s
autocmd FileType vue setlocal commentstring=//\ %s
autocmd FileType pug setlocal commentstring=//-\ %s
autocmd FileType cs setlocal commentstring=//-\ %s

" Yank file name from buffer
noremap ydp :let @+=expand("%:p")<CR>

" Tab and Shift-Tab in normal mode to navigate buffers
map <Tab> :BufMRUNext<CR>
map <S-Tab> :BufMRUPrev<CR>

"Denite mappings because of neoyank
" Define mappings
let g:AutoPairsShortcutToggle = ''

"BClose Command

" Delete buffer while keeping window layout (don't close buffer's windows).
" Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
if v:version < 700 || exists('loaded_bclose') || &cp
  finish
endif
let loaded_bclose = 1
if !exists('bclose_multiple')
  let bclose_multiple = 1
endif

" Display an error message.
function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! s:Bclose(bang, buffer)
  if empty(a:buffer)
    let btarget = bufnr('%')
  elseif a:buffer =~ '^\d\+$'
    let btarget = bufnr(str2nr(a:buffer))
  else
    let btarget = bufnr(a:buffer)
  endif
  if btarget < 0
    call s:Warn('No matching buffer for '.a:buffer)
    return
  endif
  if empty(a:bang) && getbufvar(btarget, '&modified')
    call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
    return
  endif
  " Numbers of windows that view target buffer which we will delete.
  let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
  if !g:bclose_multiple && len(wnums) > 1
    call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
    return
  endif
  let wcurrent = winnr()
  for w in wnums
    execute w.'wincmd w'
    let prevbuf = bufnr('#')
    if prevbuf > 0 && buflisted(prevbuf) && prevbuf != btarget
      buffer #
    else
      bprevious
    endif
    if btarget == bufnr('%')
      " Numbers of listed buffers which are not the target to be deleted.
      let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
      " Listed, not target, and not displayed.
      let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
      " Take the first buffer, if any (could be more intelligent).
      let bjump = (bhidden + blisted + [-1])[0]
      if bjump > 0
        execute 'buffer '.bjump
      else
        execute 'enew'.a:bang
      endif
    endif
  endfor
  execute 'bdelete'.a:bang.' '.btarget
  execute wcurrent.'wincmd w'
endfunction
command! -bang -complete=buffer -nargs=? Bclose call <SID>Bclose(<q-bang>, <q-args>)
nnoremap <silent> <Leader>bd :Bclose<CR>

"Tabularize
autocmd VimEnter * :AddTabularPattern object /^.\{-}:

autocmd BufWritePre * :call TrimWhitespace()


