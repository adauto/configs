-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    is_bootstrap = true
    vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
    use 'lukas-reineke/indent-blankline.nvim'
    use 'duane9/nvim-rg'
    use 'numToStr/Comment.nvim'
    use 'williamboman/nvim-lsp-installer'
    use 'mfussenegger/nvim-jdtls'
    use 'neovim/nvim-lspconfig'
    use 'onsails/lspkind.nvim'
    use { 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons', } }
    use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim', }, tag = '0.1.x' }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }
    use { 'hrsh7th/nvim-cmp', requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' }, }
end)

vim.cmd([[hi Pmenu ctermbg=235 ctermfg=white]])
vim.cmd([[hi PmenuSel ctermfg=231 ctermbg=242]])
vim.cmd([[hi Search ctermfg=237 cterm=bold]])

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-lsp-installer").setup {}

require('Comment').setup()

require("nvim-tree").setup({
    remove_keymaps = { "<C-t>" }
})

require('indent_blankline').setup {
    char = '',
    show_trailing_blankline_indent = false,
    ""
}

vim.o.clipboard = 'unnamedplus'
vim.wo.number = true
vim.o.mouse = 'a'
vim.o.breakindent = true
vim.o.expandtab = true
vim.o.undofile = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.completeopt = 'menuone,noselect'
vim.o.laststatus = 1
vim.o.backspace = 'indent,eol,start'

require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        },
    },
}

pcall(require('telescope').load_extension, 'fzf')

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<C-f>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

local opts = { noremap = true, silent = true }

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

vim.keymap.set('n', '<C-t>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-g>', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })

local lsp_flags = {
    debounce_text_changes = 150,
}

require 'lspconfig'.jdtls.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    cmd = { 'jdtls' }
}

require 'lspconfig'.rust_analyzer.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    settings = {
        ["rust-analyzer"] = {}
    }
}

require 'lspconfig'.gopls.setup {
    on_attach = on_attach,
    flags = lsp_flags,
}

require 'lspconfig'.jsonls.setup {
    on_attach = on_attach,
    flags = lsp_flags,
}

require 'lspconfig'.sumneko_lua.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
    }
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end

local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require('lspkind')

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-h>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
    completion = { completeopt = 'menu,menuone,noinsert' },
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = 50,
            ellipsis_char = '...',
            before = function(entry, vim_item)
                return vim_item
            end
        })
    },
    -- window = {
    --     completion = cmp.config.window.bordered(),
    --     documentation = cmp.config.window.bordered(),
    -- }
}
