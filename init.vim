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
augroup END

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

set hlsearch
set hidden
set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set autoindent
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
" set foldmethod=expr
" set foldexpr=nvim_treeparser#foldexpr()
set nofoldenable
set wrap
set linebreak
set breakat=,^I
set autoread
set inccommand=split
set mousefocus
set breakindent
set showbreak=\ \\_
set updatetime=300
set exrc
set secure
set number
set nospell spelllang=en_us
set splitbelow
set splitright

" :nmap <leader>e :NERDTreeToggle<CR>
" :nmap <leader>e :NvimTreeToggle<CR>
:nmap <leader>e :CHADopen<CR>
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

"jumplist mutations
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

"move to next desired location
inoremap <silent> jj <c-o>:call search('}\\|)\\|]\\|>', 'cW')<cr><Right>
imap ;; <Esc>A;<Esc>
imap ,, <Esc>A,<Esc>
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
command! BufferCloseInactive :call DeleteInactiveBufs()

"jump between errors
nnoremap [l :lprev<CR>
nnoremap ]l :lnext<CR>

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

" let g:polyglot_disabled = [ 'markdown','c_sharp', 'cs', 'ts', 'typescript', 'javascript', 'js', 'vim', 'lua', 'pug']

call plug#begin('~/.config/nvim/plugged')

Plug 'dkprice/vim-easygrep'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'kdheepak/lazygit.nvim'
Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
" Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'ThePrimeagen/refactoring.nvim'
" Plug 'dyng/ctrlsf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Plug 'Shougo/neoyank.vim'
" Plug 'justinhoward/fzf-neoyank'
" Plug 'voldikss/vim-floaterm'
Plug 'junegunn/vim-peekaboo'
Plug 'tpope/vim-surround'
" Plug 'preservim/nerdtree'
Plug 'ms-jpq/chadtree'
Plug 'tommcdo/vim-exchange'
"Languages
" Plug 'rust-lang/rust.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'iloginow/vim-stylus'
Plug 'tpope/vim-commentary'
"  I AM SO SORRY FOR DOING COLOR SCHEMES IN MY VIMRC, BUT I HAVE
"  TOOOOOOOOOOOOO
" Plug 'gruvbox-community/gruvbox'
" Plug 'sainnhe/gruvbox-material'
" Plug 'rktjmp/lush.nvim'
" Plug 'npxbr/gruvbox.nvim'
" Plug 'Murtaza-Udaipurwala/gruvqueen'
Plug 'rktjmp/lush.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'ryanoasis/vim-devicons'
" Plug 'pacha/vem-tabline'
Plug 'machakann/vim-highlightedyank'
" Plug 'phanviet/vim-monokai-pro'
Plug 'hoob3rt/lualine.nvim'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
" Plug 'flazz/vim-colorschemes'
"Plug 'majutsushi/tagbar'
Plug 'tpope/vim-repeat'
" Plug 'svermeulen/vim-easyclip'
" Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'easymotion/vim-easymotion'
" Plug 'justinmk/vim-sneak'
" Plug 'rhysd/clever-f.vim'
" Plug 'hushicai/tagbar-javascript.vim'
" Plug 'maxbrunsfeld/vim-yankstack'
Plug 'ggandor/lightspeed.nvim'
Plug 'godlygeek/tabular'
Plug 'preservim/tagbar'
" Plug 'Yggdroot/indentLine'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'tpope/vim-abolish'
Plug 'posva/vim-vue'
" Plug 'yuttie/comfortable-motion.vim'
Plug 'phaazon/hop.nvim'
Plug 'vim-scripts/loremipsum'
Plug 'wesQ3/vim-windowswap'
" Plug 'weynhamz/vim-plugin-minibufexpl'
Plug 'mildred/vim-bufmru'
" Plug 'zefei/vim-wintabs' "This plugin allows per window management of buffers
Plug 'akinsho/nvim-bufferline.lua'
Plug 'unblevable/quick-scope'
" Plug 'Shatur/neovim-session-manager'
" Debugger Plugins
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'
Plug 'eliba2/vim-node-inspect'
Plug 'kyazdani42/nvim-web-devicons'
" Plug 'kyazdani42/nvim-tree.lua'
" Plug 'romgrk/barbar.nvim'
"
"
"
" fern things
" Plug 'antoinemadec/FixCursorHold.nvim'
" Plug 'lambdalisue/fern.vim'
" Plug 'lambdalisue/fern-renderer-devicons.vim'
" Plug 'lambdalisue/fern-hijack.vim'
" Plug 'LumaKernel/fern-mapping-fzf.vim'

