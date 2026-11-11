#!/usr/bin/env bash
# Устанавливает внешние зависимости для 5 плагинов Claude Code.
# Запускать на СВОЁМ компьютере (macOS / Linux), не в облачной сессии.
set -euo pipefail

echo "==> 1/2 Headroom CLI (нужен хукам плагина headroom)"
if command -v uv >/dev/null 2>&1; then
  uv tool install --upgrade "headroom-ai[all]"
elif command -v pipx >/dev/null 2>&1; then
  pipx install --force "headroom-ai[all]"
else
  python3 -m pip install --user --upgrade "headroom-ai[all]"
fi

echo "==> 2/2 OmniRoute (локальный AI-шлюз, порт 20128)"
npm install -g omniroute

cat <<'MSG'

Готово. Дальше:
  1. Откройте этот репозиторий в Claude Code (`claude`) и согласитесь
     доверить папке — Claude Code предложит поставить плагины из .claude/settings.json.
     Либо вручную:  /plugin  →  Marketplaces / Install.
  2. Перезапустите Claude Code (claude-mem поднимает свой worker при старте).
  3. OmniRoute:  omniroute            # запуск сервера, дашборд http://localhost:20128
                 omniroute run claude # Claude Code через шлюз
  4. Headroom:   headroom wrap claude # опционально: прокси-сжатие контекста
MSG
