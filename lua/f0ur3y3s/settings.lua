local global = vim.g
local o = vim.opt

o.number = true
o.relativenumber = true
o.hidden = true
o.title = true
o.splitright = true
o.expandtab = true
o.tabstop = 5
o.shiftwidth = 4
o.mouse = "a"

global.clipboard = {"unnamed", "unnamedplus"}

local kmp = vim.keymap

kmp.set("i", "jk", "<Esc>")
kmp.set("n", "<Tab>", ">>")
kmp.set("n", "<S-Tab>", "<<")

