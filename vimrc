""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections:
" ----------------------
"   *> General Setup
"   *> Text Options
"   *> Mappings
"   *> Autocommands
"   *> File Formats
"   *> Colors and Fonts
"   *> User Interface
"   *> Plugin Configuration
"   ------ *> Ctrl-P
"   ------ *> python-mode
"   ------ *> vim-indent-guides
"   ------ *> closetag
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Get out of VI's compatible mode
set nocompatible

"Invoke pathogen to load extra plugins
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect(g:vim_local.'/bundle')
call pathogen#helptags()

"Set how many lines of history VIM remembers
set history=1000

"Enable filetype plugin
filetype on
filetype plugin on
filetype indent on

"Set to auto read when a file is changed from the outside
set autoread

"Turn backup off
set nobackup
set noswapfile

"Use 'ack' for grep
set grepprg=ack
set grepformat=%f:%l:%m

"Update time for various features
set updatetime=1000

"Enable viminfo
set viminfo='20,\"90,h,%

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Expand tabs into spaces
set expandtab
set tabstop=4
set shiftwidth=4
"set softtabstop=4

set smarttab
set linebreak

"Auto indent
set autoindent
set cino=:0,g0

"Don't Wrap lines
set nowrap

"Encoding
set encoding=utf8
try
    lang en_US
catch
endtry

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set mapleader
let mapleader = ","

"Remap the semicolon to save typing colon
nnoremap ; :

"Toggle cursorcolmn and cursorlin
nnoremap <silent> <C-t> :set cursorcolumn! cursorline!<CR>

"Toggle TagBar
nnoremap <silent> <S-t> :TagbarOpenAutoClose<CR>

"Turn off search highlighting
nnoremap <leader>h :set hls!<cr>

"Close the current buffer
nnoremap <leader>x :close!<cr>

"Resize the window
nnoremap <leader>el :set columns=220<cr>

"Resize the window
nnoremap <leader>ej :set columns=130<cr>

"Resize the window
nnoremap <leader>eh :set columns=90<cr>

