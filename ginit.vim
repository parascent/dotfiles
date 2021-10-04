let g:neovide_cursor_animation_length=0.07
let g:neovide_cursor_vfx_mode="sonicboom"
let g:neovide_cursor_trail_size=0.5
set guifont=Delugia:h9

if exists('g:GtkGuiLoaded')
  call rpcnotify(1, 'Gui', 'Font', 'agave 10')
  call rpcnotify(1, 'Gui', 'Command', 'SetCursorBlink', '0')
  call rpcnotify(1, 'Gui', 'Command', 'Transparency', '0')
endif

if exists('g:gnvim_runtime_loaded')
  :set guifont=agave:h11
endif

autocmd vimenter * hi Normal guibg=#212121 ctermbg=NONE
autocmd vimenter * hi EndOfBuffer guibg=NONE ctermbg=NONE
