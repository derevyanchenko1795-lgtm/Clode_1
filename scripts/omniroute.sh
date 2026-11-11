#!/usr/bin/env bash
# Запуск Claude Code через OmniRoute одной командой.
# Запускать на СВОЁМ компьютере (macOS / Linux / WSL), не в облачной сессии.
#
#   ./scripts/omniroute.sh                 # поднять сервер (если не запущен) и открыть Claude Code через шлюз
#   ./scripts/omniroute.sh --model auto    # то же, аргументы после команды уходят в `omniroute run claude`
#   ./scripts/omniroute.sh start           # только запустить сервер в фоне
#   ./scripts/omniroute.sh status          # запущен ли сервер
#   ./scripts/omniroute.sh stop            # остановить сервер
#   ./scripts/omniroute.sh dashboard       # открыть дашборд в браузере
#
# Порт по умолчанию 20128, свой — через переменную: OMNIROUTE_PORT=20200 ./scripts/omniroute.sh
# API-ключ (дашборд → Endpoints) — через переменную OMNIROUTE_API_KEY.
set -euo pipefail

PORT="${OMNIROUTE_PORT:-20128}"
URL="http://localhost:${PORT}"
WAIT_SECONDS="${OMNIROUTE_WAIT:-60}"

die()  { echo "✖ $*" >&2; exit 1; }
info() { echo "==> $*"; }
warn() { echo "⚠ $*" >&2; }

need_omniroute() {
  command -v omniroute >/dev/null 2>&1 || die "OmniRoute не установлен. Запустите ./scripts/install-plugins.sh или: npm install -g omniroute"
  command -v curl >/dev/null 2>&1 || die "Нужен curl (Ubuntu: sudo apt install -y curl)"
}

# Сервер считается запущенным, если на порту отвечает HTTP (любой код ответа).
is_up() {
  local code
  code="$(curl -s -o /dev/null -m 2 -w '%{http_code}' "${URL}/api/monitoring/health" 2>/dev/null || true)"
  [[ -n "$code" && "$code" != "000" ]]
}

start_server() {
  if is_up; then
    info "OmniRoute уже работает: ${URL}"
    return 0
  fi
  info "Запускаю OmniRoute в фоне на порту ${PORT}"
  omniroute serve --daemon --no-open --port "$PORT"
  info "Жду, пока сервер ответит (до ${WAIT_SECONDS} с)"
  local i
  for ((i = 0; i < WAIT_SECONDS; i++)); do
    if is_up; then
      info "Готово: дашборд ${URL}"
      return 0
    fi
    sleep 1
  done
  die "Сервер не ответил за ${WAIT_SECONDS} с. Проверьте: omniroute doctor; порт занят? — ./scripts/omniroute.sh stop"
}

open_dashboard() {
  if command -v open >/dev/null 2>&1; then open "$URL"
  elif command -v xdg-open >/dev/null 2>&1; then xdg-open "$URL" >/dev/null 2>&1 &
  elif command -v wslview >/dev/null 2>&1; then wslview "$URL"
  else echo "Откройте в браузере: $URL"
  fi
}

check_conflicts() {
  # Headroom-прокси и OmniRoute оба подменяют адрес API — вместе они мешают друг другу.
  local base="${ANTHROPIC_BASE_URL:-}"
  if [[ -n "$base" && "$base" != *"api.anthropic.com"* && "$base" != *":${PORT}"* ]]; then
    warn "ANTHROPIC_BASE_URL=${base} — похоже, включён другой прокси (Headroom?)."
    warn "OmniRoute его переопределит на эту сессию. Не запускайте их одновременно."
  fi
  if [[ -z "${OMNIROUTE_API_KEY:-}" && -z "${ANTHROPIC_AUTH_TOKEN:-}" ]]; then
    warn "OMNIROUTE_API_KEY не задан. Если шлюз требует ключ, Claude Code получит 401."
    warn "Ключ: ${URL} → Endpoints. Затем: export OMNIROUTE_API_KEY=ваш_ключ"
  fi
}

cmd="${1:-claude}"
case "$cmd" in
  start)
    need_omniroute; start_server ;;
  stop)
    need_omniroute; omniroute stop --port "$PORT" ;;
  status)
    need_omniroute
    if is_up; then echo "✔ OmniRoute работает: ${URL}"; else echo "✖ OmniRoute не запущен (порт ${PORT})"; exit 1; fi ;;
  dashboard)
    need_omniroute; start_server; open_dashboard ;;
  -h|--help|help)
    sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//' ;;
  *)
    # По умолчанию: всё, что передано, уходит в Claude Code через шлюз.
    [[ "$cmd" == "claude" ]] && shift || true
    need_omniroute
    check_conflicts
    start_server
    info "Открываю Claude Code через OmniRoute"
    exec omniroute run claude --port "$PORT" "$@" ;;
esac
