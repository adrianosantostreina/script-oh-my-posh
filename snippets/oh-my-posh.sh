# --- Oh My Posh: tema do Adriano (completo no Windows Terminal, compacto em IDEs) ---
# Serve para Git Bash, WSL (bash) e zsh. Ajuste so as variaveis abaixo.
_posh_shell="bash"                              # bash ou zsh
_posh_bin="oh-my-posh"                          # Git Bash: caminho do oh-my-posh.exe, ex.: /c/Users/SEU_USUARIO/AppData/Local/Programs/oh-my-posh/bin/oh-my-posh.exe
_posh_temas="$HOME/script-oh-my-posh/themes"    # pasta themes deste repositorio (WSL acessando o Windows: /mnt/d/.../themes)
_posh_completo="adriano"                        # tema no Windows Terminal
_posh_compacto="adriano-compact"                # tema no VS Code, Orca, JetBrains e demais terminais embutidos
if [ -n "$WT_SESSION" ] && [ "$TERM_PROGRAM" != "vscode" ] && [ "$TERM_PROGRAM" != "Orca" ] && [ -z "$TERMINAL_EMULATOR" ]; then
  _posh_tema="$_posh_completo"
else
  _posh_tema="$_posh_compacto"
fi
_posh_cfg="$_posh_temas/${_posh_tema}.omp.json"
if [ -f "$_posh_cfg" ]; then
  eval "$("$_posh_bin" init "$_posh_shell" --config "$_posh_cfg")"
else
  eval "$("$_posh_bin" init "$_posh_shell")"    # tema nao encontrado: usa o padrao do Oh My Posh
fi
unset _posh_shell _posh_bin _posh_temas _posh_completo _posh_compacto _posh_tema _posh_cfg