"Remap ` and ' for marking
nnoremap ' `
nnoremap ` '

"Smart way to move between windows
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>
nnoremap <silent> <C-\> :TmuxNavigatePrevious<cr>

"nnoremap <C-j> <C-W>j
"nnoremap <C-k> <C-W>k
"nnoremap <C-h> <C-W>h
"nnoremap <C-l> <C-W>l

"Move between buffers with arrow keys
"nnoremap <right> :bnext<cr>
"nnoremap <left> :bprev<cr>
noremap <space> :bnext<cr>
noremap <s-space> :bprev<cr>

"A little bit of Emacs-style navigation.
inoremap <C-a> <home>
inoremap <C-e> <end>
nnoremap <C-a> 0
nnoremap <C-e> $

"Simplify omnicompletion
"inoremap <C-space> <C-x><C-o>

"Enable resaving a file as root with sudo
cmap w!! w !sudo tee % >/dev/null

"Modify a few commands to work on local lines in a wrapped line
noremap k gk
noremap j gj
noremap H g^
noremap L g$

"Fast editing of .vimrc
nnoremap <leader>ev :exec ':e! '.g:vim_local.'/vimrc'<cr>

"Display the end of lines and tabs as special characters
set listchars=tab:>-,trail:·
set list
nnoremap <silent> <leader>s :set nolist!<cr>

"Toggle line numbers
nnoremap <leader>n :set nu!<cr>

" folding
nnoremap f za
nnoremap F zA
nnoremap <C-f> :call ToggleFold()<CR>

function! ToggleFold()
    if !exists("b:folded")
    let b:folded = 1
    endif
    if( b:folded == 0 )
        exec "normal! zM"
        let b:folded = 1
    else
        exec "normal! zR"
        let b:folded = 0
    endif
endfunction

function! MyMaps()
    if exists("g:pymode_version") | exe "nnoremap <leader>l :PyLint<CR>" | endif
    if exists("g:loaded_ctrlp")
        nnoremap <leader>f :CtrlP<cr>
        nnoremap <leader>d :CtrlP %:h<cr>
        nnoremap <leader>v :CtrlP views<cr>
        nnoremap <leader>m :CtrlP models<cr>
        nnoremap <leader>t :CtrlP templates<cr>
        nnoremap <leader>p :CtrlP panels<cr>
        nnoremap <leader>j :CtrlP ng/js<cr>
        nnoremap <leader>o :CtrlPMRUFiles<cr>
        nnoremap <leader>b :CtrlPBuffer<cr>
    endif
    if exists("g:loaded_gundo")
        nnoremap <leader>g :GundoToggle<cr>
    endif
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", "\\/.*$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    if a:direction == "b"
        execute "normal ?" . l:pattern . "^M"
    else
        execute "normal /" . l:pattern . "^M"
    endif
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"Basically you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch("f")<CR>
vnoremap <silent> # :call VisualSearch("b")<CR>

" Remap TAB to insert spaces if there is text preceding the cursor
function! InsertTab()
    if strpart(getline('.'), 0, col('.') - 1) =~ '\S'
        let num_spaces = &ts - (virtcol('.') - 1) % &ts
        return repeat(' ', num_spaces)
    else
        return "\<tab>"
    endif
endfunction

inoremap <C-tab> <c-r>=InsertTab()<cr>

"Function to execute a file beginning with a shebang
function! RunShebang()
  if (match(getline(1), '^\#!') == 0)
    :!./%
  else
    echo "No shebang in this file."
  endif
endfunction
nnoremap <leader>ex :call RunShebang()<CR>

"Switch CWD based on current file
nnoremap <leader>cd cd %:p:h<CR>
"Switch CWD based on current file only for current buffer
nnoremap <leader>lcd lcd %:p:h<CR>

"Paste support in osx gvim (NOT macvim)
"command-v doesn't show up in gvim so I have to use option-v
if has("unix")
    if !has("mac")
        nmap <M-S-v> :call setreg("\"",system("pbpaste"))<CR>o<ESC>p
        nmap <M-v> :call setreg("\"",system("pbpaste"))<CR>p
    endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocommands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !exists("autocommands_loaded")
    let autocommands_loaded = 1

    " set mappings for various bundled plugins
    au VimEnter * :call MyMaps()

    "Reload vimrc when GUI is started
    if has("gui_running")
        autocmd GUIEnter * exec 'source '.g:vim_local.'/vimrc'
    endif

    "Switch CWD based on current file
    "autocmd BufEnter * lcd %:p:h

    "When vimrc is edited, reload it
    autocmd BufWritePost vimrc exec 'source '.g:vim_local.'/vimrc'

    "Refresh syntax highlighting when buffer is entered or written
    autocmd BufEnter * syntax sync fromstart
    autocmd BufWritePost * syntax sync fromstart

    " Have Vim jump to the last position when reopening a file
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal g'\"" | endif

    function! SetMakeProg()
        set makeprg=make
        if filereadable("Makefile")
            set makeprg=make
        elseif filereadable("SConstruct")
            set makeprg=scons
        endif
    endfunction
    autocmd BufEnter * call SetMakeProg()

    "Avoid showing whitespace while in insert mode
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd BufEnter,BufRead,BufNewFile,InsertLeave * match ExtraWhitespace /\s\+$/

    "Expand tabs
    "autocmd BufEnter,BufNewFile *.c,*.cpp,*.h,*.hpp,*.cxx,*.hxx set expandtab
    "autocmd BufLeave *.c,*.cpp,*.h,*.hpp,*.cxx,*.hxx set expandtab&

    "Enable cindent
    autocmd BufEnter,BufNewFile *.c,*.cpp,*.h,*.hpp,*.cxx,*.hxx,*.m,*.mm,*.java set cindent
    autocmd BufLeave *.c,*.cpp,*.h,*.hpp,*.cxx,*.hxx,*.m,*.mm,*.java set cindent&

    "Enable omni completion
    "autocmd FileType * set omnifunc=syntaxcomplete#Complete
    autocmd FileType python set omnifunc=pythoncomplete#Complete
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS

    "Html files are sometimes Mako files
    autocmd BufEnter,BufNewFile *.html set ft=mako.xhtml.javascript

    "Activate Cosetags for html style filetypes
    autocmd Filetype mako.html,html,xhtml,xml,xsl,javascript exec 'source '.g:vim_local.'/scripts/closetag.vim'

endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => File Formats
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Favorite filetypes
set ffs=unix,dos,mac

"Default to LaTeX
let g:tex_flavor = "latex"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Turn on syntax highlighting
syntax on

"Set background to light
set background=light

if has("gui_running")
    ""let g:zenburn_high_Contrast=1
    ""let g:zenburn_unified_CursorColumn = 1
    "hi CursorLine gui=None
    "hi CursorColumn gui=None
    "hi Error gui=undercurl guibg=#1e1e1e
    if has("unix")
        if has("mac")
            set guifont=Source\ Code\ Pro\ for\ Powerline:h14
        else
            set guifont=Inconsolata\ 12
        endif
    elseif has("dos")
        set guifont=Consolas:h12
    endif
else
    set t_Co=256
endif

" color scheme
colorscheme lucius
LuciusWhite

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set terminal title
set title

"show the cursor column and cursor line
set cursorcolumn
set cursorline

"Set # of lines visible around the cursor when scrolling vertically
set scrolloff=10

"Turn on Wild Menu
set wildmenu

"Completion similarly to shell
set wildmode=list:longest,full

"Ignore some files
set wildignore+=*.jpg,*.gif,*.png,*.hdr,*.gz,*.ico
set wildignore+=*.o,*.obj,*.so,*.a,*.dll,*.dylib
set wildignore+=.DS_*,*.db,*.bak,.cache,*.lock
set wildignore+=*.svn,*.git,*.swp,*.pyc,*.class,*/__pycache__/*
set wildignore+=*.egg-info*,jquery*,taghl*,*.taghl,.ropeproject,tags
set wildignore+=node_modules,.gitkeep

"Always show current position
set ruler

"Command bar is 2-high
set cmdheight=1

"Don't show line number
set nonumber

"Do not redraw when running macros .. lazyredraw
set lazyredraw

"Change buffer without saving
set hidden

"Set backspace to work in more situations
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

"Ignore case when searching
set ignorecase
set infercase

"Use case-sensitive search if a capital letter is present
set smartcase

"Search dynamically
set incsearch

"Don't Highlight search items
set nohlsearch

"Set magic!
set magic

"Turn off all sound on errors
set noerrorbells
set novisualbell
set vb t_vb=

"Show matching brackets
set showmatch

"How many tenths of a second to blink
set mat=2

"Set window size if using a GUI
if has("gui_running") && !exists('gui_resized')
    let gui_resized = 1

    set lines=60
    set columns=90
endif

"Insert-mode completion option
set completeopt=longest,menuone,preview

"Remove a lot of visual effects like scrollbar/menu/tabs from GUI
set guioptions=a

"Show the statusline
set laststatus=2
"set statusline=%<%f\ %h%m%r%{fugitive#statusline()}\ %{HasVirtEnv()}\ %{HasPaste()}%=%-14.(%l,%c%V%)\ %P\ F:%{foldlevel('.')}

"show paste status on statusline
function! HasPaste()
    if &paste
        return '[paste]'
    else
        return ''
    endif
endfunction

"show virtualenv status on statusline
function! HasVirtEnv()
    let items = split($VIRTUAL_ENV, '/')
    if len(items)
        return '[VirtEnv(' . items[len(items)-1] . ')]'
    else
        return ''
    endif
endfunction

"Show as much of the last line as possible
set display=lastline

"Show a little more status about running command
set showcmd

"Show more context when completing ctags
set showfulltag

"Setup higlighting of whitespace that shouldn't be there
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

"Setup highlighting of lines longer than 80 characters
"highlight OverLength ctermbg=red ctermfg=white guibg=red
"2match OverLength /\%>80v.\+/

if v:version >= 703
    "Highlight the column to avoid long lines
    set colorcolumn=81
    "highlight ColorColumn ctermbg=2 guibg=#222222

    "Show the relative number instead of absolute line number
    "set relativenumber
endif

"Persistent undo
"try
"    set undodir='.vim/undodir'
"    set undofile
"catch
"endtry

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => airline
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "let g:airline_theme='light'
    let g:airline#extensions#tabline#fnamemod = ':~:.'
    let g:airline_powerline_fonts = 1

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => Ctrl-P
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let g:ctrlp_working_path_mode = 0
    let g:ctrlp_match_window_reversed = 0
    let g:ctrlp_max_height = 20
    let g:ctrlp_use_caching = 0

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => python-mode
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let g:pymode_breakpoint = 0
    let g:pymode_lint_hold = 1
    let g:pymode_lint_ignore = "E501"
    let g:pymode_lint_onfly = 0
    let g:pymode_lint_checker = "pep8"
    let g:pymode_lint_cwindow = 0
    let g:pymode_rope_extended_complete = 1
    let g:pymode_options_other = 0

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => vim-indent-guides
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_color_change_percent = 3
    let g:indent_guides_start_level = 2
    let g:indent_guides_guide_size = 1

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => closetag
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let g:closetag_html_style=1

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => SuperTab
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let g:SuperTabLongestEnhanced = 0
    let g:SuperTabLongestHighlight = 1

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => javascript-libraries-syntax.vim
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let g:used_javascript_libs = 'underscore,jquery,angularjs'

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => SyntaxComplete
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    if has("autocmd") && exists("+omnifunc")
    autocmd Filetype *
            \    if &omnifunc == "" |
            \        setlocal omnifunc=syntaxcomplete#Complete |
            \    endif
    endif
