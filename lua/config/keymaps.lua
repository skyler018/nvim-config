-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 搜索当前光标下的单词 / 可视选择（走 LazyVim.pick -> Snacks picker）
vim.keymap.set({ "n", "x" }, "<leader>sw", LazyVim.pick("grep_word"), { desc = "Search word/selection (Root Dir)" })
