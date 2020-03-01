"颜色主题

colorscheme molokai
set t_Co=256
set background=dark

"Vundle相关。Vundle是vim插件管理器，使用它来管理插件很方便，而且功能强大

set nocompatible              " be iMproved, required
filetype off                  " required


" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
" Plugin 'VundleVim/Vundle.vim'
" The following are examples of different formats supported.
Plugin 'https://github.com/scrooloose/nerdtree.git'
Plugin 'Valloric/YouCompleteMe' "{
"配置默认文件路径
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

"语法关键字补全
let g:ycm_seed_identifiers_with_syntax = 1  
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1

"字符串开启补全
let g:ycm_complete_in_strings=1
let g:ycm_key_invoke_completion = '<c-z>'
set completeopt=menu,preview

"补全后自动关闭预览窗口
let g:ycm_autoclose_preview_window_after_completion = 1
noremap <c-z> <NOP>

"回车选中匹配项
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>" 

"语义补全触发条件
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \             're!\[.*\]\s'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }
let g:ycm_semantic_triggers =  {
			\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			\ 'cs,lua,javascript': ['re!\w{2}'],
			\ }
"}
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"vim支持鼠标点击
"set mouse=a

set wildmenu

" 显示行号
set number

" 自动对齐文中行缩进
set autoindent

"智能缩进使用了代码语法和样式来对齐
set smartindent

" tab键的宽度
set tabstop=4

set cursorline

"在遍历文件时识别括弧的起始和结束位置
set showmatch

"在文件中高亮显示搜索关键词
set hlsearch

set encoding=utf-8
set nocompatible
syntax on

let python_highlight_all=1
au Filetype python set tabstop=4
au Filetype python set softtabstop=4
au Filetype python set shiftwidth=4
au Filetype python set textwidth=79
au Filetype python set expandtab
au Filetype python set autoindent
au Filetype python set fileformat=unix
autocmd Filetype python set foldmethod=indent
autocmd Filetype python set foldlevel=99

map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
        exec "w"
        if &filetype == 'c'
                exec "!g++ % -o %<"
                exec "!time ./%<"
        elseif &filetype == 'cpp'
                exec "!g++ % -o %<"
                exec "!time ./%<"
        elseif &filetype == 'java'
                exec "!javac %"
                exec "!time java %<"
        elseif &filetype == 'sh'
                :!time bash %
        elseif &filetype == 'python'
                exec "!clear"
                exec "!time python3 %"
        elseif &filetype == 'html'
                exec "!firefox % &"
        elseif &filetype == 'go'
                " exec "!go build %<"
                exec "!time go run %"
        elseif &filetype == 'mkd'
                exec "!~/.vim/markdown.pl % > %.html &"
                exec "!firefox %.html &"
        endif
endfunc

"自动补全
:inoremap < <><ESC>i
:inoremap > <c-r>=ClosePair('>')<CR>
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {}<ESC>i
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap " ""<ESC>i
:inoremap ' ''<ESC>i
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction

"NERDTree config
             map <F4> :NERDTreeToggle<CR>  " F4一键开关目录树
             autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | endif  " 当目录树窗口为最后一个窗口时自动退出vim


""""""""""""""""" 新文件标题"""""""""""""""""""""""""""	  

"新建.pl文件，自动插入文件头

autocmd BufNewFile *.pl exec ":call SetPerlTitle()"

func SetPerlTitle()
	call setline(1,"#!usr/bin/perl -w")
	call append( line("."),"use strict;")
	call append(line(".")+1," ")
	call append(line(".")+2, "\# File Name: ".expand("%"))
	call append(line(".")+3, "\# Author: chensole")
	call append(line(".")+4, "\# mail: 1278371386@qq.com")
	call append(line(".")+5, "\# Created Time: ".strftime("%Y-%m-%d",localtime()))
endfunc


" 键盘命令

" 映射全选+复制 ctrl+a

 map <C-A> ggVGY

 map! <C-A> <Esc>ggVGY

 map <F12> gg=G

 " 选中状态下 Ctrl+c 复制

 vmap <C-c> "+y

 "去空行

 nnoremap <F2> :g/^\s*$/d<CR>











