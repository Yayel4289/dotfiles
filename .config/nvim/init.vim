set number " add line numbers 
set rnu " relative numbers
set autoindent 
set shiftwidth=4 " width for autoindents 
set tabstop=4 " number of columns for tab 
set hlsearch 
set incsearch
set splitbelow splitright " below > right (for console)
set laststatus=0
set nocompatible
set updatetime=300
set clipboard=unnamedplus
set autochdir
set scrolloff=12
set fillchars=eob:\ 
" no ~
set termguicolors

syntax on

call plug#begin("~/.vim/plugged")
" Plugin section 

" Personalization
Plug 'catppuccin/nvim'
Plug 'xiyaowong/transparent.nvim'
Plug 'nvim-zh/colorful-winsep.nvim'
Plug 'levouh/tint.nvim'

" Syntax Highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Completion 
Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'


" Autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Copilot
Plug 'github/copilot.vim'

" File Nav 
Plug 'echasnovski/mini.nvim', { 'branch': 'stable' }
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

" Git
Plug 'NeogitOrg/neogit'

" Neogit Dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'sindrets/diffview.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Debugger
Plug 'mfussenegger/nvim-dap'

" LaTeX
Plug 'lervag/vimtex'

" Org List
Plug 'hamidi-dev/org-list.nvim'

" Calendar
Plug 'itchyny/calendar.vim'

call plug#end()

let mapleader = ' '
let term_decrement_h = 10
let neogit_decrement_w = 40

function! CodeExecCmds(cmd)
	let @n = a:cmd
	let @m = @%
	w
	wincmd j
	normal "np"mpA
	call feedkeys("\<Enter>\<Esc>:wincmd k\<CR>")  " Enter is weird in terminal...
endfunction

function! SwiplCodeExecCmds(use_main)
	let mod_name = fnamemodify(substitute(@%, "^'\\|'\$", "", ""), ':r')
	let use_main_str = (a:use_main ? ',' . mod_name . ':main." -t halt' : '"')
	let cmd = 'swipl -g "use_module(' . mod_name . ')' . use_main_str
	w
	wincmd j
    call feedkeys('i', 'n')
    call feedkeys(cmd, 'n')
	call feedkeys("\<Enter>")
	if (a:use_main)
		call feedkeys("\<Esc>:wincmd k\<CR>")
	endif
endfunction


function! CodeExecOnlyCmd(cmd)
	let @n = a:cmd
	w
	wincmd j
	normal "npA"
	call feedkeys("\<Enter>\<Esc>:wincmd k\<CR>") 
endfunction

" Coc bindings
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" Enter confirme la complétion si le menu est ouvert
inoremap <silent><expr> <CR> coc#pum#visible()
      \ ? coc#pum#confirm({ 'select': v:true })
      \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<Tab>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
nmap <silent> <leader>r  <Plug>(coc-rename)

inoremap $ $$<Left><Space><Space><Left>

autocmd FileType css setl iskeyword+=-

" Copilot
autocmd BufReadPost * Copilot disable

nnoremap <A-a> :Copilot enable <CR>
nnoremap <A-o> :Copilot disable <CR>
nnoremap <A-s> :Copilot panel <CR> 
nnoremap <A-n> :Copilot next <CR>

" Open Mini Files 
map <A-m> :lua MiniFiles.open() <CR>

" Open NvimTree
map <A-f> :NvimTreeFocus <CR>

" Transparency
nnoremap <A-e> :TransparentEnable<CR>
nnoremap <A-d> :TransparentDisable<CR>

" Terminal
nmap <A-t> 
	\ :sp<CR>
	\ :term<CR>
	\ :set nonumber norelativenumber<CR>
	\ :execute "resize -".term_decrement_h<CR>
nmap <A-c> <A-t>:wincmd k<CR> 
tmap <Esc> <C-\><C-n>

" Navigate in tabs 
nmap <A-h> :wincmd h <CR> 
nmap <A-l> :wincmd l <CR> 
nmap <A-j> :wincmd j <CR> 
nmap <A-k> :wincmd k <CR> 

" Close tab
nmap <A-w> :clo <CR> 

" Quick file nav
nmap <A-b> :e # <CR>

" Neogit
map <C-g> :Neogit<CR>
map <A-g> :Neogit kind=vsplit<CR>:execute ":vertical:resize -".neogit_decrement_w<CR>

" Calendar
map <C-c> :Calendar<CR>

