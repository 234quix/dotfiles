set number
set relativenumber
set nocompatible
filetype plugin on 

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
au BufRead,BufNewFile *.md setlocal textwidth=110
autocmd BufRead,BufNewFile *.ipynb setlocal filetype=ipynb
autocmd BufRead,BufNewFile *.md setlocal filetype=md

"***************************************************************************
" open ipynb files as markdown files and sync the changes back to ipynb when
" saving 
" Automatically pair .ipynb with .md when opening in neovim. 

" To install Jupytext, run: !pip install jupytext
autocmd BufReadPost,BufEnter *.ipynb :silent !jupytext --set-formats ipynb,md:markdown %
autocmd BufReadPost *.ipynb :silent edit %:r.md | setlocal filetype=markdown
" Mapping to switch to the corresponding .md file
" jump to corresponding md file from a ipynb file
autocmd FileType ipynb nnoremap <buffer> <leader>j :edit %:r.md<CR>
" jump to corresponding ipynb file from an md file
autocmd FileType md nnoremap <buffer> <leader>j :edit %:r.ipynb<CR>
" Sync changes from .md back to .ipynb when saving
autocmd BufWritePost *.md :silent !jupytext --sync %

" (Optional) Automatically remove the .md file when closing the .ipynb file
"autocmd BufWinLeave *.ipynb :execute 'silent !rm -f ' . expand('%:r') . '.md'
"autocmd VimLeavePre *.ipynb :execute 'silent !rm -f ' . shellescape(expand('%:r') . '.md')
" Set Vim's working directory to the directory of the current file
autocmd BufEnter * silent! lcd %:p:h
"***************************************************************************

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
let g:vimwiki_list = [{'path': expand('$HOME/learning/vimwiki/'),
  \ 'path_html': '~/learning/vimwiki/html/',
  \ 'syntax': 'markdown',
  \ 'ext': '.md',
  \ 'html_ext': '.html',
  \ 'custom_wiki2html': expand('$HOME/bin/wiki2html.sh')},
  \ {'path': expand('$HOME/prepos/planning/_posts/'),
  \ 'path_html': '~/learning/vimwiki/html/',
  \ 'syntax': 'markdown',
  \ 'ext': '.md',
  \ 'html_ext': '.html',
  \ 'custom_wiki2html': expand('$HOME/bin/wiki2html.sh')}]
Plug 'mzlogin/vim-markdown-toc'
Plug 'chrisbra/csv.vim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'nvim-treesitter/nvim-treesitter'
" Plugins for nodejs
Plug 'ternjs/tern_for_vim', {'do': 'npm install'}
Plug 'moll/vim-node'

" Plugins for TypeScript
Plug 'Quramy/tsuquyomi', {'do': 'npm install -g typescript'}
let g:tsuquyomi_disable_quickfix=1
"let g:syntastic_typescript_checkers=['tsuquyomi']
Plug 'leafgarland/typescript-vim'
" Plugin for commenting sections 
Plug 'numToStr/Comment.nvim'

" code assistant 
"" Dependencies of avante.nvim
Plug 'stevearc/dressing.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'yetone/avante.nvim', { 'branch': 'main', 'do': { -> avante#build() }, 'on': 'AvanteAsk' }

" File explorer:
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons

" Autodetect the project root 
Plug 'ahmedkhalf/project.nvim'
call plug#end()

lua require('Comment').setup()
"" Key mappings
" fzf
" " use ctrl s to show Files etc
nnoremap <silent> <C-s> :Files<CR>
nnoremap <silent> <C-g> :GFiles<CR>
nnoremap <silent> <S-s> :Buffers<CR>
" " use ctrl f to search for text
nnoremap <C-f> :Rg!<Space>



"" open terminal in bottom buffer

nnoremap <space><space> :botright split term://zsh<CR>:startinsert<CR>

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
:lua require("mini.completion").setup()
:lua require'lspconfig'.ts_ls.setup{}
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
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
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
  ensure_installed = { "python", "vim", "vimdoc", "query", "markdown","json","sql","bash","lua" },

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
  require('avante').setup({
    provider = "claude",  -- You can choose your provider (e.g., "claude", "openai", etc.)
    auto_suggestions_provider = "claude",
    claude = {
      api_key = vim.fn.getenv("ANTHROPIC_API_KEY"),  -- Fetch API key from the environment
      endpoint = "https://api.anthropic.com",
      model = "claude-3-5-sonnet-20240620",
      temperature = 0.7,
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
