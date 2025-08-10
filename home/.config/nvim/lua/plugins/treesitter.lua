return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "caddy",
                "desktop",
                "dockerfile",
                "git_config",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "python",
                "lua",
                "vim",
                "vimdoc",
                "rust",
                "markdown",
                "markdown_inline",
                "tmux",
                "qmldir",
                "qmljs",
                "ssh_config",
                "udev",
                "yaml",
                "zig",
                "nix",
            },
            sync_install = false,
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
