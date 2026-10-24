#!/bin/bash
# Painel lateral ao vivo (Windows / Git Bash): discos, RAM, CPU, GPU, rede e processos que mais usam memoria.
# Feito para rodar num painel estreito do Windows Terminal (veja a acao "Git Bash + Painel" no README).
# Redesenha no lugar, sem piscar. Ctrl+C sai. Use -1 para desenhar uma vez e sair (teste).
[ "$1" = "-1" ] && UMA_VEZ=1
[ -t 1 ] || [ -n "$UMA_VEZ" ] || exit 0

case "$(uname -s)" in
  MINGW* | MSYS* | CYGWIN*) ;;
  *) echo "painel.sh e so para Windows (Git Bash)."; exit 1 ;;
esac

JANELA=2            # segundos entre atualizacoes (tambem a janela de medicao de CPU e rede)
LARGURA_BARRA=10
LARGURA=34          # largura do desenho (separadores)

if [ -t 1 ] && [ -z "$NO_COLOR" ]; then
  R=$'\e[0m'; TITULO=$'\e[1;38;2;33;199;168m'; ROTULO=$'\e[38;2;99;119;119m'
  OK=$'\e[38;2;34;218;110m'; AVISO=$'\e[38;2;236;196;141m'; ERRO=$'\e[38;2;239;83;80m'
  SETA=$'\e[38;2;130;170;255m'; TXT=$'\e[38;2;214;222;235m'
else
  R=; TITULO=; ROTULO=; OK=; AVISO=; ERRO=; SETA=; TXT=
fi

barra() {   # PERCENTUAL -> [██████░░░░] verde < 60, amarelo < 85, vermelho >= 85
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

taxa() {    # BYTES_POR_SEGUNDO -> B/s, kB/s ou MB/s
  awk -v b="$1" 'BEGIN {
    if (b >= 1048576) printf "%.1f MB/s", b / 1048576
    else if (b >= 1024) printf "%.1f kB/s", b / 1024
    else printf "%.0f B/s", b
  }'
}

gib() { awk -v k="$1" 'BEGIN { g = k / 1048576; if (g >= 10) printf "%.0fG", g; else printf "%.1fG", g }'; }   # KB -> 6.5G

curto() {   # SEGUNDOS -> 2d 12h 4m
  local s=${1%.*} d h m
  d=$((s / 86400)); h=$(((s % 86400) / 3600)); m=$(((s % 3600) / 60))
  if [ "$d" -gt 0 ]; then printf '%dd %dh %dm' "$d" "$h" "$m"; elif [ "$h" -gt 0 ]; then printf '%dh %dm' "$h" "$m"; else printf '%dm' "$m"; fi
}

snap_cpu()     { awk '/^cpu / { t = 0; for (i = 2; i <= 9; i++) t += $i; print t, $5 + $6 }' /proc/stat; }
snap_net_win() { netstat -e 2>/dev/null | awk '/^Bytes/ { print $2, $3; exit }'; }

