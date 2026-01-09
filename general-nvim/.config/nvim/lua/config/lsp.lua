local utils = require("utils")

-- 1. Protect against crash if lspconfig is missing
local status, lspconfig = pcall(require, "lspconfig")
if not status then return end

-- 2. Configure Global Native LSP behavior
vim.lsp.config("*", {
  capabilities = require("lsp_utils").get_default_capabilities(),
})

-- 3. Create the Attachment Logic (Keymaps + Format on Save)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_buf_conf", { clear = true }),
  callback = function(event_context)
    local client = vim.lsp.get_client_by_id(event_context.data.client_id)
    if not client then return end

    local bufnr = event_context.buf
    local map = function(mode, l, r, opts)
      opts = vim.tbl_extend("force", { silent = true, buffer = bufnr }, opts or {})
      vim.keymap.set(mode, l, r, opts)
    end

    -- Custom Go-To-Definition logic
    map("n", "gd", function()
      vim.lsp.buf.definition {
        on_list = function(options)
          local unique_defs, def_loc_hash = {}, {}
          for _, def_location in pairs(options.items) do
            local key = def_location.filename .. def_location.lnum
            if not def_loc_hash[key] then
              def_loc_hash[key] = true
              table.insert(unique_defs, def_location)
            end
          end
          options.items = unique_defs
          vim.fn.setloclist(0, {}, " ", options)
          if #options.items > 1 then vim.cmd.lopen() else vim.cmd([[silent! lfirst]]) end
        end,
      }
    end, { desc = "unique definition" })

    -- Standard Mappings
    map("n", "K", function() vim.lsp.buf.hover({ border = "single" }) end)
    map("n", "<space>rn", vim.lsp.buf.rename, { desc = "rename" })
    map("n", "<space>ca", vim.lsp.buf.code_action, { desc = "code action" })

    -- Format on save logic
    -- FIX: Used colon (:) instead of dot (.)
    if client:supports_method("textDocument/formatting") then
      local format_grp = vim.api.nvim_create_augroup("LspFormatting_" .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_grp,
        buffer = bufnr,
        callback = function()
          -- FIX: Async must be false to prevent undo history corruption
          vim.lsp.buf.format({ 
            bufnr = bufnr, 
            async = false, 
            timeout_ms = 2000 
          })
        end,
      })
    end
  end,
})

-- 4. Define and Enable Servers
local servers = {
  pyright = { cmd = { "pyright-langserver", "--stdio" } },
  ruff = { cmd = { "ruff", "server" } },
  marksman = { cmd = { "marksman", "server" } },
  bashls = { cmd = { "bash-language-server", "start" } },

  -- Lua setup
  lua_ls = {
    cmd = { "lua-language-server" },
    settings = {
      Lua = {
        format = { enable = true },
        diagnostics = {
          disable = { "duplicate-set-field" },
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
        },
      },
    },
  },

  yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    settings = { yaml = { format = { enable = true } } }
  },

  nixd = {
    cmd = { "nixd" },
    settings = {
      nixd = {
        formatting = { command = { "nixpkgs-fmt" } },
      },
    },
  },
}

for name, config in pairs(servers) do
  vim.lsp.config(name, config)
  if utils.executable(config.cmd[1]) then
    vim.lsp.enable(name)
  end
end
