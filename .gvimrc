if has('gui_macvim')
    set showtabline=2 " タブを常に表示
    set antialias
    set transparency=5
    set lines=40
    set columns=130
    colorscheme molokai
    " ime 可視化
    hi CursorIM  guifg=black  guibg=red  gui=NONE  ctermfg=black  ctermbg=white  cterm=reverse
    " １行を折り返さず、横スクロールバーの表示
    set nowrap
    if has('gui')
        set guioptions+=b
    endif
endif

if has("gui_running")
  set fuoptions=maxhorz
  "au GUIEnter * set fullscreen
endif


