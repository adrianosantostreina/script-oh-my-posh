# --- Oh My Posh: tema do Adriano (completo em terminal largo, compacto em terminal estreito) ---
# Pelo SSH as variaveis do terminal local (WT_SESSION, TERM_PROGRAM) nao chegam; decide pela largura.
# Atualizar os temas: git -C ~/script-oh-my-posh pull
if [[ $- == *i* ]]; then
  _posh_shell="bash"
  _posh_bin="oh-my-posh"
  _posh_temas="$HOME/script-oh-my-posh/themes"
  _posh_completo="adriano"
  _posh_compacto="adriano-compact"
  _posh_largura_min=130
  if [ "$(tput cols 2>/dev/null || echo 0)" -ge "$_posh_largura_min" ]; then
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
  unset _posh_shell _posh_bin _posh_temas _posh_completo _posh_compacto _posh_largura_min _posh_tema _posh_cfg
fi
