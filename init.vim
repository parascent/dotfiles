syntax on
" :set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
" 		  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
" 		  \,sm:block-blinkwait175-blinkoff150-blinkon175
set noshowmatch
set mouse=a
set relativenumber
let mapleader = " "
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

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


" :nmap <leader>e :NERDTreeToggle<CR>
:nmap <leader>e :NvimTreeToggle<CR>
:nmap <space>r :registers<CR>
:vmap <space>r :registers<CR>
"Custom tabstops
"End Custom tabstops

let NERDTreeShowHidden=1
"Switching buffers
" :nnoremap <Tab> :bnext<CR>
" :nnoremap <S-Tab> :bprevious<CR>

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

"jump between errors
nnoremap [l :lprev<CR>
nnoremap ]l :lnext<CR>

"remap insert mode alt key and arrow keys
inoremap <M-h> <Left>
inoremap <M-j> <Down>
inoremap <M-k> <Up>
inoremap <M-l> <Right>


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

Plug 'dkprice/vim-easygrep'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'kdheepak/lazygit.nvim'
Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'dyng/ctrlsf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Plug 'justinhoward/fzf-neoyank'
Plug 'voldikss/vim-floaterm'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'ms-jpq/chadtree'
"Languages
Plug 'rust-lang/rust.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'iloginow/vim-stylus'
Plug 'tpope/vim-commentary'
"  I AM SO SORRY FOR DOING COLOR SCHEMES IN MY VIMRC, BUT I HAVE
"  TOOOOOOOOOOOOO
Plug 'gruvbox-community/gruvbox'
Plug 'sainnhe/gruvbox-material'
Plug 'ryanoasis/vim-devicons'
" Plug 'pacha/vem-tabline'
Plug 'machakann/vim-highlightedyank'
Plug 'phanviet/vim-monokai-pro'
Plug 'hoob3rt/lualine.nvim'
Plug 'airblade/vim-gitgutter'
Plug 'flazz/vim-colorschemes'
"Plug 'majutsushi/tagbar'
Plug 'tpope/vim-repeat'
Plug 'svermeulen/vim-easyclip'
Plug 'Shougo/neoyank.vim'
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
" Plug 'rhysd/clever-f.vim'
" Plug 'hushicai/tagbar-javascript.vim'
Plug 'godlygeek/tabular'
Plug 'preservim/tagbar'
Plug 'Yggdroot/indentLine'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'inkarkat/vim-ReplaceWithRegister'
Plug 'tpope/vim-abolish'
Plug 'posva/vim-vue'
" Plug 'yuttie/comfortable-motion.vim'
Plug 'phaazon/hop.nvim'
Plug 'vim-scripts/loremipsum'
Plug 'wesQ3/vim-windowswap'
" Plug 'weynhamz/vim-plugin-minibufexpl'
Plug 'mildred/vim-bufmru'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'unblevable/quick-scope'
Plug 'Shatur/neovim-session-manager'
" Debugger Plugins
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'
Plug 'eliba2/vim-node-inspect'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
" Plug 'romgrk/barbar.nvim'
" Plug 'zefei/vim-wintabs'
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
Plug 'honza/vim-snippets'
" Telescope things
"
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
Plug 'hrsh7th/nvim-compe'
Plug 'simrat39/symbols-outline.nvim'
Plug 'ray-x/lsp_signature.nvim'
call plug#end()





" LSP config (the mappings used in the default file don't quite work right)
"
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> <F1> <cmd>lua vim.lsp.buf.signature_help()  <CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
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

let g:floaterm_width = 0.9
let g:floaterm_height = 0.8

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
" nmap s <Plug>(easymotion-overwin-f2)
" nnoremap <Leader>s <Plug>Sneak_s
" nnoremap <Leader>S <Plug>Sneak_S

" nnoremap cs S
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
nnoremap gm m
let g:vue_pre_processors = 'detect_on_enter'

nnoremap <space>n :noh<CR>
"omnisharp options
" let g:OmniSharp_server_stdio = 1
" let g:OmniSharp_start_without_solution = 1

