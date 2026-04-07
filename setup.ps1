# setup.ps1 -- Bootstrap Claude Code academic workflow on Windows (PowerShell)
#
# Usage (PowerShell):
#   .\setup.ps1
#
# What it does:
#   1. Creates directory junctions in ~/.claude/ for skills, agents, and rules
#      (junctions work without admin privileges, unlike symlinks)
#   2. Appends the workflow section to ~/CLAUDE.md (idempotent)
#
# Note on hooks:
#   .sh hook scripts do not run on Windows. Only Python hooks (.py) work.
#   If you need full hook support, use WSL instead.

$ErrorActionPreference = "Stop"

$RepoDir    = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeGlobal = "$HOME\.claude"
$Marker     = "## Claude Code Workflow (auto-added by setup.sh)"

Write-Host "==> Setting up Claude Code workflow from: $RepoDir"

# ── 1. Directory junctions in ~/.claude/ ─────────────────────────────────────

foreach ($dir in @("skills", "agents", "rules")) {
    $src = "$RepoDir\.claude\$dir"
    $dst = "$ClaudeGlobal\$dir"

    if (Test-Path $dst) {
        $item = Get-Item $dst -Force
        if ($item.LinkType) {
            Write-Host "  [skip] $dst already a junction/symlink"
        } else {
            Write-Host "  [warn] $dst exists and is not a junction -- skipping (resolve manually)"
        }
    } else {
        New-Item -ItemType Junction -Path $dst -Target $src | Out-Null
        Write-Host "  [ok]   $dst --> $src"
    }
}

# ── 2. Append workflow section to ~/CLAUDE.md ────────────────────────────────

$HomeClaude = "$HOME\CLAUDE.md"
$Template   = "$RepoDir\templates\home-claude-md-workflow.md"

if (-not (Test-Path $Template)) {
    Write-Host "  [warn] Template not found: $Template -- skipping CLAUDE.md update"
} else {
    $templateContent = Get-Content $Template -Raw -Encoding UTF8

    if (Test-Path $HomeClaude) {
        $existing = Get-Content $HomeClaude -Raw -Encoding UTF8
        if ($existing -match [regex]::Escape($Marker)) {
            Write-Host "  [skip] Workflow section already present in ~/CLAUDE.md"
        } else {
            Add-Content -Path $HomeClaude -Value "`n$templateContent" -Encoding UTF8
            Write-Host "  [ok]   Appended workflow section to ~/CLAUDE.md"
        }
    } else {
        Set-Content -Path $HomeClaude -Value $templateContent -Encoding UTF8
        Write-Host "  [ok]   Created ~/CLAUDE.md from template"
    }
}

Write-Host ""
Write-Host "==> Done. Skills, agents, and rules are now available in all projects."
Write-Host "    Note: .sh hooks do not run on Windows. Python hooks (.py) work if Python is installed."
Write-Host "    For full hook support, consider using WSL."
