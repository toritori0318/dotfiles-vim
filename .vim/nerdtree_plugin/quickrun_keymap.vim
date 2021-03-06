if exists("g:loaded_nerdtree_quickrun_keymap")
  finish
endif
let g:loaded_nerdtree_quickrun_keymap = 1

if !exists('g:loaded_quickrun')
  finish
endif

call NERDTreeAddKeyMap({
    \ 'key': 'rr',
    \ 'callback': 'NERDTreeQuickRun',
    \ 'quickhelpText': 'Execute Script (use QuickRun)' })



function! s:echo(msg)
    redraw
    echomsg "NERDTree: " . a:msg
endfunction

function! NERDTreeQuickRun()
    let currentNode = g:NERDTreeFileNode.GetSelected()
    if currentNode.path.isDirectory
        call s:echo(currentNode.path.str() . " is Directory.")
    else
       try
           " カーソルを直前の(最後にアクセスしていた)ウィンドウに移動
           execute('wincmd p')
           " 選択したファイルを読み込む
           execute ("edit " . currentNode.path.str({'format': 'Edit'}))
       catch /^Vim\%((\a\+)\)\=:/
           echo v:exception
       endtry

       " quickrun
       QuickRun

    endif
endfunction


