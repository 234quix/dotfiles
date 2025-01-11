set number
set relativenumber
set nocompatible
filetype plugin indent on 

" copy indentation of current line to next line
set autoindent
set mouse=a
let mapleader = ";"
"noremap <C-d> <C-v>
nmap <leader>ll :VimtexCompile<CR>
nmap <leader>lv :VimtexView<CR>

" case insensitive search 
set ignorecase
" keep changes in memory, Changes that you made will not be discarded, nor will they be written to disk. They will be "saved in the buffer", to be handled later on.
set hidden
au BufNewFile,BufRead *.py set sts=4 | set ts=4 | set sw=4 | set smarttab | set expandtab
"au BufNewFile,BufRead *.md set sts=4 | set ts=4 | set sw=4 | set smarttab | set expandtab
au BufNewFile,BufRead *.tex nnoremap <leader>a :r!append_lastscreenshot<CR>
"" open terminal in bottom buffer
nnoremap <space><space> :botright split term://zsh<CR>:startinsert<CR>
"" close the terminal (but keep contents)
tnoremap <space><space> <C-\><C-N>:stopinsert<CR>:close<CR>
"" close the terminal and kill it; k is for kill
tnoremap <space>k <C-\><C-N>:q!<CR>
"" move cursor to window above the terminal 
tnoremap <C-k> <C-\><C-N><C-w>k
"" go into insert mode in terminal
tnoremap ii :startinsert<CR>
"" let's remap leader key because \ is hard to reach
let mapleader = ";"
"" toggle between 2 buffers:

"" move cursor between windows using control and arrow keys
nnoremap <silent> <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
au BufRead,BufNewFile *.md setlocal textwidth=110
autocmd BufRead,BufNewFile *.ipynb setlocal filetype=ipynb
" " following 2 lines should be unnecessary if filetype detection is working
"autocmd BufRead,BufNewFile *.md setlocal filetype=md
"autocmd BufRead,BufNewFile *.py setfiletype python
"" open files with default application in vim
nnoremap go :!open <cfile><CR>
"" open a python repl in right split
nnoremap <leader>ts :rightbelow vsplit term://python<CR>

autocmd FileType vimwiki nnoremap <buffer> <C-x> :Vimwiki2HTMLBrowse<CR>
"" Begin: send visually selected code to repl 


"" End

"***************************************************************************
" open ipynb files as markdown files and sync the changes back to ipynb when
" saving 
" Automatically pair .ipynb with .md when opening in neovim. 

" To install Jupytext, run: !pip install jupytext
"autocmd BufReadPost,BufEnter *.ipynb :silent !jupytext --set-formats ipynb,md:markdown %
autocmd BufReadPost,BufEnter *.ipynb :silent !jupytext --set-formats ipynb,py:percent %
autocmd BufReadPost *.ipynb :edit %:r.py | setlocal filetype=python
" Mapping to switch to the corresponding .md file
" jump to corresponding md file from a ipynb file
autocmd FileType ipynb nnoremap <buffer> <leader>j :edit %:r.py<CR>
" jump to corresponding ipynb file from an md file
autocmd FileType py nnoremap <buffer> <leader>j :edit %:r.ipynb<CR>
" Sync changes from .md back to .ipynb when saving
" not robust
autocmd BufWritePost *.py  :!jupytext --sync %
nnoremap <leader>s :!jupytext --sync %<CR>
nnoremap <leader>sd :!jupytext --sync %<CR>:!nbdev_export<CR>
"autocmd BufWritePost * if &filetype ==# 'python' | silent !jupytext --sync % | endif

" (Optional) Automatically remove the .md file when closing the .ipynb file
"autocmd BufWinLeave *.ipynb :execute 'silent !rm -f ' . expand('%:r') . '.md'
"autocmd VimLeavePre *.ipynb :execute 'silent !rm -f ' . shellescape(expand('%:r') . '.md')
" Set Vim's working directory to the directory of the current file
autocmd BufEnter * silent! lcd %:p:h

" print todays date using F5
nnoremap <F5> :r !date "+\%Y-\%m-\%d"<CR>

"curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin(stdpath('data') . '/plugged')
" Plugins for using tags
function! BuildVimTags(info)
  if a:info.status != 'installed'
    return 0
  endif
  brew install universal-ctags
endfunction

Plug 'neovim/nvim-lspconfig'
Plug 'echasnovski/mini.nvim', { 'branch': 'stable' }
Plug 'lervag/vimtex'
Plug 'vimwiki/vimwiki'
"let g:vimwiki_list = [{'path': expand('$HOME/learning/vimwiki/'), 'syntax': 'markdown', 'ext': '.md'}]
"
if match(system('hostname'), 'lp-nduggan-29') != -1
	let g:vimwiki_list = [{'path': expand('$HOME/learning/vimwiki/'),
	  \ 'path_html': '~/learning/vimwiki/html/',
	  \ 'syntax': 'markdown',
	  \ 'ext': '.md',
	  \ 'custom_wiki2html': expand('$HOME/bin/wiki2html_gpt.sh')},
	  \ {'path': expand('$HOME/prepos/planning/_posts/'),
	  \ 'path_html': '~/learning/vimwiki/html/',
	  \ 'syntax': 'markdown',
	  \ 'ext': '.md',
	  \ 'custom_wiki2html': expand('$HOME/bin/wiki2html.sh')}]
else
	let g:vimwiki_list = [{'path': expand('$HOME/repos/vimwiki/vimwiki'),
	  \ 'path_html': '~/repos/vimwiki/vimwiki/html/',
	  \ 'syntax': 'markdown',
	  \ 'ext': '.md',
	  \ 'custom_wiki2html': 'usr/local/bin/wiki2html.sh'}]
endif
Plug 'mzlogin/vim-markdown-toc'
Plug 'chrisbra/csv.vim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'nvim-treesitter/nvim-treesitter'
" Plugins for nodejs
Plug 'ternjs/tern_for_vim', {'do': 'npm install'}
Plug 'moll/vim-node'

"let g:syntastic_typescript_checkers=['tsuquyomi']
Plug 'leafgarland/typescript-vim'
" Plugin for commenting sections 
Plug 'numToStr/Comment.nvim'

" code assistant 
"" Dependencies of avante.nvim
" Deps
Plug 'stevearc/dressing.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'

" Optional deps
Plug 'HakonHarnes/img-clip.nvim'
Plug 'zbirenbaum/copilot.lua'

" Yay, pass source=true if you want to build from source
Plug 'yetone/avante.nvim', { 'do': 'make' }
" autocmd! User avante.nvim lua require('avante_lib').load()

" File explorer:
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons

" Autodetect the project root 
Plug 'ahmedkhalf/project.nvim'


" repl
" dep of NotebookNavigator:
Plug 'echasnovski/mini.comment'
Plug 'hkupty/iron.nvim'
Plug 'anuvyklack/hydra.nvim'
Plug 'GCBallesteros/NotebookNavigator.nvim'
Plug 'echasnovski/mini.hipatterns'
call plug#end()

lua require('Comment').setup()
"" Key mappings
" fzf
" " use ctrl s to show Files etc
" Set the default command for fzf
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!dist/*"'
nnoremap <silent> <C-s> :Files<CR>
nnoremap <silent> <C-g> :GFiles<CR>
nnoremap <silent> <S-s> :Buffers<CR>
" " use ctrl f to search for text
nnoremap <C-f> :Rg!<Space>



"" open terminal in bottom buffer

nnoremap <space><space> :botright split term://zsh<CR>:startinsert<CR>

"" activate virtual environment in vim terminal
nnoremap <space>v :call feedkeys("i source $VIRTUAL_ENV/bin/activate\<lt>CR>")<CR>
"" close the terminal (but keep contents)
tnoremap <space><space> <C-\><C-N>:stopinsert<CR>:hide<CR>
tnoremap <space><CR> <C-\><C-N>:hide<CR>

""tnoremap <space><CR> <C-\><C-N>:bdelete!<CR>
"" close the terminal and kill it; k is for kill
tnoremap <space>k <C-\><C-N>:q!<CR>
"" move cursor to window above the terminal 
tnoremap <C-k> <C-\><C-N><C-w>k
"" go into insert mode in terminal
tnoremap ii :startinsert<CR>
"" go back to normal mode in terminal
tnoremap <ESC> <C-\><C-n>
"" toggle between 2 buffers:
nnoremap <leader>b <C-^>
"" move cursor between windows using control and arrow keys
nnoremap <silent> <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
"" copy absolute path to current buffer to system clipboard 
nnoremap <C-a> :let @+=expand('%:p')<CR>

" Automatically detect and activate any virtual environment ending with 'env'
autocmd FileType python,markdown if len(globpath(getcwd(), '*/env/bin/python')) > 0 | let g:python3_host_prog = globpath(getcwd(), '*/env/bin/python') | endif