" Code execution
augroup code_execution
	autocmd!

	" Python 3
	autocmd FileType python nnoremap <F10> :call CodeExecCmds("python3 ")<CR>
	
	" C
	autocmd FileType c nnoremap <F10> :call CodeExecOnlyCmd("make run ")<CR>
	autocmd FileType c nnoremap <F11> :call CodeExecCmds("gcc_exe ")<CR>

	" C++
	autocmd FileType cpp nnoremap <F9> :call CodeExecCmds("g++_exe ")<CR>

	" Java
	autocmd FileType java nnoremap <F8> :call CodeExecOnlyCmd("./gradlew test ")<CR>
	autocmd FileType java nnoremap <F9> :call CodeExecOnlyCmd("./gradlew clean build ")<CR>
	autocmd FileType java nnoremap <F10> :call CodeExecOnlyCmd("./gradlew run ")<CR>
	autocmd FileType java nnoremap <F11> :call CodeExecOnlyCmd("./gradlew bootRun ")<CR>

	" Bash
	autocmd FileType sh nnoremap <F10> :call CodeExecCmds("./")<CR>

	" R
	autocmd FileType r nnoremap <F10> :call CodeExecCmds("R -s -f ")<CR>

	" Prolog 
	autocmd FileType prolog nnoremap <F10> :call SwiplCodeExecCmds(1)<CR>
	autocmd FileType prolog nnoremap <F11> :call SwiplCodeExecCmds(0)<CR>

	" Scheme 
	autocmd Filetype racket,scheme nnoremap <F10> :call CodeExecCmds("racket ")<CR>

	" LaTeX 
	autocmd FileType tex nnoremap <F10> :w<CR> :!pdflatex -interaction=batchmode %<CR><CR>

	" Markdown (Markmap)
	autocmd FileType markdown nnoremap <F10> :w<CR> :!markmap -o synth.html %<CR><CR>
	autocmd FileType markdown nnoremap <F11> :w<CR> :!markmap -w % &<CR><CR>

augroup END

" colorscheme catppuccin-mocha
" catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

" set termguicolors
" highlight Normal guifg=#FFFFFF
"highlight Normal ctermbg=none ctermfg=white
"highlight Comment ctermfg=lightgray

" LaTeX
" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:

" Or with a generic interface:
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
" autocmd FileType markdown setlocal filetype=tex
" augroup vimtex_markdown
"   autocmd!
" augroup END
"
" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".

lua <<

require("nvim-autopairs").setup{
	check_ts = true,
	map_cr = false
}

require("org-list").setup({
  mapping = {
    key = "<leader>lt", 
    desc = "Toggle: Cycle through list types"
  },
  checkbox_toggle = {
    enabled = true,
    key = "<C-Space>",
    desc = "Toggle checkbox state",
    filetypes = { "markdown" }     -- Add more filetypes as needed
  }
})


require("catppuccin").setup({
	priority = 1000,
})
vim.opt.termguicolors = true

require("colorful-winsep").setup({
	-- highlight for Window separator
	hi = {
		bg = "#000000",
		fg = "#aa0000",
	},
    -- This plugin will not be activated for filetype in the following table.
    no_exec_files = { "packer", "TelescopePrompt", "mason", "CompetiTest", "NvimTree" },
    -- Symbols for separator lines, the order: horizontal, vertical, top left, top right, bottom left, bottom right.
    symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
    -- #70: https://github.com/nvim-zh/colorful-winsep.nvim/discussions/70
    only_line_seq = false,
    -- Smooth moving switch
    smooth = false,
    exponential_smoothing = false,
    anchor = {
		left = { height = 1, x = -1, y = -1 },
		right = { height = 1, x = -1, y = 0 },
		up = { width = 0, x = -1, y = 0 },
		bottom = { width = 0, x = 1, y = 0 },
    },
    light_pollution = function(lines) end,
})

require("tint").setup({
	tint = -40
})

require('mini.files').setup()

vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) -- must for transparent_background

require("neogit").setup()
require("nvim-treesitter.configs").setup({
	ensure_installed = { "xml" },
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "tex" }
	}
});

require("nvim-tree").setup();

vim.cmd.colorscheme("catppuccin-mocha")

require('nvim-ts-autotag').setup({
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false -- Auto close on trailing </
  },
  -- Also override individual filetype configs, these take priority.
  -- Empty by default, useful if one of the "opts" global settings
  -- doesn't work well in a specific filetype 
})
