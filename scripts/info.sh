#!/bin/bash
# Banner de entrada do terminal (WSL, VPS e Windows/Git Bash): resumo rapido do ambiente.
# Linux: chamado pelo ~/.profile. Git Bash: chamado pelo ~/.bashrc.
# Fica em silencio fora de terminal interativo (use -f para forcar).
# Linux depende so de /proc, df, free, uptime e awk (nao precisa de sysstat/sar).
# Git Bash usa /proc, df, netstat e, se existir, nvidia-smi.
[ "$1" = "-f" ] || [ -t 1 ] || exit 0

JANELA=2            # segundos de medicao de CPU e rede
LARGURA_BARRA=10
LARGURA_ROTULO=14

case "$(uname -s)" in
  MINGW* | MSYS* | CYGWIN*) WINDOWS=1; JANELA=1 ;;   # processos no Windows sao lentos: janela menor
  *) WINDOWS=0 ;;
esac

# Cores (paleta Night Owl). Sem cor se NO_COLOR estiver definido ou a saida nao for terminal.
if [ -t 1 ] && [ -z "$NO_COLOR" ]; then
  R=$'\e[0m'; TITULO=$'\e[1;38;2;33;199;168m'; ROTULO=$'\e[38;2;99;119;119m'
  OK=$'\e[38;2;34;218;110m'; AVISO=$'\e[38;2;236;196;141m'; ERRO=$'\e[38;2;239;83;80m'
  SETA=$'\e[38;2;130;170;255m'
else
  R=; TITULO=; ROTULO=; OK=; AVISO=; ERRO=; SETA=
fi

