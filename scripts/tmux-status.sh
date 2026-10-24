#!/bin/bash
# Segmentos da barra de status do tmux (Linux). Uso: tmux-status.sh cpu|ram|disk|load
# Imprime o valor ja com a cor (codigos #[fg=...] do tmux): verde < 60, amarelo < 85, vermelho >= 85.
# Depende so de /proc, free e df.

cor() {   # PERCENTUAL -> codigo de cor do tmux
  if [ "$1" -ge 85 ]; then printf '#[fg=#ef5350]'; elif [ "$1" -ge 60 ]; then printf '#[fg=#ecc48d]'; else printf '#[fg=#22da6e]'; fi
}

case "$1" in
  cpu)   # percentual desde a ultima medicao (estado em /tmp: instante, ticks, ociosos, ultimo valor)
    estado="/tmp/.tmux-cpu-$(id -u)"
    agora=$(date +%s)
    read -r t i < <(awk '/^cpu / { t = 0; for (k = 2; k <= 9; k++) t += $k; print t, $5 + $6 }' /proc/stat)
    pct=""
    if [ -f "$estado" ]; then
      read -r ts t0 i0 ultimo < "$estado"
      if [ $((agora - ts)) -ge 2 ]; then          # medicoes muito proximas dao ruido: reaproveita o ultimo valor
        dt=$((t - t0)); di=$((i - i0))
        if [ "$dt" -gt 0 ]; then pct=$(( (100 * (dt - di) + dt / 2) / dt )); fi
        echo "$agora $t $i $pct" > "$estado"
      else
        pct=$ultimo
      fi
    else
      echo "$agora $t $i" > "$estado"
    fi
    if [ -n "$pct" ]; then printf '%s%s%%' "$(cor "$pct")" "$pct"; else printf '...'; fi
    ;;
  ram)
    pct=$(free | awk '/^Mem/ { printf "%d", $3 * 100 / $2 }')
    printf '%s%s%%' "$(cor "$pct")" "$pct"
    ;;
  disk)
    pct=$(df -P / | awk 'NR == 2 { gsub(/%/, "", $5); print $5 }')
    printf '%s%s%%' "$(cor "$pct")" "$pct"
    ;;
  load)
    cut -d' ' -f1 /proc/loadavg
    ;;
  *)
    echo "uso: $0 cpu|ram|disk|load" >&2; exit 1 ;;
esac