listar_discos() {   # "C: 93 1.9T 1.7T 136G"
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

topmem() {  # 5 processos que mais usam memoria, somando todas as instancias do mesmo nome: "1234 chrome.exe" (MB)
  tasklist //FO CSV //NH 2>/dev/null | awk -F'","' '{
    n = $1; gsub(/^"/, "", n); m = $5; gsub(/[^0-9]/, "", m); mem[n] += m
  } END { for (n in mem) printf "%d %s\n", mem[n] / 1024, n }' | sort -rn | head -5
}

# ---- desenho ----
F=""
lin()  { F+="$1"$'\e[K\n'; }                          # linha do quadro (limpa o resto da linha)
sec()  { lin "${ROTULO}$1${R}"; }                      # titulo de secao
sep=""; for ((i = 0; i < LARGURA; i++)); do sep+="─"; done

desenhar() {
  F=""
  lin "${TITULO}Painel · Windows${R}   ${ROTULO}$(date '+%H:%M:%S')${R}"
  lin "${ROTULO}${sep}${R}"

  sec "Disco"
  while read -r d p total usado livre; do
    aviso=""; [ "$p" -ge 90 ] && aviso=" ${ERRO}⚠${R}"
    lin " ${TXT}${d}${R} $(barra "$p") ${p}%${aviso}"
    lin "    ${ROTULO}${livre} livres de ${total}${R}"
  done <<< "$(listar_discos)"

  sec "Memória"
  lin " ${TXT}RAM${R} $(barra "$m_pct") ${m_pct}%"
  lin "     ${ROTULO}$(gib "$m_livre") livres de $(gib "$m_total")${R}"

  sec "Processamento"
  lin " ${TXT}CPU${R} $(barra "$cpu_pct") ${cpu_pct}%"
  if [ -n "$g_uso" ]; then
    lin " ${TXT}GPU${R} $(barra "$g_uso") ${g_uso}%  ${ROTULO}${g_temp}°C${R}"
    lin "     ${ROTULO}$(gib $((g_mem * 1024))) de $(gib $((g_memt * 1024))) VRAM${R}"
  fi

  sec "Rede"
  if [ -n "$rx_s" ]; then
    lin " ${SETA}↓${R} $(taxa "$rx_s")"
    lin " ${SETA}↑${R} $(taxa "$tx_s")"
  else
    lin " ${ROTULO}(indisponível)${R}"
  fi

  sec "Mais memória"
  while read -r mb nome; do
    [ -z "$nome" ] && continue
    nome=${nome:0:20}
    lin "$(printf ' %s%-20s%s %6s' "$TXT" "$nome" "$R" "$(gib $((mb * 1024)))")"
  done <<< "$(topmem)"

  lin "${ROTULO}${sep}${R}"
  lin " ${ROTULO}uptime $(curto "$(cut -d' ' -f1 /proc/uptime)")${R}"
}

if [ -z "$UMA_VEZ" ]; then
  printf '\e[?25l\e[2J'                                  # esconde o cursor e limpa a tela
  trap 'printf "\e[?25h\e[0m\n"; exit 0' INT TERM EXIT
fi

while true; do
  read -r rx0 tx0 <<< "$(snap_net_win)"
  read -r t0 i0 <<< "$(snap_cpu)"
  sleep "$JANELA"
  read -r t1 i1 <<< "$(snap_cpu)"
  read -r rx1 tx1 <<< "$(snap_net_win)"

  dt=$((t1 - t0)); di=$((i1 - i0))
  if [ "$dt" -gt 0 ]; then cpu_pct=$(( (100 * (dt - di) + dt / 2) / dt )); else cpu_pct=0; fi

  rx_s=""; tx_s=""
  if [ -n "$rx0" ] && [ -n "$rx1" ]; then rx_s=$(((rx1 - rx0) / JANELA)); tx_s=$(((tx1 - tx0) / JANELA)); fi

  read -r m_total m_livre <<< "$(awk '/^MemTotal/ { t = $2 } /^MemFree/ { f = $2 } END { print t, f }' /proc/meminfo)"
  m_pct=$(( (m_total - m_livre) * 100 / m_total ))

  g_uso=""
  if command -v nvidia-smi >/dev/null 2>&1; then
    IFS=, read -r g_nome g_uso g_temp g_mem g_memt <<< "$(nvidia-smi --query-gpu=name,utilization.gpu,temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null | head -1 | tr -d '\r')"
    g_uso=${g_uso// /}; g_temp=${g_temp// /}; g_mem=${g_mem// /}; g_memt=${g_memt// /}
  fi

  desenhar
  if [ -n "$UMA_VEZ" ]; then printf '%s' "$F"; exit 0; fi
  printf '\e[H%s\e[J' "$F"                               # cursor no topo, desenha o quadro e limpa o que sobrou
done
