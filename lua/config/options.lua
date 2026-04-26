-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Ensure Python user bin (latex2text, etc.) is on PATH
vim.env.PATH = vim.fn.expand("$HOME") .. "/Library/Python/3.9/bin:" .. vim.env.PATH

-- 关闭相对行号（保留绝对行号）
vim.opt.number = true
vim.opt.relativenumber = false

-- 让 Neovim 的背景始终“跟随终端背景”（透明）。
-- 这样 WezTerm 在全屏/非全屏切换时的背景/透明度变化，会自然透传到 nvim。
local function apply_transparent_background()
  local groups = {
    -- 主窗口
    "Normal",
    "NormalNC",
    "EndOfBuffer",
    "SignColumn",
    "FoldColumn",
    "LineNr",
    "CursorLineNr",
    "WinSeparator",
    "VertSplit",
    "StatusLine",
    "StatusLineNC",
    "TabLine",
    "TabLineFill",
    "TabLineSel",

    -- 浮窗/弹窗
    "NormalFloat",
    "FloatBorder",
    "Pmenu",
    "PmenuSbar",
    "PmenuThumb",
  }

  for _, name in ipairs(groups) do
    -- 仅覆盖背景，避免破坏前景色与其他属性
    pcall(vim.api.nvim_set_hl, 0, name, { bg = "none" })
  end
end

-- 颜色主题每次切换/加载后都重应用一次（LazyVim 在启动时也会触发 ColorScheme）
local aug = vim.api.nvim_create_augroup("user_transparent_background", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = aug,
  callback = apply_transparent_background,
})

