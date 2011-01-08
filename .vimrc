"-------------------------------------------------------------------------------
" 基本設定 Basics
"-------------------------------------------------------------------------------
let mapleader = "," " キーマップリーダー
set scrolloff=5 " スクロール時の余白確保
set textwidth=0 " 一行に長い文章を書いていても自動折り返しをしない
set nobackup " バックアップ取らない
set autoread " 他で書き換えられたら自動で読み直す
set noswapfile " スワップファイル作らない
set hidden " 編集中でも他のファイルを開けるようにする
set backspace=indent,eol,start " バックスペースでなんでも消せるように
set formatoptions=lmoq " テキスト整形オプション，マルチバイト系を追加
set vb t_vb= " ビープをならさない
set browsedir=buffer " Exploreの初期ディレクトリ
set whichwrap=b,s,h,l,<,>,[,] " カーソルを行頭、行末で止まらないようにする
set showcmd " コマンドをステータス行に表示
set showmode " 現在のモードを表示
set viminfo='50,<1000,s100,\"50 " viminfoファイルの設定
set modelines=0 " モードラインは無効
set title       "タイトルを表示
set shell=/bin/bash " シェル指定

" perl用
autocmd FileType perl set isfname-=-
setlocal iskeyword+=:

" 括弧対応パターンの拡張
source $VIMRUNTIME/macros/matchit.vim

" auto cd 
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

" ウィンドウを閉じる
nnoremap <Space>q  :q<Cr>

" us key
nnoremap ; :

" OSのクリップボードを使用する
set clipboard+=unnamed

" vimrcを即座に編集
nnoremap <Space>.  :<C-u>edit $MYVIMRC<Enter>
nnoremap <Space>g.  :<C-u>edit $MYGVIMRC<Enter>

" Hack #96 あらゆる言語に対してキーワードの補完を有効にする
autocmd FileType *
\   if &l:omnifunc == ''
\ |   setlocal omnifunc=syntaxcomplete#Complete
\ | endif
" # Hack 57 空行を挿入する
nnoremap O :<C-u>call append(expand('.'), '')<Cr>j

" pathogenでftdetectなどをloadさせるために一度ファイルタイプ判定をoff
filetype off
syntax off
filetype indent off
" pathogen.vimによってbundle配下のpluginをpathに加える
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
set helpfile=$VIMRUNTIME/doc/help.txt
" ファイルタイプ判定をon
filetype plugin on

" Capture {{{
command!
      \ -nargs=*
      \ -complete=command
      \ Capture
      \ call Capture(<f-args>)

function! Capture(cmd, ...)
  redir => result
  silent execute a:cmd
  redir END

  let bufname = 'Capture: ' . a:cmd
  new
  setlocal bufhidden=unload
  setlocal nobuflisted
  setlocal buftype=nofile
  setlocal noswapfile
  silent file `=bufname`

  if a:0 > 0
    let l:rows = split(result, "\n")
    let l:result_list = []
    for l:row in l:rows
      if stridx(l:row, a:1) >= 0
        call add(l:result_list, l:row)
      endif
    endfor
    let result = join(result_list, "\n")
  endif
  
  silent put =result
endfunction
" }}}

" uniteのチートシート表示
nnoremap <silent> ,uc :<C-u>Capture map unite<CR>

" vim diff shortcut
function VD(trn) 
    call vertical diffsplit trn
endfunction


"-------------------------------------------------------------------------------
" env
"-------------------------------------------------------------------------------
let $PATH="/opt/local/bin:".$PATH
let $PATH=$HOME."/perl5/perlbrew/bin:".$PATH


"-------------------------------------------------------------------------------
" ステータスライン StatusLine
"-------------------------------------------------------------------------------
set laststatus=2 " 常にステータスラインを表示
set ruler        " カーソルが何行目の何列目に置かれているかを表示する

" ステータスラインカスタマイズ
set statusline=%F%m%r%h%w\%=buffno=%n\ format=%{&ff}\ enc=%{&fileencoding}\ row=%l/%L\ col=%c

"入力モード時、ステータスラインのカラーを変更
augroup InsertHook
autocmd!
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END