" Plug 'nathanaelkane/vim-indent-guides'
" Plug 'codota/tabnine-vim'
"
"UltiSnips
Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'
" Telescope things
"
" Plug 'kamykn/spelunker.vim'
" Plug 'kamykn/popup-menu.nvim'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'tami5/sql.nvim'
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'fhill2/telescope-ultisnips.nvim'
Plug 'nvim-telescope/telescope-project.nvim'
" nvim lsp stuff
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
" Plug 'nvim-lua/completion-nvim'
" Plug 'nvim-treesitter/completion-treesitter'
" Plug 'steelsojka/completion-buffers'
" Plug 'RishabhRD/popfix'
" Plug 'RishabhRD/nvim-lsputils'
" Plug 'hrsh7th/nvim-compe'
Plug 'simrat39/symbols-outline.nvim'
Plug 'ray-x/lsp_signature.nvim'

"Close buffers
Plug 'kazhala/close-buffers.nvim'
" Plug 'gelguy/wilder.nvim'
"
" Search and replace in multiple files
Plug 'windwp/nvim-spectre'
Plug 'vhyrro/neorg', { 'branch': 'unstable' } | Plug 'nvim-lua/plenary.nvim'
" Plug 'kdheepak/tabline.nvim'
Plug 'lukas-reineke/cmp-rg'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'f3fora/cmp-spell'

" Plugins for dbs
" https://github.com/thibthib18/mongo-nvim
Plug 'thibthib18/mongo-nvim'

" Plug 'dbmrq/vim-dialect'
" markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

Plug 'inkarkat/vim-ReplaceWithRegister'

" augroup qs_colors
"   autocmd!
"   autocmd ColorScheme * highlight QuickScopePrimary guifg='#A02000' gui=underline ctermfg=155 cterm=underline
"   autocmd ColorScheme * highlight QuickScopeSecondary guifg='#0000FF' gui=underline ctermfg=81 cterm=underline
" augroup END

" Your .vimrc
highlight QuickScopePrimary guifg='#aaaaaa' gui=underline ctermfg=20 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline

"vim faker
Plug 'https://github.com/khornberg/vim-faker'
call plug#end()
let g:indentLine_char_list = ['┊']
"
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
" " only / and ? are enabled by default
" call wilder#set_option('modes', ['/', '?', ':'])
" call wilder#set_option('pipeline', [
"       \   wilder#branch(
"       \     wilder#python_file_finder_pipeline({
"       \       'file_command': ['find', '.', '-type', 'f', '-printf', '%P\n'],
"       \       'dir_command': ['find', '.', '-type', 'd', '-printf', '%P\n'],
"       \       'filters': ['fuzzy_filter', 'difflib_sorter'],
"       \     }),
"       \     wilder#cmdline_pipeline(),
"       \     wilder#python_search_pipeline(),
"       \   ),
"       \ ])

" LSP config (the mappings used in the default file don't quite work right)
"
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gR <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gI <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> <F1> <cmd>lua vim.lsp.buf.signature_help()  <CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

nnoremap <silent> <leader>fu <cmd>Telescope lsp_references<cr>
nnoremap <silent> <leader>gd <cmd>Telescope lsp_definitions<cr>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<cr>
nnoremap <silent> <leader>xd <cmd>Telescope lsp_document_diagnostics<cr>
nnoremap <silent> <leader>xD <cmd>Telescope lsp_workspace_diagnostics<cr>
nnoremap <silent> <leader>xn <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
nnoremap <silent> <leader>xp <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
nnoremap <silent> <leader>xx <cmd>Telescope lsp_code_actions<cr>
nnoremap <silent> <leader>xX <cmd>%Telescope lsp_range_code_actions<cr>
" autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
" autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()


" let g:indent_guides_enable_on_vim_startup = 1
" let g:indent_guides_start_level = 1
" let g:indent_guides_guide_size = 1


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
"confortable scroll
" if(has("gui_running")==0 && exists("g:GuiLoaded") ==0)
"     let g:comfortable_motion_scroll_down_key = "j"
"     let g:comfortable_motion_scroll_up_key = "k"
"     noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
"     noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<CR>
" endif
"autosave
" autocmd CursorHold * update
nmap <C-s> :w<CR>

" let g:floaterm_width = 0.9
" let g:floaterm_height = 0.8

" <Leader>f{char} to move to {char}
" map  <Leader>f <Plug>(easymotion-bd-f)
" nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
" nmap s <Plug>(easymotion-overwin-f2)
" nnoremap <Leader>s <Plug>Sneak_s
" nnoremap <Leader>S <Plug>Sneak_S

" nnoremap cs S
" Move to line
" map <Leader>L <Plug>(easymotion-bd-jk)
" nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w :HopWordAC<CR>
map <Leader>W :HopWordBC<CR>
"
"icons
" let g:vem_tabline_show_icon = 0
"
"bufferline barbar
" let bufferline = get(g:, 'bufferline', {})


