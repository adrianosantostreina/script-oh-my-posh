# --- Oh My Posh: tema do Adriano (completo no Windows Terminal, compacto em IDEs) ---
# Cole no $PROFILE do PowerShell. Ajuste so as variaveis abaixo.
$PoshTemas = "$HOME\script-oh-my-posh\themes"   # pasta themes deste repositorio
$PoshTemaCompleto = 'adriano'                   # tema no Windows Terminal
$PoshTemaCompacto = 'adriano-compact'           # tema no VS Code, Orca, JetBrains e demais terminais embutidos
$PoshEhWindowsTerminal = $env:WT_SESSION -and ($env:TERM_PROGRAM -notin @('vscode', 'Orca')) -and (-not $env:TERMINAL_EMULATOR)
$PoshTema = if ($PoshEhWindowsTerminal) { $PoshTemaCompleto } else { $PoshTemaCompacto }
$PoshConfig = Join-Path $PoshTemas "$PoshTema.omp.json"
if (Test-Path $PoshConfig) {
    oh-my-posh init pwsh --config $PoshConfig | Invoke-Expression
} else {
    oh-my-posh init pwsh | Invoke-Expression    # tema nao encontrado: usa o padrao do Oh My Posh
}
