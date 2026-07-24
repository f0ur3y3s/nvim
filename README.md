# nvim config

Personal Neovim config (targets Neovim 0.12+), managed with
[lazy.nvim](https://github.com/folke/lazy.nvim).

## Table of contents

- [Structure](#structure)
- [Prerequisites](#prerequisites)
- [Plugins](#plugins)
- [Why some of the less obvious choices](#why-some-of-the-less-obvious-choices)
- [Key bindings](#key-bindings)

## Structure

```
init.lua                 entry point: loads config.lazy, then config.settings
lua/config/lazy.lua       bootstraps lazy.nvim, imports lua/plugins/*
lua/config/settings.lua   options, diagnostics config, core keymaps, LspAttach autocmds
lua/plugins/*.lua         one lazy.nvim plugin spec per file (auto-imported)
lsp/*.lua                 native vim.lsp server configs (clangd, lua_ls, ruff)
scripts/setup.sh          Linux prerequisite + bootstrap script
scripts/setup.ps1         Windows prerequisite + bootstrap script
```

`lsp/*.lua` must live at the top-level `lsp/` directory, **not**
`lua/lsp/`. Neovim's native `vim.lsp.config`/`vim.lsp.enable` auto-discover
server configs from `lsp/<name>.lua` on the runtimepath — the same
mechanism as `ftplugin/` or `syntax/` — which is different from normal
`require()`-based Lua module loading under `lua/`. mason-lspconfig's
`automatic_enable` calls `vim.lsp.enable()` for each installed server,
which is what picks these files up.

## Prerequisites

Beyond Neovim 0.12+ itself, `nvim-treesitter` (main branch) compiles parsers
from source on every startup via `tree-sitter build`, which needs two things
on `PATH`: `tree-sitter-cli` (0.26.1+) and a C compiler. Neither ships with
Neovim.

`scripts/setup.sh` (Linux) and `scripts/setup.ps1` (Windows) automate
everything below, then run `Lazy sync` to pull plugins and trigger
parser/Mason installs. Idempotent — safe to re-run.

```sh
# Linux
./scripts/setup.sh

# Windows (PowerShell)
.\scripts\setup.ps1
```

Manual steps, if you'd rather not run the script or want to know what it
does:

**`tree-sitter-cli` — install via `cargo`, not `npm`** (the nvim-treesitter
README is explicit about this). If you don't already have Rust:

```sh
# Linux — official rustup bootstrap
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Windows
winget install --id Rustlang.Rustup -e
```

Then, both platforms:

```sh
cargo install tree-sitter-cli --no-default-features
```

`--no-default-features` skips the `qjs-rt` (QuickJS) feature, which needs
`libclang` for its `bindgen` build step and isn't available on a fresh
system by default. It only disables `tree-sitter generate` (writing new
grammars from `grammar.js`); `tree-sitter build`, the only thing
nvim-treesitter's `install()` actually calls, is unaffected. If you want
`generate` too, install `libclang` first (`apt install libclang-dev` on
Debian/Ubuntu, or `winget install LLVM.LLVM` on Windows) and drop the flag.

Verify with `tree-sitter --version` (want 0.26.1+).

**C compiler:**

- **Linux:** [zig](https://ziglang.org) is the recommended choice —
  `apt`'s version is frequently stale, so check
  `apt-cache policy zig` first; if it's old, download the prebuilt tarball
  from ziglang.org and put `zig` on `PATH` manually (e.g. under
  `~/.local/opt/zig`, symlinked or added to `~/.profile`).
- **Windows:** zig does **not** currently work here — verified directly:
  Rust's `cc` crate (which `tree-sitter build` uses) emits MSVC-style
  4-part target triples (`x86_64-pc-windows-msvc`), and zig's own 3-part
  triple parser rejects them (`UnknownOperatingSystem`), even routed through
  a wrapper script. Install Visual Studio Build Tools' "Desktop development
  with C++" workload instead — the `cc` crate auto-detects it via `vswhere`
  with zero extra config, regardless of `PATH`:
  ```powershell
  winget install --id Microsoft.VisualStudio.2022.BuildTools -e --override "--add Microsoft.VisualStudio.Workload.VCTools --quiet"
  ```
  (skip this if Visual Studio with the "Desktop development with C++"
  workload is already installed — check via
  `& "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64`)

> [!NOTE]
> After installing any of the above, **restart your terminal.** Installers
> update the User/Machine `PATH` in the registry, but already-running
> shells (and anything spawned from them) keep their old, cached
> environment — a classic silent-breakage spot on Windows especially.

## Plugins

- **mini.nvim** — pairs, ai, files, git, diff, icons, statusline, notify,
  trailspace (auto-trim on save), surround, tabline, cursorword, completion,
  snippets, keymap (VSCode-style Tab/Enter completion), align, hipatterns
  (TODO/FIXME/HACK/NOTE highlights)
- **telescope.nvim** + telescope-ui-select — fuzzy finder
- **which-key.nvim** — keymap discovery and most non-mini keybindings
- **flash.nvim** — motion/jump
- **conform.nvim** — format-on-save (stylua, ruff, clang-format, mdformat)
- **mason.nvim** / **mason-lspconfig.nvim** / **mason-tool-installer.nvim** /
  **mason-nvim-dap.nvim** — LSP server, formatter, and DAP adapter installation
- **nvim-dap** / **nvim-dap-ui** (+ nvim-nio) — debugging, UI auto-opens/closes
  with the session (codelldb for C/C++/Rust, debugpy for Python)
- **toggleterm.nvim** — integrated terminal (`<C-\>` or `<leader>tt`)
- **persistence.nvim** — auto-saves/restores buffers, window layout, and cwd
  per-directory (`<leader>qs`/`ql`/`qd`)
- **render-markdown.nvim** — rendered markdown (headers, tables, code fences)
- **nvim-treesitter** (`main` branch) — highlighting, started per-buffer
- **nightfox.nvim** — colorscheme (carbonfox)
- **smear-cursor.nvim**, **alpha-nvim** — cosmetic

## Why some of the less obvious choices

- **nvim-treesitter on `main`, not `master`.** `main` is the actively
  developed rewrite and the branch upstream's own README recommends; it
  doesn't auto-attach highlighting the way the old branch did, hence the
  `FileType` autocmd in `treesitter.lua` calling `vim.treesitter.start()`.
  It also compiles parsers from source rather than shipping prebuilt
  binaries, hence the [Prerequisites](#prerequisites) above.
- **mason.nvim splits installation across three ensure_installed lists.**
  mason.nvim itself has no `ensure_installed` option — it's just the
  registry + `:Mason` UI. mason-lspconfig's `ensure_installed` only accepts
  lspconfig server names and silently skips (with a warning) anything else,
  so it can't install formatters or DAP adapters. mason-tool-installer's
  handles formatters (stylua/clang-format/mdformat); mason-nvim-dap's own
  `ensure_installed` handles DAP adapters (codelldb/python) and — via its
  `default_setup` handler — auto-populates `dap.configurations` for
  c/cpp/rust from its own bundled defaults, so `dap.lua` doesn't need a
  manual `dap.configurations.cpp` block.
- **mdformat over prettier for Markdown.** conform.nvim already shells out
  to `ruff` for Python via Mason; mdformat is also Python-based and
  installs through the same Mason/pip toolchain, so Markdown formatting
  doesn't need to pull in a separate Node/npm dependency just for prettier.
- **toggleterm's `shell` is a detection function, not a fixed string.** The
  default (`vim.o.shell`) is `cmd.exe` on Windows unless overridden;
  `toggleterm.lua` instead prefers `pwsh` over Windows PowerShell on
  Windows, and `$SHELL` (e.g. zsh) on Unix.
- **telescope.nvim pinned to `v0.2.2`, not the older `0.1.8`.** `0.1.8`'s
  file previewer crashes on every buffer (`ft_to_lang` is a nil value) —
  it calls a `nvim-treesitter` function that only exists on the old
  `master` branch, removed by the `main`-branch rewrite this config uses.
  Fixed upstream in `v0.2.0`, which also dropped the `nvim-treesitter`
  dependency for previews entirely.
- **Most plugins are lazy-loaded on `cmd`/`keys`/`ft`/`event`, not eager.**
  telescope (`cmd = "Telescope"`), toggleterm (`cmd`/`keys` on `<c-\>`), and
  the whole DAP stack (`keys` on the `<leader>d*` mappings) only load when
  actually used. Two gotchas that came up getting this right: (1) a plain
  `require(...)` call anywhere — even inside another plugin's `pcall`
  probe — forces immediate load regardless of `keys`/`event`, so
  `which_key.lua` defers its own `require("dap")`/`require("dapui")` calls
  into functions instead of requiring them at the top; (2)
  mason-tool-installer.nvim's `mason-nvim-dap` integration (on by default)
  does exactly that kind of `pcall(require, "mason-nvim-dap...")` probe
  during its own eager `setup()`, which was pulling in nvim-dap/dap-ui/
  mason-nvim-dap at every startup — disabled in `mason.lua` since nothing in
  `mason-tool-installer`'s `ensure_installed` list overlaps with DAP anyway.
  The mason.nvim/mason-lspconfig/mason-tool-installer trio itself is also
  deferred to `event = { "BufReadPre", "BufNewFile" }` (`cmd = "Mason"` too,
  so `:Mason`/`<leader>om` still work standalone) — opening bare `nvim` to
  the alpha dashboard fires neither event, so the whole Mason/LSP chain only
  pays its cost once a real file is opened or created.
- **OSC52 clipboard on WSL, not the stock provider.** Setting `'clipboard'`
  normally triggers Neovim's autoload provider script, which probes for
  win32yank/xclip/xsel/wl-copy/tmux via `executable()`. On WSL that's ~750ms
  of startup time, because each check stats the whole Windows `PATH` WSL
  inherits over the DrvFs bridge. `settings.lua` detects WSL (`has('wsl')`)
  and sets `vim.g.clipboard` to Neovim's built-in OSC52 provider instead —
  no subprocess, no PATH scan. Requires a terminal that supports OSC52
  (Windows Terminal does).
- **persistence.nvim over auto-session/possession.nvim for sessions.** It's
  single-purpose (buffers/windows/tabs/cwd only, no session-name picker to
  manage) and needs no config beyond `opts = {}`. It won't restore toggleterm
  terminal buffers or other plugin UI state — just editor layout. Session
  files live under `stdpath("state")/sessions/`
  (`~/AppData/Local/nvim-data/sessions/` on Windows), keyed by project
  directory + git branch.

## Key bindings

Leader is `<Space>`. Full list lives in `lua/plugins/which_key.lua`;
highlights:

| Key | Action |
|---|---|
| `<leader>ff` / `fg` / `fb` / `fz` | Telescope: files / grep / buffers / fuzzy find in buffer |
| `<leader>e` | Toggle mini.files explorer |
| `<leader>ol` / `om` | Open Lazy / Mason |
| `gd` / `gD` / `gr` / `gi` / `gt` / `gh` | LSP: definition / declaration / references / implementation / type def / hover |
| `<leader>.a` / `.r` / `.s` / `.f` / `.h` | LSP: code action / rename / signature help / format / toggle inlay hints |
| `<leader>db` / `dc` / `di` / `do` / `dO` / `dr` / `du` / `dt` | DAP: breakpoint / continue / step into / step over / step out / REPL / toggle UI / terminate |
| `<c-\>` / `<leader>tt` | Toggle integrated terminal |
| `<leader>tw` | Trim trailing whitespace (shares the `t` prefix with `tt` by coincidence, not a group) |
| `<leader>qs` / `ql` / `qd` | Restore session (cwd) / restore last session / stop autosaving this session |
| `<leader>w...` | Window management (split, resize, close) |
| `<leader>b...` | Buffer management (delete, next/prev, delete all/other) |
| `<C-h/j/k/l>` | Move between windows |
| `<S-j>` / `<S-k>` | Move line/selection down/up |
| `jk` | Escape (insert and terminal mode) |
