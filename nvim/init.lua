-- Load my plugins:  ~/.config/nvim/lua/user/plugins.lua
require("user.plugins")

--
-- Basic configuration
--
local api = vim.api
local map = vim.api.nvim_set_keymap
local opt = vim.opt

-- searching
opt.ignorecase = true
opt.smartcase = true

-- Clear highlights with space space
map("", "<Esc><Esc>", ":noh<CR> :call clearmatches()<CR>", { silent = true })

-- line numbers
opt.relativenumber = true
opt.number = true

api.nvim_command("set signcolumn=yes")

-- mouse
vim.cmd [[set mouse=]]

-- splits
opt.splitright = true
opt.splitbelow = true

-- whitespace
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2

-- Set leader to space
vim.g.mapleader = " "

-- Share clipboard with system
opt.clipboard = "unnamed"

-- Color Scheme
opt.background = "dark"
require("gruvbox").setup({
  italic = {
    comments = false,
    keywords = false,
    functions = false,
    strings = false,
    variables = false,
  },
})
vim.cmd([[colorscheme gruvbox]])

-- better splits
map("n", "<C-J>", "<C-W><C-J>", {})
map("n", "<C-K>", "<C-W><C-K>", {})
map("n", "<C-L>", "<C-W><C-L>", {})
map("n", "<C-H>", "<C-W><C-H>", {})

-- File browser extenstion
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
opt.termguicolors = true

-- column
opt.colorcolumn = "80,120"

-- Nvim tree
require("nvim-tree").setup({
  disable_netrw = false,
  hijack_cursor = true,
  sort_by = "case_sensitive",
  update_focused_file = {
    enable = true,
  },
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "<C-k>", action = "" },
        { key = "<C-t>", action = "" },
      },
    },
  },
  renderer = {
    group_empty = true,
    symlink_destination = false,
  },
  filters = {
    dotfiles = true,
  },
})

map("n", "<C-k><C-B>", ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true })

-- Coppilot
vim.g.copilot_filetypes = {
  TelescopePrompt = false,
}

-- Telescope
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<S-Down>"] = require('telescope.actions').cycle_history_next,
        ["<S-Up>"] = require('telescope.actions').cycle_history_prev,
      },
  },
  pickers = {},
  extensions = {}
  },
}
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<c-t>', builtin.find_files, {})
vim.keymap.set('n', '<C-S-F>', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})

--
-- Language Server
--

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>gd', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)

local on_attach = function(client, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', '<leader>go', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '<leader>gh', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<leader>gy', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
end


--
-- Mason / Language Server  Auto-Installer
--
require("mason").setup()

--
-- Auto completion
--

local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})


local capabilities = require('cmp_nvim_lsp').default_capabilities()


-- typescript lspconfig

require('lspconfig')['tsserver'].setup{
  on_attach = on_attach,
  flags = {},
  capabilities = capabilities
}

require("lspconfig").pylsp.setup{}


-- prettier
local null_ls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

null_ls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })

      -- format on save
      -- vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
      -- vim.api.nvim_create_autocmd(event, {
      --   buffer = bufnr,
      --   group = group,
      --   callback = function()
      --     vim.lsp.buf.format({ bufnr = bufnr, async = async })
      --   end,
      --   desc = "[lsp] format on save",
      -- })
    end

    if client.supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("x", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end
  end,
})


local prettier = require("prettier")

prettier.setup({
  bin = 'prettier',
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
  cli_options = {
    print_width = 110,
    tab_width = 2,
    use_tabs = false,
    semi = true,
    single_quote = true,
    jsx_single_quote = true,
    trailing_comma = "all",
    bracket_spacing = true,
    bracket_same_line = false,
    arrow_parens = "avoid",
    prose_wrap = "preserve",
    quote_props = "preserve",
  },
  ["null-ls"] = {
    condition = function()
      return prettier.config_exists({
        -- if `false`, skips checking `package.json` for `"prettier"` key
        check_package_json = true,
      })
    end,
    runtime_condition = function(params)
      -- return false to skip running prettier
      return true
    end,
    timeout = 5000,
  },
})


--
-- GIT
--

require('gitsigns').setup()

--
-- Status line
--

require('lualine').setup({
  options = { theme = 'gruvbox' },
  extensions = { 'fzf', 'nvim-tree' },
  sections = {
    lualine_c = { { 'filename', path = 1 } },
  },
  inactive_sections = {
    lualine_c = { { 'filename', path = 2 } },
  },
})

--
-- Tree Sitter
--
require('nvim-treesitter.configs').setup {
  ensure_installed = {},
  sync_install = false,
  auto_install = true,
  ignore_install = {},
  highlight = {
    enable = true,
    disable = {},
  },
}

