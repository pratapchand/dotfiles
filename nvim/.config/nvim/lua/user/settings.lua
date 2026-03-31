local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.ruler = true

-- Tabs & indentation (matching previous vim config)
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- Line width
opt.textwidth = 120
opt.colorcolumn = "120"

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8

-- File handling
opt.fileformat = "unix"
opt.backup = false
opt.swapfile = false
opt.undofile = true

-- Folding
opt.foldmethod = "indent"
opt.foldnestmax = 10
opt.foldenable = false
opt.foldlevel = 1

-- Misc
opt.backspace = { "indent", "eol", "start" }
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.splitbelow = true
opt.splitright = true
opt.updatetime = 250

-- Tags
opt.tags = "./.tags,.tags"

-- Shell
opt.shell = "zsh"