# linha ROTULO VALOR : rotulo alinhado em coluna fixa
linha() {
  local rot="$1" pad
  pad=$((LARGURA_ROTULO - ${#rot}))
  [ "$pad" -lt 1 ] && pad=1
  printf '%s%s%*s%s%s\n' "$ROTULO" "$rot" "$pad" '' "$R" "$2"
}

# barra PERCENTUAL : [██████░░░░] verde < 60, amarelo < 85, vermelho >= 85
barra() {
  local p=$1 cheio i cor c='' v=''
  [ "$p" -gt 100 ] && p=100
  [ "$p" -lt 0 ] && p=0
  cheio=$(( (p * LARGURA_BARRA + 50) / 100 ))
  if [ "$p" -ge 85 ]; then cor=$ERRO; elif [ "$p" -ge 60 ]; then cor=$AVISO; else cor=$OK; fi
  for ((i = 0; i < LARGURA_BARRA; i++)); do
    if [ "$i" -lt "$cheio" ]; then c+="█"; else v+="░"; fi
  done
  printf '%s%s%s%s%s' "$cor" "$c" "$ROTULO" "$v" "$R"
}

# taxa BYTES_POR_SEGUNDO : formata em B/s, kB/s ou MB/s
taxa() {
  awk -v b="$1" 'BEGIN {
    if (b >= 1048576) printf "%.1f MB/s", b / 1048576
    else if (b >= 1024) printf "%.1f kB/s", b / 1024
    else printf "%.0f B/s", b
  }'
}

snap_cpu() {   # imprime: total_de_ticks ticks_ociosos
  awk '/^cpu / { t = 0; for (i = 2; i <= 9; i++) t += $i; print t, $5 + $6 }' /proc/stat
}

# ---- apoio so do Windows (Git Bash) ----

# gib KB : kilobytes -> "6.5G" ou "32G"
gib() { awk -v k="$1" 'BEGIN { g = k / 1048576; if (g >= 10) printf "%.0fG", g; else printf "%.1fG", g }'; }

# duracao SEGUNDOS : "2 days, 11 hours, 54 minutes"
duracao() {
  local s=${1%.*} d h m out=""
  d=$((s / 86400)); h=$(((s % 86400) / 3600)); m=$(((s % 3600) / 60))
  [ "$d" -gt 0 ] && out+="$d day$([ "$d" -ne 1 ] && echo s), "
  [ "$h" -gt 0 ] && out+="$h hour$([ "$h" -ne 1 ] && echo s), "
  out+="$m minute$([ "$m" -ne 1 ] && echo s)"
  printf '%s' "$out"
}

# listar_discos : "C: 93 1.9T 1.7T 136G" (letra, % usado, total, usado, livre); ignora Google Drive e afins
listar_discos() {
  df -hP 2>/dev/null | awk '{
    m = $NF
    if (m == "/") d = "C:"
    else if (m ~ /^\/[a-z]$/) d = toupper(substr(m, 2, 1)) ":"
    else next
    p = $(NF - 1); sub(/%/, "", p)
    t = $(NF - 4); u = $(NF - 3); l = $(NF - 2)
    gsub(/,/, ".", t); gsub(/,/, ".", u); gsub(/,/, ".", l)
    print d, p, t, u, l
  }'
}

# percentual formatado com cor de alerta (usado na linha unica das IDEs)
pct_colorido() {
  local p=$1 cor=$OK
  if [ "$p" -ge 90 ]; then cor=$ERRO; elif [ "$p" -ge 75 ]; then cor=$AVISO; fi
  printf '%s%s%%%s' "$cor" "$p" "$R"
}

snap_net_win() { netstat -e 2>/dev/null | awk '/^Bytes/ { print $2, $3; exit }'; }

if [ "$WINDOWS" = 1 ]; then
  # Banner completo so no Windows Terminal; em IDEs (VS Code, Orca, JetBrains) so uma linha.
  if [ -n "$WT_SESSION" ] && [ "$TERM_PROGRAM" != "vscode" ] && [ "$TERM_PROGRAM" != "Orca" ] && [ -z "$TERMINAL_EMULATOR" ]; then
    COMPLETO=1
  else
    COMPLETO=0
  fi

  if [ "$COMPLETO" != 1 ]; then
    read -r m_total m_livre <<< "$(awk '/^MemTotal/ { t = $2 } /^MemFree/ { f = $2 } END { print t, f }' /proc/meminfo)"
    resumo="${TITULO}Windows${R}  ${ROTULO}RAM${R} $(gib "$m_livre") livres de $(gib "$m_total")"
    while read -r d p _; do
      resumo+="  ${ROTULO}·${R}  ${ROTULO}${d}${R} $(pct_colorido "$p")"
    done <<< "$(listar_discos)"
    printf '%s\n' "$resumo"
    exit 0
  fi
fi

if [ "$WINDOWS" = 1 ]; then
  AMBIENTE=Windows
elif grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null; then
  AMBIENTE=WSL
else
  AMBIENTE=VPS
fi

# ---- cabecalho ----
sep=''
for ((i = 0; i < 56; i++)); do sep+="─"; done
printf '%s%s - Adriano Santos Treinamentos%s\n' "$TITULO" "$AMBIENTE" "$R"
printf '%s%s%s\n' "$ROTULO" "$sep" "$R"

# ---- dados estaticos ----
if [ "$WINDOWS" = 1 ]; then
  build=$(uname -s); build=${build##*-}
  if [ "$build" -ge 22000 ] 2>/dev/null; then versao=11; else versao=10; fi
  linha "Usuário"   "${USERNAME:-${USER:-$(id -un)}}@$(hostname)"
  fuso=$(date '+%z')   # %Z vem vazio no Git Bash; usa o deslocamento (-0300 -> UTC-03:00)
  linha "Data"      "$(date '+%d/%m/%Y  %H:%M:%S') (UTC${fuso:0:3}:${fuso:3:2})"
  linha "Uptime"    "$(duracao "$(cut -d' ' -f1 /proc/uptime)")"
  linha "Sistema"   "Windows $versao (build $build)"
  linha "Diretório" "$(cygpath -w "$PWD" 2>/dev/null || echo "$PWD")"
  echo

  while read -r d p total usado livre; do
    aviso=""
    [ "$p" -ge 90 ] && aviso="  ${ERRO}⚠${R}"
    linha "Disco $d" "$(barra "$p") ${p}%  ${usado} de ${total}, ${livre} livres${aviso}"
  done <<< "$(listar_discos)"

  read -r m_total m_livre <<< "$(awk '/^MemTotal/ { t = $2 } /^MemFree/ { f = $2 } END { print t, f }' /proc/meminfo)"
  m_pct=$(( (m_total - m_livre) * 100 / m_total ))
  linha "RAM" "$(barra "$m_pct") ${m_pct}%  $(gib $((m_total - m_livre))) de $(gib "$m_total"), $(gib "$m_livre") livres"
else
  sistema=$( . /etc/os-release 2>/dev/null; printf '%s' "${PRETTY_NAME:-$(uname -s)}" )
  linha "Usuário"   "${USER:-$(id -un)}@$(hostname)"
  linha "Data"      "$(date '+%d/%m/%Y  %H:%M:%S (%Z)')"
  linha "Uptime"    "$(uptime -p | sed 's/^up //')"
  linha "Sistema"   "$sistema"
  linha "Kernel"    "$(uname -r)"
  linha "Diretório" "$PWD"
  echo

  read -r d_total d_usado d_livre d_pct _ <<< "$(df -hP / | awk 'NR == 2 { print $2, $3, $4, $5 }')"
  linha "Disco (/)" "$(barra "${d_pct%\%}") ${d_pct}  ${d_usado} de ${d_total}, ${d_livre} livres"

  read -r m_total m_usado m_disp <<< "$(free -h --si | awk '/^Mem/ { print $2, $3, $7 }')"
  m_pct=$(free -b | awk '/^Mem/ { printf "%d", $3 * 100 / $2 }')
  linha "RAM" "$(barra "$m_pct") ${m_pct}%  ${m_usado} de ${m_total}, ${m_disp} disponíveis"
fi

# ---- medicao (CPU e rede na mesma janela) ----
if [ "$WINDOWS" = 1 ]; then
  read -r rx0 tx0 <<< "$(snap_net_win)"
else
  net0=$(cat /proc/net/dev)
fi
read -r t0 i0 <<< "$(snap_cpu)"
sleep "$JANELA"
read -r t1 i1 <<< "$(snap_cpu)"
if [ "$WINDOWS" = 1 ]; then
  read -r rx1 tx1 <<< "$(snap_net_win)"
else
  net1=$(cat /proc/net/dev)
fi

dt=$((t1 - t0)); di=$((i1 - i0))
if [ "$dt" -gt 0 ]; then cpu_pct=$(( (100 * (dt - di) + dt / 2) / dt )); else cpu_pct=0; fi
linha "CPU" "$(barra "$cpu_pct") ${cpu_pct}%  (média de ${JANELA}s)"

if [ "$WINDOWS" = 1 ]; then
  # GPU NVIDIA (opcional)
  if command -v nvidia-smi >/dev/null 2>&1; then
    IFS=, read -r g_nome g_uso g_temp g_mem g_memt <<< "$(nvidia-smi --query-gpu=name,utilization.gpu,temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null | head -1 | tr -d '\r')"
    if [ -n "$g_uso" ]; then
      g_nome=${g_nome# }; g_nome=${g_nome#NVIDIA }; g_nome=${g_nome#GeForce }
      g_uso=${g_uso// /}; g_temp=${g_temp// /}; g_mem=${g_mem// /}; g_memt=${g_memt// /}
      linha "GPU" "$(barra "$g_uso") ${g_uso}%  ${g_temp}°C  ${g_nome}, $(gib $((g_mem * 1024))) de $(gib $((g_memt * 1024))) de VRAM"
    fi
  fi

  # rede: bytes totais de todas as interfaces (netstat -e)
  if [ -n "$rx0" ] && [ -n "$rx1" ]; then
    linha "Rede" "$(printf '%-7s %s↓%s %10s   %s↑%s %10s' "todas" "$SETA" "$R" "$(taxa $(((rx1 - rx0) / JANELA)))" "$SETA" "$R" "$(taxa $(((tx1 - tx0) / JANELA)))")"
  else
    linha "Rede" "(indisponível)"
  fi

  # ferramentas de desenvolvimento (so as que existirem)
  ferr=("bash ${BASH_VERSION%%(*}")
  v=$(git --version 2>/dev/null | awk '{ print $3 }'); v=${v%%.windows*}
  [ -n "$v" ] && ferr+=("git $v")
  v=$(node -v 2>/dev/null); v=${v#v}
  [[ "$v" =~ ^[0-9] ]] && ferr+=("node $v")
  v=$(python --version 2>/dev/null | awk '{ print $2 }')
  [[ "$v" =~ ^[0-9] ]] && ferr+=("python $v")
  txt=""
  for f in "${ferr[@]}"; do txt+="${txt:+  ·  }$f"; done
  linha "Ferramentas" "$txt"
else
  # so interfaces "de verdade": ignora lo, docker, veth, bridges e afins
  rede=$(awk -v j="$JANELA" '
    { sub(/:/, " ") }
    $1 ~ /^(lo|veth|br-|docker|virbr|cni|flannel|tunl|sit|ifb)/ { next }
    $2 !~ /^[0-9]+$/ { next }
    FNR == NR { rx0[$1] = $2; tx0[$1] = $10; next }
    ($1 in rx0) { printf "%s %.0f %.0f\n", $1, ($2 - rx0[$1]) / j, ($10 - tx0[$1]) / j }
  ' <(printf '%s\n' "$net0") <(printf '%s\n' "$net1"))

  if [ -n "$rede" ]; then
    rot="Rede"
    while read -r ifc rx tx; do
      linha "$rot" "$(printf '%-7s %s↓%s %10s   %s↑%s %10s' "$ifc" "$SETA" "$R" "$(taxa "$rx")" "$SETA" "$R" "$(taxa "$tx")")"
      rot=""
    done <<< "$rede"
  else
    linha "Rede" "(nenhuma interface ativa)"
  fi
fi
echo
