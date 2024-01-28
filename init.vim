syntax on
" :set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
" 		  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
" 		  \,sm:block-blinkwait175-blinkoff150-blinkon175
"
set noshowmatch
set mouse=a
set relativenumber
let mapleader = " "
set number
set signcolumn=yes
set title

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * setlocal relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * setlocal norelativenumber
augroup END

augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorcolumn
  au WinLeave * setlocal nocursorline
  au WinLeave * setlocal nocursorcolumn
  autocmd BufWinEnter * if line2byte(line("$") + 1) > 100 | set nocursorcolumn | endif
augroup END

autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)
augroup END

autocmd BufNewFile,BufReadPost *.pug set filetype=pug

if has('title') && (has('gui_running') || &title)
    set titlestring=
    set titlestring+=%f\                                              " file name
    set titlestring+=%h%m%r%w                                         " flags
    set titlestring+=\ -\ %{v:progname}                               " program name
    set titlestring+=\ -\ %{substitute(getcwd(),\ $HOME,\ '~',\ '')}  " working directory
endif

set wildoptions+=pum
set hlsearch
set hidden
set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
autocmd FileType norg setlocal shiftwidth=4 softtabstop=4 expandtab
set expandtab
set smartindent
set autoindent
set nu
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
" set foldmethod=expr
" set foldexpr=nvim_treeparser#foldexpr()
set nofoldenable
set wrap
set linebreak
set autoread
set inccommand=split
set mousefocus
set breakindent
set showbreak=\ \\_
set updatetime=300
set exrc
set secure
set spell
set spelllang=en_us
set spelloptions=camel
set splitbelow
set splitright

autocmd BufNewFile,BufRead *.cshtml set filetype=cshtml
autocmd FileType cshtml setlocal shiftwidth=4 softtabstop=4 expandtab

" :nmap <leader>e :NERDTreeToggle<CR>
" :nmap <leader>e :NvimTreeToggle<CR>
" nmap <leader>e :CHADopen<CR>
:nmap <space>r :registers<CR>
:vmap <space>r :registers<CR>
"Custom tabstops
"End Custom tabstops

let NERDTreeShowHidden=1
"Switching buffers
" :nnoremap <Tab> :bnext<CR>
" :nnoremap <S-Tab> :bprevious<CR>

"Keep cursor centered on next
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
nnoremap K a<CR><Esc>