nmap cc gcc

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
"easyclip rempaps m to cut so here remapping gm to do m or mark
" nnoremap gm m
let g:vue_pre_processors = 'detect_on_enter'

nnoremap <space>n :noh<CR>
"omnisharp options
" let g:OmniSharp_server_stdio = 1
" let g:OmniSharp_start_without_solution = 1

" fzf window settings
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }
"airline setting
" let g:airline#extensions#tabline#enabled = 0
" let g:airline_theme='base16_gruvbox_dark_hard'

" let g:gruvbox_contrast_dark = 'hard'
" --- The Greatest plugin of all time.  I am not bias
let g:vim_be_good_floating = 1
nmap <F2> :TagbarToggle<CR>


" --- vim go (polyglot) settings.
" let g:go_highlight_build_constraints = 1
" let g:go_highlight_extra_types = 1
" let g:go_highlight_fields = 1
" let g:go_highlight_functions = 1
" let g:go_highlight_methods = 1
" let g:go_highlight_operators = 1
" let g:go_highlight_structs = 1
" let g:go_highlight_types = 1
" let g:go_highlight_function_parameters = 1
" let g:go_highlight_function_calls = 1
" let g:go_highlight_generate_tags = 1
" let g:go_highlight_format_strings = 1
" let g:go_highlight_variable_declarations = 1
" let g:go_auto_sameids = 1

" let g:neoyank#save_registers = ['+','*']

let g:wintabs_display='statusline'

" colorscheme options
let g:gruvqueen_transparent_background = v:true
" let g:gruvqueen_background_color = '#3b3b3b'
let g:gruvqueen_italic_comments = v:true
let g:gruvqueen_italic_keywords = v:true
let g:gruvqueen_italic_functions = v:true
let g:gruvqueen_italic_variables = v:true
let g:gruvqueen_invert_selection = v:true
let g:gruvqueen_style = 'original'
set background=dark

colorscheme gruvbox

if executable('rg')
    let g:rg_derive_root='true'
endif

let loaded_matchparen = 1

nnoremap L $
nnoremap H ^
vnoremap L $
vnoremap H ^
nnoremap Y y$

" map to
" nnoremap <silent> j gj
" nnoremap <silent> k gk
" nnoremap <silent> $ g$
" nnoremap <silent> 0 g0
" onoremap gj j
" onoremap gk k
" onoremap j j
" onoremap k k

" map f <Plug>Sneak_s
" map F <Plug>Sneak_S

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
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
"#endregion completion
"
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
require 'mongo-nvim'.setup {
  -- connection string to your mongodb
  connection_string = "mongodb://127.0.0.1:27017",
  -- key to use for previewing/picking documents
  list_document_key = "title"
}
require"telescope".load_extension("frecency")
require('telescope').load_extension('ultisnips')
require'telescope'.load_extension('project')
--require('telescope').load_extension('session_manager')
require('telescope').setup {
  defaults ={
    file_ignore_patterns = {'.png', '.jpeg', '.svg', '.jpg', 'tags', 'pdf'},
    borderchars = {"─", "│", "─", "│", "┌", "┐", "┘", "└"},
    layout_strategy = "vertical",
    layout_config = {
      vertical = {
        preview_height = 50,
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
vim.api.nvim_set_keymap(
    'n',
    '<F1>',
    ":lua require'telescope'.extensions.project.project{}<CR>",
    {noremap = true, silent = true}
)
require('lualine').setup {
  options = {theme = 'gruvbox'}
}
require("bufferline").setup{}

local on_attach = function(client, bufnr)
  --require'lsp_signature'.on_attach()
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
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
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]], false)
  end
end

local nvim_lsp = require('lspconfig')

local pid = vim.fn.getpid()
-- On linux/darwin if using a release build, otherwise under scripts/OmniSharp(.Core)(.cmd)
--vim.g.completion_chain_complete_list = {
  --default = {
    --{ complete_items = { 'lsp' } },
    --{ complete_items = { 'treesitter' } },
    --{ complete_items = { 'buffers' } },
    --{ mode = { '<c-p>' } },
    --{ mode = { '<c-n>' } }
  --},
--}

vim.o.completeopt = "menuone,noselect"

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
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
    { name = 'ultisnips' },
    { name = 'buffer' },
    { name = 'rg' },
    --{ name = 'spell' },
  }
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- local omnisharp_bin = "/usr/bin/omnisharp"
--
 -- require'lspconfig'.omnisharp.setup{
   -- capabilities = capabilities,
   -- cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) },
   -- -- root_dir = util.root_pattern("*.csproj", "*.sln"),
   -- require'cmp'.setup{}
 -- }

require'lspconfig'.dartls.setup{
  capabilities = capabilities,
  cmd = { "dart", "/opt/dart-sdk/bin/snapshots/analysis_server.dart.snapshot", "--lsp" },
}

