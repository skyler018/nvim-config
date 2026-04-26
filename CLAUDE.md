# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration based on [LazyVim](https://github.com/LazyVim/LazyVim). It uses [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager.

## Architecture

```
init.lua                    → bootstraps lazy.nvim, then delegates to lua/config/lazy.lua
lua/config/lazy.lua         → lazy.nvim setup: imports LazyVim core + custom plugins from lua/plugins/
lua/config/options.lua      → Neovim options (transparent bg, line numbers)
lua/config/keymaps.lua      → custom keymaps beyond LazyVim defaults
lua/config/autocmds.lua     → custom autocmds (currently empty placeholder)
lua/config/regex_files.lua  → reusable module: regex-based file search via Snacks picker + ripgrep
lua/plugins/init.lua        → plugin entry point; imports user + regex_files plugin specs
lua/plugins/user.lua        → main plugin specs: colorscheme, treesitter, pickers, tools
lua/plugins/regex_files.lua → binds `<leader>ff` and `:RegexFiles` to the regex_files module
```

**Startup flow**: `init.lua` loads `lua/config/lazy.lua`, which sets up lazy.nvim with two import sources: the full LazyVim distribution (`lazyvim.plugins`) and the local `lua/plugins/` directory. LazyVim-provided `options`, `keymaps`, and `autocmds` run first, then local overrides in `lua/config/` are loaded on `VeryLazy`.

## Key customizations

- **Colorscheme**: TokyoNight with `transparent = true`. A `ColorScheme` autocmd in `options.lua` forces background to `none` on many highlight groups for terminal transparency.
- **Line numbers**: absolute only (relative numbers disabled).
- **Picker**: Uses LazyVim's Snacks picker extra (`lazyvim.plugins.extras.editor.snacks_picker`). The custom `<leader>sw` mapping searches the current word via Snacks.
- **Regex Files** (`<leader>ff` / `:RegexFiles`): custom live-grep picker that uses `rg --files` to list all project files, then filters them client-side with a user-typed regex via `rg --regexp`. Defined in `lua/config/regex_files.lua` and bound in `lua/plugins/regex_files.lua`.
- **Treesitter**: ensures `go`, `gomod`, `gosum`, `gowork`, `c`, `lua`, `python` parsers are installed.
- **Python venv**: `venv-selector.nvim` with `<leader>vs` mapping, uses Snacks as the picker backend, scoped to `~/code`, `~/work`, `~/src`.
- **Sidekick**: AI assistant extra enabled via `lazyvim.json` extras.

## Formatting

Format Lua files with [StyLua](https://github.com/JohnnyMorganz/StyLua):

```
stylua .
```

Config in `stylua.toml`: 2-space indent, 120-char column width.

## Plugin management

- Plugin versions are pinned in `lazy-lock.json` (auto-generated, gitignored for portability across machines).
- Extras are declared in `lazyvim.json` (imports LazyVim extras like `editor.snacks_picker` and `ai.sidekick`).
- `:Lazy` opens the plugin manager UI; `:Lazy check` checks for updates; `:Lazy sync` installs missing and cleans unused plugins.