" fzf window settings
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }
"airline setting
let g:airline#extensions#tabline#enabled = 0
let g:airline_theme='base16_gruvbox_dark_hard'

let g:gruvbox_contrast_dark = 'hard'
" --- The Greatest plugin of all time.  I am not bias
let g:vim_be_good_floating = 1
nmap <F2> :TagbarToggle<CR>


let g:polyglot_disabled = ['markdown','c_sharp', 'cs', 'ts', 'typescript', 'javascript', 'js']
" --- vim go (polyglot) settings.
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_declarations = 1
let g:go_auto_sameids = 1

let g:neoyank#save_registers = ['+','*']

let g:wintabs_display='statusline'

colorscheme gruvbox
set background=dark

if executable('rg')
    let g:rg_derive_root='true'
endif

let loaded_matchparen = 1

nnoremap L $
nnoremap H ^
vnoremap L $
vnoremap H ^

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


" Avoid showing message extra message when using completion
set shortmess+=c

vmap > >gv
vmap < <gv


" inoremap <silent><expr> <CR>      compe#confirm('<C-l>')

lua << EOF
require"telescope".load_extension("frecency")
require('telescope').load_extension('ultisnips')
require'telescope'.load_extension('project')
require('telescope').setup {
  defaults ={
    file_ignore_patterns = {'.png', '.jpeg', '.svg', '.jpg', 'tags', 'pdf'},
    borderchars = {"─", "│", "─", "│", "┌", "┐", "┘", "└"},
    layout_strategy = "vertical",
    layout_defaults = {
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
        base_dir = '~/Code',
        max_depth = 2
      }
    },
  }
}
require('lualine').setup {
  options = {theme = 'gruvbox'}
}
require("bufferline").setup{}

local on_attach = function(client, bufnr)
  require'lsp_signature'.on_attach()
end

local pid = vim.fn.getpid()
-- On linux/darwin if using a release build, otherwise under scripts/OmniSharp(.Core)(.cmd)
local omnisharp_bin = "/opt/omnisharp-roslyn-bundled/run"
require'lspconfig'.omnisharp.setup{
  cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) },
  on_attach = function(client)
    require'lsp_signature'.on_attach()
  end,
}

require'lspinstall'.setup() -- important

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{
    on_attach = on_attach,
  }
end

 require'lspconfig'.typescript.setup{}
 require'lspconfig'.vue.setup{}

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

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = false;

  source = {
    path = true;
    buffer = { priority = 1000 };
    calc = true;
    nvim_lsp = { priority = 950 };
    nvim_lua = true;
    spell = { priority = 500 };
    tags = { priority = 800 };
    --treesitter = true;
    ultisnips = { priority = 700 };
  };
}

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

local chadtree_settings = {
  ["theme.text_colour_set"] = "nerdtree_syntax_dark"
}
vim.api.nvim_set_var("chadtree_settings", chadtree_settings)

EOF

nmap <Leader>s :SymbolsOutline<CR>
" nvim bufferline stuff
nnoremap <silent>[b :BufferLineCycleNext<CR>
nnoremap <silent>]b :BufferLineCyclePrev<CR>

" These commands will move the current buffer backwards or forwards in the bufferline
nnoremap <silent>{b :BufferLineMoveNext<CR>
nnoremap <silent>}b :BufferLineMovePrev<CR>

nnoremap <silent> gb :BufferLinePick<CR>
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
nnoremap <Leader><CR> :so ~/.config/nvim/init.vim<CR>
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

if !exists("g:GuiLoaded")
  au ColorScheme * hi Normal ctermbg=none guibg=none
  au ColorScheme myspecialcolors hi Normal ctermbg=red guibg=red
endif

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
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {"vue", "pug"},
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["foo.bar"] = "Identifier",
    },
  },
  incremental_selection = {
    enable = true,
    disable = {"vue", "pug"},
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true,
    disable = {"vue", "pug"},
  },
}
print('Hello from lua')
EOF

let g:UltiSnipsExpandTrigger='<c-l>'
" shortcut to go to next position
let g:UltiSnipsJumpForwardTrigger='<c-j>'
" shortcut to go to previous position
let g:UltiSnipsJumpBackwardTrigger='<c-k>'