" Check which Python interpreter is active
nnoremap <leader>pe :echo system('which python')<CR>

" Use a key mapping to toggle filetype between markdown and python.markdown when needed
autocmd FileType markdown,vimwiki nnoremap <leader>tp :set filetype=python.markdown<CR>


"" vim wiki - ctrl - enter to open link in vertical split:
nnoremap <C><CR> :VimwikiVSplitLink<CR>

"" fzf.vim use ctrl-r instead of ctrl-v to open file in vertical split
let g:fzf_action = {
\ 'ctrl-c': 'vsplit',
\ 'ctrl-x': 'split',
\ 'ctrl-t': 'tabedit'
\ }

command! -bang -nargs=* Rg call fzf#vim#grep(
  \ 'rg --column --line-number --no-heading --hidden --color=always '.input('Extra flags: ', '-P '). 
  \ ' '.shellescape(<q-args>), 1,
  \ fzf#vim#with_preview(), <bang>0)
" command! -bang -nargs=* Rg call fzf#vim#grep(
"   \ 'rg --column --line-number --no-heading --hidden --color=always '.input('Extra flags: ', '').
"   \ ' '.shellescape(<q-args>), 1,
"   \ fzf#vim#with_preview(), <bang>0)

" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several times.
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

:lua require'lspconfig'.pyright.setup{}
" "":lua require'lspconfig'.jedi_language_server.setup{}
" :lua require("mini.completion").setup()
" :lua require'lspconfig'.ts_ls.setup{}
:lua require('lspconfig').ts_ls.setup{}
" local lspconfig = require('lspconfig')
"
" " Python
" :lua lspconfig.pyright.setup{}
" " TypeScript
" :lua lspconfig.tsserver.setup{}
""""##### vimtex config

" " This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see ":help vimtex-requirements" for more
" info).
syntax enable


""" catppucin config
colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha


""""" language server config:
lua << EOF
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
EOF

"" Use LspAttach autocommand to only map the following keys
"" after the language server attaches to the current buffer
lua << EOF
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
EOF

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "python", "vim", "vimdoc", "query", "json", "html", "markdown", "dockerfile", "typescript", "latex", "sql", "bash","lua"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    -- additional_vim_regex_highlighting = false,

    additional_vim_regex_highlighting = {"markdown"},
  },
}
EOF

" config for avante
" Set the runtime path for avante.nvim after it's installed
set runtimepath+=~/.local/share/nvim/plugged/avante.nvim
lua << EOF
  require('avante_lib').load()  -- Load avante_lib first
  require('avante').setup({
    provider = "claude",  -- You can choose your provider (e.g., "claude", "openai", etc.)
    auto_suggestions_provider = "claude",
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-3-5-sonnet-20240620",
      temperature = 0.0,
      max_tokens = 4096,
    },
behaviour = {
    auto_suggestions = false, -- Experimental stage
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
  },
    mappings = {
      suggestion = {
        accept = "<M-l>",  -- Key mapping for accepting a suggestion
        next = "<M-]>",    -- Key mapping for moving to the next suggestion
        prev = "<M-[>",    -- Key mapping for moving to the previous suggestion
        dismiss = "<C-]>", -- Key mapping for dismissing a suggestion
      }
    },
    windows = {
      position = "right", -- Sidebar position
      wrap = true,        -- Text wrapping in the sidebar
      width = 30,         -- Sidebar width
    },
    submit = {
      normal = "<CR>",
      insert = "<C-s>",
    },
    hints = { enabled = true },
  })
EOF

" config for nvim-tree
lua << EOF 
require('nvim-tree').setup({
  view = {
    adaptive_size = true,
    side = 'left',
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
})

vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
EOF

" config for project.nvim (used for finding project root)
lua << EOF
require('project_nvim').setup({
  detection_methods = { 'pattern' },
  patterns = {'.nvimroot', '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json'},
})
vim.api.nvim_set_keymap('n', '<leader>p', ':lua require("project_nvim").open_project_fzf()<CR>', { noremap = true, silent = true })
EOF





" Configure Notebook Navigator
lua << EOF
local nn = require('notebook-navigator')
nn.setup({
  activate_hydra_keys = "<leader>h",
  cell_markers = {
    python = "# %%",
  },
  syntax_highlight = true,
})
EOF

" Key mappings for Notebook Navigator
nnoremap ]h :lua require('notebook-navigator').move_cell('d')<CR>
nnoremap [h :lua require('notebook-navigator').move_cell('u')<CR>
nnoremap <leader>X :lua require('notebook-navigator').run_cell()<CR>
nnoremap <leader>x :lua require('notebook-navigator').run_and_move()<CR>

" Optional: Enable cell marker highlighting with 'mini.hipatterns'
lua << EOF
require('mini.hipatterns').setup({
  highlighters = {
    cells = require('notebook-navigator').minihipatterns_spec,
  }
})
EOF

" Optional: Enable code cell text objects with 'mini.ai'
lua << EOF
require('mini.ai').setup({
  custom_textobjects = {
    h = require('notebook-navigator').miniai_spec,
  }
})
EOF

" Optional: Configure iron.nvim for REPL interaction
lua << EOF
require('iron.core').setup({
  config = {
    repl_definition = {
      python = {
        command = {"ipython", "--no-autoindent"}
      },
    },
    repl_open_cmd = 'vertical botright 80 split',
  },

keymaps = {
  -- Other key mappings...
  clear = "<space>cl",
},
})
EOF
" Map <leader>q to hide the REPL window with IronHide, but only for Python files
autocmd FileType python nnoremap <buffer> <leader>q :IronHide<CR>

" Function to close all buffers except the current one
function! CloseOtherBuffers()
  let current_buf = bufnr('%')
  for buf in getbufinfo({'bufloaded': 1})
    if buf.bufnr != current_buf
      let is_modified = getbufvar(buf.bufnr, '&modified')
      let buf_type = getbufvar(buf.bufnr, '&buftype')

      if buf_type ==# 'terminal'
        " Force delete terminal buffers
        execute 'bd! ' . buf.bufnr
      elseif is_modified == 0
        " Delete unmodified buffers
        execute 'bd ' . buf.bufnr
      endif
    endif
  endfor
endfunction

" Create a command to invoke the function
command! CloseOtherBuffers call CloseOtherBuffers()

" Map <leader>c to the command in normal mode
nnoremap <leader>c :CloseOtherBuffers<CR>

let g:vimwiki_global_ext = 1
function! OpenCrossWikiLink()
    let l:link = expand('<cfile>')

    " Debugging: Print the link Vimwiki thinks you're opening
    echo "Original link: " . l:link

    " Handle absolute paths
    if l:link =~ '^/'
        if filereadable(l:link)
            execute 'e ' . l:link
        else
            echo "File does not exist: " . l:link
        endif
    else
        " For other links, fall back to default Vimwiki behavior
        execute 'VimwikiFollowLink'
    endif
endfunction

autocmd FileType vimwiki nnoremap <silent> <CR> :call OpenCrossWikiLink()<CR>

function! ToggleVimwikiIndex()
    " Check the current wiki number
    let current_wiki = vimwiki#vars#get_wikilocal('wiki_nr')
    " Toggle between the two indices
    if current_wiki == 1
        execute 'VimwikiIndex 2'
    else
        execute 'VimwikiIndex 1'
    endif
endfunction

nnoremap <leader>wi :call ToggleVimwikiIndex()<CR>