require'lspinstall'.setup() -- important

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{
    capabilities = capabilities,
    on_attach = on_attach,
  }
end

 --require'lspconfig'.typescript.setup{}
 --require'lspconfig'.vue.setup{}


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

vim.g.chadtree_settings = {
  theme = {
    text_colour_set = "nerdtree_syntax_dark",
    icon_colour_set = "github",
  },
  view ={
    open_direction = "right"
    }
}

-- vim.api.nvim_set_var("chadtree_settings", chadtree_settings)

EOF

nmap <Leader>s :SymbolsOutline<CR>
" nvim bufferline stuff
" nnoremap <silent>[b :BufferLineCycleNext<CR>
" nnoremap <silent>]b :BufferLineCyclePrev<CR>

" These commands will move the current buffer backwards or forwards in the bufferline
" nnoremap <silent>{b :BufferLineMoveNext<CR>
" nnoremap <silent>}b :BufferLineMovePrev<CR>

" nnoremap <silent> gb :BufferLinePick<CR>
" nvim bufferline stuff


" nmap <leader>b :Buffers<CR>
nmap <C-b> :Buffers<CR>
" nmap <leader> :Buffers<CR>
nnoremap <Leader>fl :Telescope current_buffer_fuzzy_find<cr>
" nmap <leader>fl :BLines<CR>
" nmap <leader>ff :Ag<CR>
map <leader>ff :Telescope find_files<CR>
nmap <leader>fw :Telescope live_grep<CR>
nmap <leader>fb :Telescope buffers<CR>
nmap <leader>fr :Telescope frecency<CR>
" nmap <leader>fp :Files<CR>
nmap <leader>ft :BTags<CR>
" nmap <leader>fr :Tags<CR>
" vmap <leader>b :CocList buffers<CR>
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

" inoremap <silent><expr> <TAB>
"             \ pumvisible() ? "\<C-n>" :
"             \ <SID>check_back_space() ? "\<TAB>" :
"             \ coc#refresh()

" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" inoremap <silent><expr> <C-space> coc#refresh()

" GoTo code navigation.
" nmap <leader>gd <Plug>(coc-definition)
" nmap <leader>gy <Plug>(coc-type-definition)
" nmap <leader>gi <Plug>(coc-implementation)
" nmap <leader>gr <Plug>(coc-references)
" nmap <leader>rr <Plug>(coc-rename)
" nmap <leader>g[ <Plug>(coc-diagnostic-prev)
" nmap <leader>g] <Plug>(coc-diagnostic-next)
" nmap <silent> <leader>gp <Plug>(coc-diagnostic-prev-error)
" nmap <silent> <leader>gn <Plug>(coc-diagnostic-next-error)
nnoremap <leader>cr :CocRestart

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
" :nmap <Tab> :TablineBufferNext<CR>
" :nmap <S-Tab> :TablineBufferPrevious<CR>
" :nmap <Tab> :WintabsNext<CR>
" :nmap <S-Tab> :WintabsPrevious<CR>
"Denite mappings because of neoyank
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

parser_configs.vue.install_info.url = "https://github.com/zealot128/tree-sitter-vue.git"

parser_configs.pug = {
   install_info = {
      url = "https://github.com/zealot128/tree-sitter-pug", -- local path or git repo
      -- url = "/Users/stefan/LocalProjects/tree-sitter-pug",
      files = { "src/parser.c", "src/scanner.cc" },
   },
   filetype = "pug", -- if filetype does not agrees with parser name
}

--parser_configs.pug = {
  --install_info = {
    --url = "/home/shaffaaf/Code/ref/tree-sitter-pug", -- local path or git repo
    --files = {"src/parser.c", "src/scanner.cc" },
    --branch = "master"
  --},
  --used_by = {"jade"} -- additional filetypes that use this parser
--}

parser_configs.norg = {
  install_info = {
      url = "https://github.com/vhyrro/tree-sitter-norg",
      files = { "src/parser.c", "src/scanner.cc" },
      branch = "main"
  },
}

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

--Neorg
require'neorg'.setup {
  -- Tell Neorg what modules to load
  load = {
    ["core.defaults"] = {}, -- Load all the default modules
    ["core.norg.concealer"] = {}, -- Allows for use of icons
    ["core.norg.dirman"] = { -- Manage your directories with Neorg
      config = {
        workspaces = {
          my_workspace = "~/neorg"
        }
      }
    }
  },
}

--print('Hello from lua')

require'hop'.setup {

  }
EOF

let g:UltiSnipsExpandTrigger='<c-l>'
" shortcut to go to next position
let g:UltiSnipsJumpForwardTrigger='<c-j>'
" shortcut to go to previous position
let g:UltiSnipsJumpBackwardTrigger='<c-k>'

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