"-------------------------------------------------------------------------------
" 表示 Apperance
"-------------------------------------------------------------------------------
set showmatch " 括弧の対応をハイライト
set number " 行番号表示
set list " 不可視文字表示
set listchars=tab:>\ ,extends:<,trail:\  " 不可視文字の表示形式
set ambiwidth=double "○○ や ××, ■■を全角にする

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

" カーソル行をハイライト
set cursorline
" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

:hi clear CursorLine
:hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black


"-------------------------------------------------------------------------------
" インデント Indent
"-------------------------------------------------------------------------------
set autoindent " 自動でインデント
set smartindent " 新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする。
set cindent " Cプログラムファイルの自動インデントを始める

" softtabstopはTabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
set tabstop=4 shiftwidth=4 softtabstop=0

if has("autocmd")
  filetype plugin on "ファイルタイプの検索を有効にする
  filetype indent on "そのファイルタイプにあわせたインデントを利用する
  autocmd FileType html :set indentexpr=
  autocmd FileType xhtml :set indentexpr=
endif



"-------------------------------------------------------------------------------
" 補完・履歴 Complete
"-------------------------------------------------------------------------------
set wildmenu " コマンド補完を強化
set wildchar=<tab> " コマンド補完を開始するキー
set wildmode=list:full " リスト表示，最長マッチ
set history=1000 " コマンド・検索パターンの履歴数
set complete+=k " 補完に辞書ファイル追加

" -- tabでオムニ補完
function! InsertTabWrapper()
  if pumvisible()
    return "\<c-n>"
  endif
  let col = col('.') - 1
  if !col || getline('.')[col -1] !~ '\k\|<\|/'
    return "\<tab>"
  elseif exists('&omnifunc') && &omnifunc == ''
    return "\<c-n>"
  else
    return "\<c-x>\<c-o>"
  endif
endfunction
nnoremap <tab> InsertTabWrapper()


"-------------------------------------------------------------------------------
" タグ関連 Tags
"-------------------------------------------------------------------------------
" set tags
if has("autochdir")
" 編集しているファイルのディレクトリに自動で移動
  set autochdir
  set tags=tags;
