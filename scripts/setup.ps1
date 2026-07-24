# Installs the system prerequisites this config needs (rustup/cargo,
# tree-sitter-cli, MSVC Build Tools), then bootstraps Neovim's own plugins,
# parsers, and Mason tools. Idempotent - safe to re-run.
$ErrorActionPreference = "Stop"

function Write-Step($msg) {
    Write-Host "`n==> $msg" -ForegroundColor Cyan
}

function Update-SessionPath {
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
                [System.Environment]::GetEnvironmentVariable('Path', 'User')
}

# --- rustup / cargo -----------------------------------------------------
if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) {
    Write-Step "Installing rustup (cargo not found)"
    winget install --id Rustlang.Rustup -e --accept-source-agreements --accept-package-agreements
    Update-SessionPath
} else {
    Write-Step "cargo already installed ($(cargo --version))"
}

# --- tree-sitter-cli ------------------------------------------------------
# --no-default-features skips the qjs-rt (QuickJS) feature, which needs
# libclang/bindgen and isn't present on a fresh system by default. It only
# disables `tree-sitter generate`; `tree-sitter build` (all nvim-treesitter
# needs) is unaffected.
if (-not (Get-Command tree-sitter -ErrorAction SilentlyContinue)) {
    Write-Step "Installing tree-sitter-cli"
    cargo install tree-sitter-cli --no-default-features
    Update-SessionPath
} else {
    Write-Step "tree-sitter-cli already installed ($(tree-sitter --version))"
}

# --- C compiler (MSVC Build Tools) ---------------------------------------
# zig doesn't work here: Rust's `cc` crate emits MSVC-style 4-part target
# triples that zig's target parser rejects. MSVC Build Tools' "Desktop
# development with C++" workload is auto-detected via vswhere with zero
# extra PATH/env config.
$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$hasVCTools = $false
if (Test-Path $vswhere) {
    $found = & $vswhere -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
    $hasVCTools = -not [string]::IsNullOrWhiteSpace($found)
}
if (-not $hasVCTools) {
    Write-Step "Installing Visual Studio Build Tools (Desktop development with C++)"
    winget install --id Microsoft.VisualStudio.2022.BuildTools -e --accept-source-agreements --accept-package-agreements `
        --override "--add Microsoft.VisualStudio.Workload.VCTools --quiet"
} else {
    Write-Step "MSVC Build Tools (VC.Tools.x86.x64) already installed"
}

# --- Neovim bootstrap: plugins, parsers, Mason tools ---------------------
# mason-lspconfig/mason-tool-installer/mason-nvim-dap are lazy-loaded (on a
# buffer event or a <leader>d* keypress, see mason.lua/dap.lua) - a bare
# `Lazy sync` downloads them but never runs their setup(), so their
# ensure_installed lists (LSP servers, formatters, DAP adapters) wouldn't
# get installed. Force-load them once, headlessly, right after sync.
Write-Step "Running Lazy sync (installs plugins, triggers parser/tool installs)"
nvim --headless `
    "+Lazy! sync" `
    "+lua require('lazy.core.loader').load({ 'mason-lspconfig.nvim', 'mason-tool-installer.nvim', 'mason-nvim-dap.nvim' }, { command = 'setup.ps1' })" `
    +qa

Write-Step "Done. Restart your terminal so PATH updates take effect everywhere."
