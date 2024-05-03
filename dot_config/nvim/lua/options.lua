-- File
vim.opt.autoread = true
vim.opt.swapfile = false
vim.opt.hidden = true
vim.opt.writebackup = true
vim.opt.backup = true
-- vim.opt.backupdir = vim.env.XDG_DATA_HOME .. "/vim/backup/"
-- vim.fn.mkdir(vim.env.XDG_DATA_HOME .. "/vim/backup/", "p")
vim.opt.backupdir:remove('.')
-- vim.opt.backupext = string.gsub(vim.opt.backupext, "[vimbackup]", "")
vim.opt.backupskip = ""
-- vim.opt.directory = vim.env.XDG_DATA_HOME .. "/vim/swap/"
-- vim.fn.mkdir(vim.opt.directory, "p")
vim.opt.undofile = true
-- vim.opt.undodir = vim.env.XDG_DATA_HOME .. "/vim/undo/"
-- vim.fn.mkdir(vim.opt.undodir, "p")
vim.opt.autochdir = false
vim.opt.history = 10000

-- Tab
-- tabstopはTab文字を画面上で何文字分に展開するか
-- shiftwidthはcindentやautoindent時に挿入されるインデントの幅
-- softtabstopはTabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- View
vim.opt.list = true
vim.opt.listchars = { tab = '»-', nbsp = "+", extends = '»', precedes = '«' }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.title = true
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.wrap = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true

-- Search
vim.opt.wrapscan = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Complete
vim.opt.cmdheight = 1
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.pumheight = 10
vim.opt.timeoutlen = 1000
vim.opt.updatetime = 300

-- Other
vim.opt.shortmess:append("c")
-- vim.opt.iskeyword:append("-")
vim.opt.backspace:append("indent,eol,start")
vim.opt.whichwrap:append("b,s,h,l,<,>,[,]")
vim.opt.clipboard:append({ "unnamedplus" })
vim.opt.diffopt:append("vertical,internal,algorithm:patience,iwhite,indent-heuristic")
vim.opt.nrformats:append("unsigned")
vim.opt.mouse = {}

vim.g.gh_line_map_default = 0
vim.g.gh_line_blame_map_default = 0

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- disable lsp log
vim.lsp.set_log_level("off")
