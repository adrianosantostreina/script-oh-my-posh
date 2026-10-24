#!/bin/bash
# Banner de entrada do terminal (WSL e VPS): resumo rapido do ambiente.
# Chamado pelo ~/.profile. Fica em silencio fora de terminal interativo (use -f para forcar).
# Depende so de /proc, df, free, uptime e awk (nao precisa de sysstat/sar).
[ "$1" = "-f" ] || [ -t 1 ] || exit 0

JANELA=2            # segundos de medicao de CPU e rede
LARGURA_BARRA=10
LARGURA_ROTULO=14

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

if grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null; then AMBIENTE=WSL; else AMBIENTE=VPS; fi
sistema=$( . /etc/os-release 2>/dev/null; printf '%s' "${PRETTY_NAME:-$(uname -s)}" )

# ---- cabecalho ----
sep=''
for ((i = 0; i < 56; i++)); do sep+="─"; done
printf '%s%s - Adriano Santos Treinamentos%s\n' "$TITULO" "$AMBIENTE" "$R"
printf '%s%s%s\n' "$ROTULO" "$sep" "$R"

# ---- dados estaticos ----
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

# ---- medicao (CPU e rede na mesma janela) ----
net0=$(cat /proc/net/dev)
read -r t0 i0 <<< "$(snap_cpu)"
sleep "$JANELA"
read -r t1 i1 <<< "$(snap_cpu)"
net1=$(cat /proc/net/dev)

dt=$((t1 - t0)); di=$((i1 - i0))
if [ "$dt" -gt 0 ]; then cpu_pct=$(( (100 * (dt - di) + dt / 2) / dt )); else cpu_pct=0; fi
linha "CPU" "$(barra "$cpu_pct") ${cpu_pct}%  (média de ${JANELA}s)"

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
echo