else
  set tags=./tags,./../tags,./*/tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags
endif



"-------------------------------------------------------------------------------
" 検索設定 Search
"-------------------------------------------------------------------------------
set wrapscan " 最後まで検索したら先頭へ戻る
set noignorecase " 大文字小文字無視しない
set incsearch " インクリメンタルサーチ
set hlsearch " 検索文字をハイライト


"選択した文字列を検索
vnoremap * y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
"選択した文字列を置換
vnoremap ,* "xy;%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//gc<Left><Left><Left>

"s*置換後文字列/g<Cr>でカーソル下のキーワードを置換
nnoremap <expr> s* ':%substitute/\<' . expand('<cword>') . '\>/'

" Ctrl-iでヘルプ
nnoremap <C-i> :<C-u>help<Space>
" カーソル下のキーワードをヘルプでひく
nnoremap <C-i><C-i> :<C-u>help<Space><C-r><C-w><Enter>

" :Gb <args> でGrepBufferする
command! -nargs=1 Gb :GrepBuffer <args>
" カーソル下の単語をGrepBufferする
nnoremap <C-g><C-b> :<C-u>GrepBuffer<Space><C-r><C-w><Enter>



"-------------------------------------------------------------------------------
" 移動設定 Move
"-------------------------------------------------------------------------------

" カーソルを表示行で移動する。論理行移動は<C-n>,<C-p>
nnoremap h <Left>
nnoremap j gj
nnoremap k gk
nnoremap l <Right>
nnoremap <Down> gj
nnoremap <Up> gk

" Window
map <S-Down> <C-w>j
map <S-Up> <C-w>k
map <S-Left> <C-w>h
map <S-Right> <C-w>l

" insert mode での移動
imap <C-e> <END>
imap <C-a> <HOME>
" インサートモードでもhjklで移動（Ctrl押すけどね）
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-h> <Left>
imap <C-l> <Right>

" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" 矩形選択で自由に移動する
set virtualedit+=block

" CTRL-hjklでウィンドウ移動
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-k>j
nnoremap <C-l> <C-l>j
nnoremap <C-h> <C-h>j


"-------------------------------------------------------------------------------
" エンコーディング関連 Encoding
"-------------------------------------------------------------------------------
set nobomb      " BOM付けない
set ffs=unix,dos,mac  " 改行文字
set encoding=utf-8    " デフォルトエンコーディング

" ワイルドカードで表示するときに優先度を低くする拡張子
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc


"-------------------------------------------------------------------------------
" カラー関連 Colors
"-------------------------------------------------------------------------------
" ハイライト on
syntax enable

" 補完候補の色づけ for vim7
hi Pmenu ctermbg=white ctermfg=darkgray
hi PmenuSel ctermbg=blue ctermfg=white
hi PmenuSbar ctermbg=0 ctermfg=9



"-------------------------------------------------------------------------------
" カラー関連 Colors
"-------------------------------------------------------------------------------
" ハイライト on
syntax enable

" 補完候補の色づけ for vim7
hi Pmenu ctermbg=white ctermfg=darkgray
hi PmenuSel ctermbg=blue ctermfg=white
hi PmenuSbar ctermbg=0 ctermfg=9



"-------------------------------------------------------------------------------
" 編集関連 Edit
"-------------------------------------------------------------------------------

" insertモードを抜けるとIMEオフ
set noimdisable
set iminsert=0 imsearch=0
set noimcmdline
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>

" Tabキーを空白に変換
set expandtab

" ビジュアルモードで選択した結果を囲む
vnoremap { "zdi{<C-R>z}<ESC>
vnoremap [ "zdi[<C-R>z]<ESC>
vnoremap ( "zdi(<C-R>z)<ESC>
vnoremap " "zdi"<C-R>z"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>


"-------------------------------------------------------------------------------
" Windows向け
"-------------------------------------------------------------------------------
" 全て選択
map <A-a>  ggvG
" 切り取り
vnoremap <A-x> "+x
" クリップボードコピー／貼り付け
vnoremap <A-c> "+y
map <A-v>       "+gP
map <S-Insert>      "+gP
cmap <A-v>      <C-R>+
cmap <S-Insert>     <C-R>+
exe 'inoremap <script> <A-v>' paste#paste_cmd['i']
exe 'vnoremap <script> <A-v>' paste#paste_cmd['v']
imap <S-Insert>     <A-v>
vmap <S-Insert>     <A-v>



"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------
" プラグインごとの設定 Plugins
"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------

"------------------------------------
" taglist
"------------------------------------
nnoremap <silent> <F5> :TlistToggle<CR>
let g:Tlist_Show_One_File = 1
let g:Tlist_Exit_OnlyWindow = 1
let g:Tlist_Use_Right_Window = 1
let g:Tlist_WinWidth = 20

"------------------------------------
" YankRing.vim
"------------------------------------
" Yankの履歴参照
nmap ,yh ;YRShow<CR>

"------------------------------------
" Align
"------------------------------------
" Alignを日本語環境で使用するための設定
let g:Align_xstrlen = 3

"------------------------------------
" NERD Tree
"------------------------------------
" 表示
nmap <silent> <F3> :<C-u>NERDTreeToggle<CR>

" ------------------------------------
" grep.vim
"------------------------------------
" 検索外のディレクトリ、ファイルパターン
let Grep_Skip_Dirs = '.svn .git .hg'
let Grep_Skip_Files = '*.bak *~'

" ------------------------------------
" ref.vim
"------------------------------------
" パッケージ単位で補完
let g:ref_perldoc_complete_head = 1 

"------------------------------------
" neocomplecache.vim
"------------------------------------
" NeoComplCacheを有効にする
let g:neocomplcache_enable_at_startup = 1

"------------------------------------
" unite.vim
"------------------------------------
" The prefix key.
nnoremap [unite] <Nop>
nmap ,f [unite]

nnoremap [unite]u :<C-u>Unite<Space>
nnoremap <silent> [unite]a :<C-u>UniteWithCurrentDir -buffer-name=files buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]f :<C-u>Unite -buffer-name=files file<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>

" nnoremap <silent> [unite]b :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
" Overwrite settings.
  imap <buffer> jj <Plug>(unite_insert_leave)
  nnoremap <silent><buffer> <C-k> :<C-u>call unite#mappings#do_action('preview')<CR>
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
" Start insert.
  let g:unite_enable_start_insert = 1
endfunction"}}}

let g:unite_source_file_mru_limit = 200


