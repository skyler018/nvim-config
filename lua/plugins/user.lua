return {
  { "RRethy/base16-nvim", lazy = false, priority = 1000 },
  -- 使用 Snacks 作为统一 picker（提供 `<leader>/`、`<leader>sw` 等搜索入口）
  { import = "lazyvim.plugins.extras.editor.snacks_picker" },
  {
    "LazyVim/LazyVim",
    lazy = false,
    priority = 1000,
    opts = {
      colorscheme = "base16-default-dark",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}

      local function add_unique(list, items)
        list = list or {}
        for _, item in ipairs(items) do
          if not vim.tbl_contains(list, item) then
            table.insert(list, item)
          end
        end
        return list
      end

      opts.ensure_installed =
        add_unique(opts.ensure_installed, { "go", "gomod", "gosum", "gowork", "c", "lua", "python" })

      -- 保持与你之前的偏好一致（可选，但无害）
      --opts.sync_install = false
      --opts.auto_install = true
      --opts.ignore_install = { "javascript" }
      --opts.highlight = vim.tbl_deep_extend("force", opts.highlight or {}, {
      --  enable = true,
      --  additional_vim_regex_highlighting = false,
      --})

      return opts
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "folke/snacks.nvim",
    },
    ft = "python",
    cmd = { "VenvSelect", "VenvSelectCached", "VenvSelectLog" },
    opts = {
      settings = {
        options = {
          picker = "snacks",
        },
        search = {
          my_venvs = {
            -- Scan the current project first and a few common workspace roots
            -- instead of traversing the entire home directory on every invocation.
            command = "fd -HI -t d '^\\.venv$' . ~/code ~/work ~/src 2>/dev/null",
          },
        },
      },
    },
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Python venv" },
    },
  },
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { { "nvim-lua/plenary.nvim", lazy = true } },
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>yy",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>yc",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<leader>yu",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    opts = { open_for_directories = false, keymaps = { show_help = "<f1>" } },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons", "nvim-mini/mini.nvim" },
    opts = {},
  },
  {
    "folke/sidekick.nvim",
    event = "VeryLazy",
    opts = {
      cli = {
        tools = {
          coco = {
            cmd = { "coco" },
            title = "Coco AI",
          },
        },
      },
    },
  },
  {
    "nvim-mini/mini.icons",
    lazy = false,
    config = function(_, opts)
      -- LazyVim 会用 mini.icons 去 mock `nvim-web-devicons`。
      -- 但 mock 本身不会创建 `MiniIcons*` 高亮组，导致 Snacks 里图标“有 glyph 没颜色”。
      require("mini.icons").setup(opts)
    end,
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = false, -- 禁用 snacks 的 dashboard 模块
      },
      scroll = {
        enabled = false, -- 关闭 Smooth Scrolling
      },
      picker = {
        sources = {
          files = {
            preview = function(ctx)
              -- Let Snacks apply its built-in TS-or-syntax fallback first.
              require("snacks.picker.preview").file(ctx)

              -- Only force syntax as a last resort when neither Treesitter nor
              -- syntax highlighting got attached to the preview buffer.
              local path = Snacks.picker.util.path(ctx.item)
              if not path or vim.b[ctx.buf].ts_highlight or vim.bo[ctx.buf].syntax ~= "" then
                return
              end
              local ft = vim.filetype.match({ filename = path, buf = ctx.buf })
              if ft == "bigfile" then
                ft = nil
              end
              if ft then
                vim.bo[ctx.buf].syntax = ft
              end
            end,
          },
        },
      },
    },
  },
}
