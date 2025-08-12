return {
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Autoformatting
        'stevearc/conform.nvim',

        -- Completion
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
        require('conform').setup {
            formatters_by_ft = {
                lua = { 'stylua' },
            },
        }

        local cmp = require 'cmp'
        local cmp_lsp = require 'cmp_nvim_lsp'
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        local enabled_lsp_servers = {
            lua_ls = 'lua-language-server',
            clangd = 'clangd',
            bashls = 'bash-language-server',
            qmlls = 'qmlls6',
            nixd = 'nixd',
            pyright = 'pyright',
            tombi = 'tombi',
            -- yamlls = "yaml-language-server",
        }

        for server_name, lsp_executable in pairs(enabled_lsp_servers) do
            if vim.fn.executable(lsp_executable) > 0 then
                vim.lsp.enable(server_name)
                -- else
                --     local msg = string.format("Executable '%s' for server '%s' not found! Server will not be enabled",
                --         lsp_executable, server_name)
                --     vim.notify(msg, vim.log.levels.WARN, { title = 'Nvim-config' })
            end
        end
        vim.lsp.config("*", {
            capabilities = capabilities,
            flags = {
                debounce_text_changes = 500,
            },
        })
        vim.lsp.config('clangd', {
            -- Server-specific settings. See `:help lsp-quickstart`
            cmd = {
                "clangd",
                "--fallback-style=webkit",
            },
        })
        vim.lsp.config('qmlls', {
            -- Server-specific settings. See `:help lsp-quickstart`
            cmd = {
                "qmlls6",
            },
        })
        vim.lsp.config('nixd', {
            formatting = { command = { "nixfmt" }, },
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup {
            snippet = {
                expand = function(args)
                    vim.snippet.expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm { select = true },
                ['<C-Space>'] = cmp.mapping.complete(),
            },
            sources = cmp.config.sources {
                { name = 'nvim_lsp' },
            },
        }
        vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
    end,
}
