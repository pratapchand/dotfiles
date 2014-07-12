syntax on
set number
set ruler
set background=dark
set tabstop=8
set expandtab
set softtabstop=4
set shiftwidth=4
set textwidth=79
set shell=bash
set fileformat=unix
set ff=unix
set hlsearch
set incsearch
set backup
set backupdir=~/.vim/backup
filetype indent plugin on
set modeline
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
let $Tlist_Ctags_Cmd='/usr/local/bin/ctags'
map T :TaskList<CR>
map P :TlistToggle<CR>
autocmd FileType python set omnifunc=pythoncomplete#Complete
set runtimepath^=~/.vim/bundle/ctrlp.vim
