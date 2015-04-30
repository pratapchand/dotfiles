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
set backspace=indent,eol,start
set backupdir=~/.vim/backup
filetype indent plugin on
set modeline
call pathogen#infect()
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
let g:syntastic_python_checkers=['flake8']
let g:flake8_quickfix_location="belowright"
let g:flake8_quickfix_height=7
let g:flake8_show_quickfix=1
let g:syntastic_java_javac_custom_classpath_command =
    \ "ant -q test-quick | grep echo | cut -f2- -d] | tr -d ' ' | tr ':' '\n'"
autocmd BufWritePost *.py call Flake8()
let $Tlist_Ctags_Cmd='/usr/local/bin/ctags'
map T :TaskList<CR>
map P :TlistToggle<CR>
autocmd FileType python set omnifunc=pythoncomplete#Complete
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:netrw_liststyle=3
nnoremap <leader>. :CtrlPTag<cr>

autocmd FileType java set tags=~/.tags

let VimuxUseNearestPane = 1
nnoremap <Leader>vp :VimuxPromptCommand<CR>
nnoremap <Leader>vl :VimuxRunLastCommand<CR>
nnoremap <Leader>vi :VimuxInspectRunner<CR>
nnoremap <Leader>vq :VimuxCloseRunner<CR>
nnoremap <Leader>vk :VimuxInterruptRunner<CR>
nnoremap <Leader>vc :VimuxClearRunnerHistory<CR>
vnoremap <LocalLeader>vs "vy :call VimuxRunCommand(@v . "\n", 0)<CR>
nnoremap <LocalLeader>vs vip<LocalLeader>vs<CR>

autocmd BufRead *.java set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
