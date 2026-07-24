#!/usr/bin/env bash
# Installs the system prerequisites this config needs (rustup/cargo,
# tree-sitter-cli, a C compiler), then bootstraps Neovim's own plugins,
# parsers, and Mason tools. Idempotent — safe to re-run.
set -euo pipefail

log() { printf '\n==> %s\n' "$1"; }

# --- rustup / cargo ---------------------------------------------------
if ! command -v cargo >/dev/null 2>&1; then
	log "Installing rustup (cargo not found)"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	# shellcheck source=/dev/null
	source "$HOME/.cargo/env"
else
	log "cargo already installed ($(cargo --version))"
fi

# --- tree-sitter-cli ----------------------------------------------------
# --no-default-features skips the qjs-rt (QuickJS) feature, which needs
# libclang/bindgen and isn't present on a fresh system by default. It only
# disables `tree-sitter generate`; `tree-sitter build` (all nvim-treesitter
# needs) is unaffected.
if ! command -v tree-sitter >/dev/null 2>&1; then
	log "Installing tree-sitter-cli"
	cargo install tree-sitter-cli --no-default-features
else
	log "tree-sitter-cli already installed ($(tree-sitter --version))"
fi

# --- C compiler (zig) -----------------------------------------------
if ! command -v zig >/dev/null 2>&1; then
	log "Installing zig"
	if command -v apt-get >/dev/null 2>&1 && apt-cache policy zig 2>/dev/null | grep -q 'Candidate: [0-9]'; then
		sudo apt-get install -y zig
	else
		# apt's zig is frequently stale (or absent) — fall back to the
		# official prebuilt tarball
		ZIG_INSTALL_DIR="$HOME/.local/opt/zig"
		ZIG_BIN_DIR="$HOME/.local/bin"
		ARCH=$(uname -m)
		INDEX_URL="https://ziglang.org/download/index.json"
		TARBALL_URL=$(curl -fsSL "$INDEX_URL" | grep -o "\"https://ziglang.org/builds/zig-linux-${ARCH}-[0-9a-z.+-]*\.tar\.xz\"" | head -n1 | tr -d '"')
		if [ -z "$TARBALL_URL" ]; then
			echo "Could not resolve a zig tarball URL for arch ${ARCH} — install zig manually." >&2
		else
			mkdir -p "$ZIG_INSTALL_DIR" "$ZIG_BIN_DIR"
			curl -fsSL "$TARBALL_URL" | tar -xJ -C "$ZIG_INSTALL_DIR" --strip-components=1
			ln -sf "$ZIG_INSTALL_DIR/zig" "$ZIG_BIN_DIR/zig"
			if ! grep -q '.local/bin' "$HOME/.profile" 2>/dev/null; then
				echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$HOME/.profile"
			fi
			export PATH="$ZIG_BIN_DIR:$PATH"
		fi
	fi
else
	log "zig already installed ($(zig version))"
fi

# --- Neovim bootstrap: plugins, parsers, Mason tools -------------------
# mason-lspconfig/mason-tool-installer/mason-nvim-dap are lazy-loaded (on a
# buffer event or a <leader>d* keypress, see mason.lua/dap.lua) — a bare
# `Lazy sync` downloads them but never runs their setup(), so their
# ensure_installed lists (LSP servers, formatters, DAP adapters) wouldn't
# get installed. Force-load them once, headlessly, right after sync.
log "Running Lazy sync (installs plugins, triggers parser/tool installs)"
nvim --headless \
	"+Lazy! sync" \
	"+lua require('lazy.core.loader').load({ 'mason-lspconfig.nvim', 'mason-tool-installer.nvim', 'mason-nvim-dap.nvim' }, { command = 'setup.sh' })" \
	+qa

log "Done. Restart your terminal so PATH updates take effect everywhere."
