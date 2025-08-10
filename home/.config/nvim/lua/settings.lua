vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

--vim.opt.nu = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.termguicolors = true
vim.opt.winborder = "rounded"

vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

vim.diagnostic.config({
    virtual_lines = {
        current_line = true
    }
})