"Undo break points
inoremap , ,<c-g>u
inoremap ( (<c-g>u
inoremap [ [<c-g>u
inoremap ' '<c-g>u
inoremap " "<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

nnoremap <expr> <silent> 0 col('.') == match(getline('.'),'\S')+1 ? '0' : '^'
"jumplist mutations
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

"move to next desired location
inoremap <silent> jj <c-o>:call search('}\\|)\\|]\\|>\\|"\\|`\\|,\\|''' , 'cW')<cr><Right>
imap ;; <Esc>A;<Esc>
imap <C-=> <Esc>A =
imap ,, <Esc>A,<Esc>
imap ,l ,<space>
imap ,jj <Esc>A,<Cr><Esc>j,
imap ,kk <Esc>A,<Cr><Esc>k,
imap ooo <Cr>,
imap :[] :[],
" inoremap <silent> jj<c-o> getline('.')[col('.')-1] =~? '[]>)}]' || getline('.')[col('.')-1] =~? '[''"`]' && synIDattr(synID(line("."), col(".")+1, 1), "name") !~? 'string'
"moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
" this one is commented because i use this for ultisnips
" inoremap <C-j> <esc>:m .+1<CR>==
" inoremap <C-k> <esc>:m .-2<CR>==
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==

"asdf
function! BreakHere()
  s/^\(\s*\)\(.\{-}\)\(\s*\)\(\%#\)\(\s*\)\(.*\)/\1\2\r\1\4\6
  call histdel("/", -1)
endfunction

nnoremap <leader>b :<C-u>call BreakHere()<CR>

nnoremap <esc> <esc>
"close inactive buffers
function! DeleteInactiveBufs()
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    "Below originally inspired by Hara Krishna Dara and Keith Roberts
    "http://tech.groups.yahoo.com/group/vim/message/56425
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! Bdi :call DeleteInactiveBufs()
command! GitFileHistory :Gclog -- %
command! BufferCloseInactive :call DeleteInactiveBufs()

"jump between errors
nnoremap [l :lprev<CR>
nnoremap ]l :lnext<CR>
" nnoremap <leader>e :lnext<CR>

"remap insert mode alt key and arrow keys
inoremap <M-h> <Left>
inoremap <M-j> <Down>
inoremap <M-k> <Up>
inoremap <M-l> <Right>

"Specter KeyMaps
nnoremap <leader>S :lua require('spectre').open()<CR>

"search current word
nnoremap <leader>sw :lua require('spectre').open_visual({select_word=true})<CR>
vnoremap <leader>s :lua require('spectre').open_visual()<CR>
"  search in current file
nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>


" save yank history to registers 1-9
function! SaveLastReg()
    if v:event['regname']==""
        if v:event['operator']=='y'
            for i in range(8,1,-1)
                exe "let @".string(i+1)." = @". string(i)
            endfor
            if exists("g:last_yank")
                let @1=g:last_yank
            endif
            let g:last_yank=@"
        endif
    endif
endfunction

:autocmd TextYankPost * call SaveLastReg()
"jump between git hunks with git gutter
" nnoremap <silent> <cr> :GitGutterNextHunk<cr>
" nnoremap <silent> <backspace> :GitGutterPrevHunk<cr>
" remap moving in splits in normal modes to ctrl
" nmap <silent> <c-k> :wincmd k<CR>
" nmap <silent> <c-j> :wincmd j<CR>
" nmap <silent> <c-h> :wincmd h<CR>
" nmap <silent> <c-l> :wincmd l<CR>

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" ale wants this before Plugins
" let g:ale_disable_lsp = 1


call plug#begin('~/.config/nvim/plugged')

Plug 'Pocco81/true-zen.nvim'
Plug 'ktunprasert/gui-font-resize.nvim'
Plug 'dkprice/vim-easygrep'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'kdheepak/lazygit.nvim'
Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'windwp/nvim-ts-autotag'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'Wansmer/treesj'
Plug 'ThePrimeagen/refactoring.nvim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'tpope/vim-surround'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'tommcdo/vim-exchange'
"Languages
Plug 'jiangmiao/auto-pairs'
Plug 'iloginow/vim-stylus'
Plug 'terrortylor/nvim-comment'
Plug 'rktjmp/lush.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'shaunsingh/solarized.nvim'
Plug 'kdheepak/monochrome.nvim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'rebelot/kanagawa.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'machakann/vim-highlightedyank'
Plug 'hoob3rt/lualine.nvim'
" Plug 'ldelossa/buffertag'
" Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-repeat'
Plug 'ggandor/lightspeed.nvim'
Plug 'godlygeek/tabular'
Plug 'preservim/tagbar'
" Plug 'Yggdroot/indentLine'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'tpope/vim-abolish'
Plug 'phaazon/hop.nvim'
Plug 'vim-scripts/loremipsum'
Plug 'wesQ3/vim-windowswap'
Plug 'mildred/vim-bufmru'
" Plug 'zefei/vim-wintabs' "This plugin allows per window management of buffers
Plug 'akinsho/nvim-bufferline.lua'
Plug 'unblevable/quick-scope'
" Debugger Plugins
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'
Plug 'eliba2/vim-node-inspect'
Plug 'kyazdani42/nvim-web-devicons'
"UltiSnips
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
" Plug 'rafamadriz/friendly-snippets'
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'
" Telescope things
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'akinsho/flutter-tools.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'tami5/sql.nvim'
Plug 'nvim-telescope/telescope-frecency.nvim'
" Plug 'fhill2/telescope-ultisnips.nvim'
Plug 'nvim-telescope/telescope-project.nvim'
Plug 'lewis6991/gitsigns.nvim'
" nvim lsp stuff
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'tami5/lspsaga.nvim'
Plug 'simrat39/symbols-outline.nvim'
Plug 'liuchengxu/vista.vim'
Plug 'folke/trouble.nvim'
Plug 'ray-x/go.nvim'
Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }
Plug 'ray-x/navigator.lua'
"Close buffers
Plug 'kazhala/close-buffers.nvim'
Plug 'norcalli/nvim-colorizer.lua'
" Search and replace in multiple files
Plug 'windwp/nvim-spectre'
Plug 'lukas-reineke/cmp-rg'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
" Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'f3fora/cmp-spell'
" Plugins for dbs
Plug 'thibthib18/mongo-nvim'
" Plug 'dbmrq/vim-dialect'
Plug 'ziontee113/color-picker.nvim'
" markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

Plug 'inkarkat/vim-ReplaceWithRegister'

Plug 'MunifTanjim/nui.nvim'
" Plug 'VonHeikemen/searchbox.nvim'

"vim faker
Plug 'https://github.com/khornberg/vim-faker'
call plug#end()
let g:indentLine_char_list = ['┊']
"
" Your .vimrc
highlight QuickScopePrimary guifg='#aaaaaa' gui=underline ctermfg=20 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
"session manager thingy
let g:autoload_last_session=v:false
"Wilder options
" call wilder#enable_cmdline_enter()
" set wildcharm=<Tab>
" cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
" cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"

"lightspeed thingies
nmap s <Plug>Lightspeed_s
nmap S <Plug>Lightspeed_S
nmap <expr> f reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_f" : "f"
nmap <expr> F reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_F" : "F"
nmap <expr> t reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_t" : "t"
nmap <expr> T reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_T" : "T"
"
"Lsp saga stuff
nnoremap <silent> gh :Lspsaga lsp_finder<CR>
nnoremap <silent><leader>ca :Lspsaga code_action<CR>
vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>
nnoremap <silent><C-k> :Lspsaga hover_doc<CR>
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
nnoremap <silent> <C-g> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
nnoremap <silent> gs :Lspsaga signature_help<CR>
nnoremap <silent>gR :Lspsaga rename<CR>
nnoremap <silent> gd :Lspsaga preview_definition<CR>
nnoremap <silent><leader>cd <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>
nnoremap <silent> <leader>cd :Lspsaga show_line_diagnostics<CR>
nnoremap <silent><leader>cc <cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>
nnoremap <silent> [e :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> ]e :Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent><leader>e :Lspsaga show_line_diagnostics<CR>
nnoremap <silent> <leader>cd :Lspsaga show_line_diagnostics<CR>
"
" supposed to make faster but is annoying
" let g:cursorhold_updatetime = 2000

" let g:fern#renderer = "devicons"



fun! GotoWindow(id)
    call win_gotoid(a:id)
    MaximizerToggle
endfun

" Debugger remaps
nnoremap <leader>m :MaximizerToggle!<CR>
nnoremap <leader>dd :call vimspector#Launch()<CR>
nnoremap <leader>dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
nnoremap <leader>dt :call GotoWindow(g:vimspector_session_windows.tagpage)<CR>
nnoremap <leader>dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
nnoremap <leader>dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
nnoremap <leader>ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
nnoremap <leader>do :call GotoWindow(g:vimspector_session_windows.output)<CR>
nmap <leader>di <Plug>VimspectorBalloonEval
nnoremap <leader>de :call vimspector#Reset()<CR>

nnoremap <leader>dtcb :call vimspector#CleanLineBreakpoint()<CR>

nmap <leader>dl <Plug>VimspectorStepInto
nmap <leader>dj <Plug>VimspectorStepOver
nmap <leader>dk <Plug>VimspectorStepOut
nmap <leader>d_ <Plug>VimspectorRestart
nnoremap <leader>d<space> :call vimspector#Continue()<CR>

nmap <leader>drc <Plug>VimspectorRunToCursor
nmap <leader>dbp <Plug>VimspectorToggleBreakpoint
nmap <leader>dcbp <Plug>VimspectorToggleConditionalBreakpoint

" <Plug>VimspectorStop
" <Plug>VimspectorPause
" <Plug>VimspectorAddFunctionBreakpoint

let g:peekaboo_window = "bel bo 32new"
"highlightedyank
let g:highlightedyank_highlight_duration = -1
nmap <C-s> :w<CR>

" let g:floaterm_width = 0.9
" let g:floaterm_height = 0.8

" Move to word
map  <Leader>w :HopWordAC<CR>
map <Leader>W :HopWordBC<CR>
"

noremap cc S
noremap cl s

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

let g:lazygit_floating_window_corner_chars = ['┌', '┐', '└', '┘'] " customize lazygit popup window corner characters

nnoremap   <silent>   <F12>   :FloatermToggle<CR>
tnoremap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR>
" nnoremap   <silent>   <F8>   :FloatermNew lazygit<CR>
nnoremap   <silent>   <F8>   :LazyGit<CR>
" tnoremap   <silent>   <F8>   <C-\><C-n>:FloatermToggle<CR>
nnoremap   <silent>   <F7>   :Ag<CR>
nnoremap   <silent>   <F7>   :Ag<CR>
vnoremap    <expr>   <F7>Get_visual_selection()<CR>
tnoremap   <silent>   <F7>   :FloatermToggle<CR>

nnoremap <space>n :noh<CR>

" fzf window settings
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

let g:vim_be_good_floating = 1
nmap <F2> :TagbarToggle<CR>


let g:wintabs_display='statusline'

" colorscheme options
set background=dark

colorscheme gruvbox
highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4

if executable('rg')
    let g:rg_derive_root='true'
endif

let loaded_matchparen = 1

nnoremap L $
nnoremap H ^
vnoremap L $
vnoremap H ^
nnoremap Y y$
nnoremap gH H
nnoremap gL L

" map to
" nnoremap <silent> j gj
" nnoremap <silent> k gk
" nnoremap <silent> $ g$
" nnoremap <silent> 0 g0
" onoremap gj j
" onoremap gk k
" onoremap j j
" onoremap k k


let g:netrw_browse_split = 2
let g:vrfr_rg = 'true'
let g:netrw_banner = 0
let g:netrw_winsize = 25

"working with split windows
nnoremap <M-j> <C-W><C-j>
nnoremap <M-k> <C-W><C-k>
nnoremap <M-l> <C-W><C-l>
nnoremap <M-h> <C-W><C-h>
"insert mode arrow keys with hjkland alt

set clipboard=unnamed,unnamedplus
" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

"#region completion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" let g:completion_enable_snippet = 'UltiSnips'
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
"#endregion completion
"
"LuaSnip
"" press <Tab> to expand or jump in a snippet. These can also be mapped separately
" via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
imap <silent><expr> <C-l> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<C-l>'
" -1 for jumping backwards.
inoremap <silent> <C-h> <cmd>lua require'luasnip'.jump(-1)<Cr>

snoremap <silent> <C-l> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <C-h> <cmd>lua require('luasnip').jump(-1)<Cr>
" For changing choices in choiceNodes (not strictly necessary for a basic setup).
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
command! LuaSnipEdit :lua require("luasnip.loaders").edit_snippet_files()
"LuaSnip
" List available databases
nnoremap <leader>dbl <cmd>lua require('mongo-nvim.telescope.pickers').database_picker()<cr>
" List collections in database (arg: database name)
nnoremap <leader>dbcl <cmd>lua require('mongo-nvim.telescope.pickers').collection_picker('examples')<cr>
" List documents in a database's collection (arg: database name, collection name)
nnoremap <leader>dbdl <cmd>lua require('mongo-nvim.telescope.pickers').document_picker('examples', 'movies')<cr>

" Avoid showing message extra message when using completion
set shortmess+=c

vmap > >gv
vmap < <gv
" reselect pasted text
nnoremap gp `[v`]

" inoremap <silent><expr> <CR>      compe#confirm('<C-l>')











































lua << EOF
require('treesj').setup({
  max_join_length = 500,
})
require'hop'.setup { }
require("true-zen").setup {
		-- your config goes here
		-- or just leave it empty :)
}
require('nvim-ts-autotag').setup()
local luasnip = require("luasnip")
require("luasnip.loaders.from_lua").lazy_load({paths = "~/snippets/lua/"})

-- require("luasnip.loaders.from_vscode").lazy_load()
-- require('buffertag').enable()

require("gui-font-resize").setup({ default_size = 10, change_by = 1, bounds = { maximum = 20 } })
local fontsizeChangeOpts = { noremap = true, silent = true }
vim.keymap.set("n", "<A-Up>", "<cmd>:GUIFontSizeUp<CR>", fontsizeChangeOpts)
vim.keymap.set("n", "<A-Down>", "<cmd>:GUIFontSizeDown<CR>", fontsizeChangeOpts)
vim.keymap.set("n", "<A-0>", "<cmd>:GUIFontSizeSet<CR>", fontsizeChangeOpts)

require("bufferline").setup{}

require('go').setup()
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)

require("color-picker")
local colorPickerOptions = { noremap = true, silent = true }
vim.keymap.set("n", "<C-c>", "<cmd>PickColor<cr>", colorPickerOptions)

require("flutter-tools").setup{
  widget_guides = {
    enabled = true,
  },
}
require("neo-tree").setup({
  filesystem = {
    window = {
      mappings = {
        ["F"] = "filter_as_you_type",
        ["/"] = "none",
        ["w"] = "open",
      }
    }
  },
})
require('gitsigns').setup()
vim.cmd([[nnoremap \ :NeoTreeFloat<cr>]])
require 'trouble'.setup {}
local saga = require 'lspsaga'
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  float = {border = "single"},
})
saga.init_lsp_saga{
 use_saga_diagnostic_sign = true,
 error_sign = '☠',
 warn_sign = '⚠',
 hint_sign = '⎇',
 infor_sign = '🛈',
 diagnostic_header_icon = '   ',
 code_action_icon = ' ',
 code_action_prompt = {
   enable = true,
   sign = true,
   sign_priority = 20,
   virtual_text = true,
 },
 finder_definition_icon = '  ',
 finder_reference_icon = '  ',
 max_preview_lines = 10, -- preview lines of lsp_finder and definition preview
 finder_action_keys = {
   open = 'o', vsplit = 's',split = 'i',quit = 'q',scroll_down = '<C-f>', scroll_up = '<C-g>' -- quit can be a table
   },
 code_action_keys = {
   quit = 'q',exec = '<CR>'
   },
 rename_action_keys = {
   quit = '<C-c>',exec = '<CR>'  -- quit can be a table
   },
 definition_preview_icon = '  ',
 border_style = "single",
 rename_prompt_prefix = '➤',
}

require 'colorizer'.setup()
require('nvim_comment').setup()
require 'mongo-nvim'.setup {
  -- connection string to your mongodb
  connection_string = "mongodb://127.0.0.1:27017",
  -- key to use for previewing/picking documents
  list_document_key = "title"
}
require"telescope".load_extension("frecency")
-- require('telescope').load_extension('ultisnips')
require'telescope'.load_extension('project')
--require('telescope').load_extension('session_manager')
require('telescope').setup {
  defaults ={
    file_ignore_patterns = {'.png', '.jpeg', '.svg', '.jpg', 'tags', 'pdf'},
    borderchars = {"─", "│", "─", "│", "┌", "┐", "┘", "└"},
    layout_strategy = "vertical",
    layout_config = {
      vertical = {
        preview_height = 0.7,
      },
    },
    extensions = {
      frecency = {
        workspaces = {
          ["config"] = '/home/shaffaaf/.config/nvim',
          ["pcui"] = '/home/shaffaaf/Code/office/primecareui',
          ["feyraan"] = '/home/shaffaaf/Code/coconet/ClothStore',
          ["feyraanui"] = '/home/shaffaaf/Code/coconet/ClothStore/ClientApp',
        }
      },
      project = {
        base_dirs = {
          { path = '~/Code/coconet', max_depth = 3 },
        },
      }
    },
  }
}
require('lualine').setup {
  options = {
    theme = 'gruvbox',
    globalstatus = false,
  },
  sections = {
  lualine_a = {'mode'},
  lualine_b = {'branch', 'diff', 'diagnostics'},
  lualine_c = {
    {
    'filename',
    path = 1
      }
  },
  lualine_x = {'encoding', 'fileformat', 'filetype'},
  lualine_y = {'progress'},
  lualine_z = {'location'}
  },
inactive_sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = {
    {

    'filename',
    path = 1
      }
  },
  lualine_x = {'location'},
  lualine_y = {},
  lualine_z = {}
  },
}

local on_attach = function(client, bufnr)
  require'lsp_signature'.on_attach()
  require'lspsaga'.on_attach()
  require'nvim-cmp'.on_attach()
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

   buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
   buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
      buf_set_keymap("n", "<leader>lf",
                     "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
      buf_set_keymap("n", "<leader>lf",
                     "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
      vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
      autocmd! * <buffer>
      augroup END
      ]], false)
  end
end

local nvim_lsp = require('lspconfig')

local pid = vim.fn.getpid()
vim.o.completeopt = "menuone,noselect"

-- require"cmp_nvim_ultisnips".setup {
  -- show_snippets = "all",
-- }

local cmp = require'cmp'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-l>'] = cmp.mapping.confirm(),
    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm(),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'luasnip' },
    { name = 'rg' },
    --{ name = 'spell' },
  }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())


require'lspconfig'.dartls.setup{
  capabilities = capabilities,
  cmd = { "dart", "/opt/dart-sdk/bin/snapshots/analysis_server.dart.snapshot", "--lsp" },
  filetypes = { "dart" }
}
local pid = vim.fn.getpid()


-- require'lspconfig'.csharp_ls.setup{}
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
  local opts = {
    capabilities = capabilities
  }

  -- (optional) Customize the options passed to the server
  -- if server.name == "tsserver" then
  --     opts.root_dir = function() ... end
  -- end

  -- This setup() function is exactly the same as lspconfig's setup function.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(opts)
end)

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

vim.g.symbols_outline = {
    highlight_hovered_item = true,
    show_guides = true,
    auto_preview = true,
    position = 'right',
    show_numbers = false,
    show_relative_numbers = false,
    show_symbol_details = true,
    keymaps = {
        close = "<Esc>",
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        rename_symbol = "r",
        code_actions = "a",
    },
    lsp_blacklist = {},
}


EOF

nmap <Leader>s :Telescope lsp_document_symbols<CR>

" nmap <leader>b :Buffers<CR>
nmap <C-b> :Buffers<CR>
" nmap <leader> :Buffers<CR>
nnoremap <Leader>fl :Telescope current_buffer_fuzzy_find<cr>
" nmap <leader>fl :BLines<CR>
" nmap <leader>ff :Ag<CR>
map <leader>ff :Telescope find_files<CR>
map <leader>fg :Bclose<CR>:Telescope find_files<CR>
nmap <leader>fw :Telescope live_grep<CR>
nmap <leader>fb :Telescope buffers<CR>
nmap <leader>fr :Telescope frecency<CR>
nmap <leader>fp :Telescope project<CR>
nmap <leader>fe :Telescope diagnostics bufnr=0<CR>
nmap <leader>fE :Telescope diagnostics<CR>
" nmap <leader>fp :Files<CR>
nmap <leader>ft :BTags<CR>
" nmap <leader>fr :Tags<CR>
" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" nnoremap <leader>h :wincmd h<CR>
" nnoremap <leader>j :wincmd j<CR>
" nnoremap <leader>k :wincmd k<CR>
" nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>l :HopLine<CR>

nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <Leader>ps :Rg<CR>
" nnoremap <C-p> :GFiles --exclude-standard --others --cached<CR>
" add below to fish config
" set -Ux FZF_DEFAULT_COMMAND 'fd --type f'
nnoremap <C-p> :Files<CR>
nnoremap <C-y> :Buffers<CR>
nnoremap <Leader>pf :Files<CR>
nnoremap <Leader>so :so ~/.config/nvim/init.vim<CR>
nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>
nnoremap <Leader>0 :resize +5<CR>
nnoremap <Leader>9 :resize -5<CR>
" nnoremap <Leader>ee oif err != nil {<CR>log.Fatalf("%+v\n", err)<CR>}<CR><esc>kkI<esc>
" nnoremap <C-b> :Buffers<CR>
" Vim with me
" nnoremap <leader>vwm :colorscheme gruvbox<bar>:set background=dark<CR>
" nmap <leader>vtm :highlight Pmenu ctermbg=gray guibg=gray
" 0th hole register
nnoremap d "dd
nnoremap dd "ddd
nnoremap D "dD
vnoremap d "dd
vnoremap dd "ddd

nnoremap c "cc
vnoremap c "cc

nnoremap x d
vnoremap x d
nnoremap xx dd
vnoremap xx dd
nnoremap X D

inoremap <C-c> <esc>

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction



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

" Yank file name from buffer
noremap ydp :let @+=expand("%:p")<CR>

" List available databases
nnoremap <leader>dbl <cmd>lua require('mongo-nvim.telescope.pickers').database_picker()<cr>
" List collections in database (arg: database name)
nnoremap <leader>dbcl <cmd>lua require('mongo-nvim.telescope.pickers').collection_picker('examples')<cr>
" List documents in a database's collection (arg: database name, collection name)
nnoremap <leader>dbdl <cmd>lua require('mongo-nvim.telescope.pickers').document_picker('examples', 'movies')<cr>
" Tab and Shift-Tab in normal mode to navigate buffers
:nmap <Tab> :BufMRUNext<CR>
:nmap <S-Tab> :BufMRUPrev<CR>
:nmap <C-Tab> :tabNext<CR>
"
" Define mappings
let g:AutoPairsShortcutToggle = ''
" let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutBackInsert = '<M-b>'

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
nnoremap <silent> <Leader>qq :q!<CR>

"Tabularize
autocmd VimEnter * :AddTabularPattern object /^.\{-}:/l0
autocmd VimEnter * :AddTabularPattern charAfterComma /,\zs/l0
autocmd VimEnter * :AddTabularPattern charAfterCommaSpace /, \zs/l0

autocmd BufWritePre * :call TrimWhitespace()

" if !exists("g:GuiLoaded")
"   au ColorScheme * hi Normal ctermbg=none guibg=none
"   au ColorScheme myspecialcolors hi Normal ctermbg=red guibg=red
" endif

if exists("g:GuiLoaded")
  set guifont=Agave\ NF:h9
endif


if exists('g:gnvim_runtime_loaded')
    set guifont=agave:h9
endif
if exists('g:gnvim')
    " GNvim-specific configuration goes here
    set guifont=agave:h10
endif


lua << EOF
local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

 --parser_configs.vue.install_info.url = "https://github.com/zealot128/tree-sitter-vue.git"
 --
 --parser_configs.pug = {
    --install_info = {
       --url = "https://github.com/zealot128/tree-sitter-pug", -- local path or git repo
       ---- url = "/Users/stefan/LocalProjects/tree-sitter-pug",
       --files = { "src/parser.c", "src/scanner.cc" },
    --},
    --filetype = "pug", -- if filetype does not agrees with parser name
 --}


-- parser_configs.norg = {
  -- install_info = {
      -- url = "https://github.com/vhyrro/tree-sitter-norg",
      -- files = { "src/parser.c", "src/scanner.cc" },
      -- branch = "main"
  -- },
-- }

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  incremental_selection = {
    enable = true,
    disable = {},
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true,
    -- disable = {"vue", "pug", "dartls"},
  },
}

local ft_to_parser = require"nvim-treesitter.parsers".filetype_to_parsername
ft_to_parser.cshtml = "html"
--print('Hello from lua')


 -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
   -- vim.lsp.diagnostic.on_publish_diagnostics, {
     -- update_in_insert = false,
   -- }
 -- )

EOF


if exists('g:neoman')
  set guifont=Delugia:h9
  let neoman_cursor_animation_time=0.1
  let neoman_popup_menu_enabled=0
  let neoman_window_startup_state='centered'
  let neoman_key_toggle_fullscreen='<M-C-CR>' " AltGr+Enter
  let neoman_key_increase_fontsize='<C-PageUp>'
  let neoman_key_decrease_fontsize='<C-PageDown>'
  autocmd vimenter * hi Normal guibg=#212121 ctermbg=NONE
  autocmd vimenter * hi EndOfBuffer guibg=NONE ctermbg=NONE
endif

if exists('g:nvui')
  set guifont=Delugia:h9
  autocmd vimenter * hi Normal guibg=#212121 ctermbg=NONE
  autocmd vimenter * hi EndOfBuffer guibg=NONE ctermbg=NONE
  :NvuiFrameless v:false
  :NvuiCmdCenterYPos 0.5
  :NvuiCmdFontSize 12
  :NvuiCmdFontFamily Delugia
  :NvuiCmdBigFontScaleFactor 1.2
  :NvuiCmdPadding 10
endif

if exists('g:fvim_loaded')
    " good old 'set guifont' compatibility with HiDPI hints...
    set guifont=Delugia:h12
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
    nnoremap <A-CR> :FVimToggleFullScreen<CR>
    FVimCursorSmoothMove v:true
    FVimCursorSmoothBlink v:true
endif


if exists('g:neoray')
  set guifont=Delugia:h9.5
  NeoraySet CursorAnimTime 0.05
  NeoraySet Transparency   1
  NeoraySet KeyZoomIn      <C-ScrollWheelUp>
  NeoraySet KeyZoomOut     <C-ScrollWheelDown>
endif
