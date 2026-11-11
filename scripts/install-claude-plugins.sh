#!/usr/bin/env bash
# Ставит 4 плагина Claude Code одной командой (без захода в сам Claude Code).
# По умолчанию — для всех проектов (scope=user). Только для этого проекта:
#   ./scripts/install-claude-plugins.sh project
set -euo pipefail
SCOPE="${1:-user}"

command -v claude >/dev/null || { echo "Claude Code не найден. Установите: curl -fsSL https://claude.ai/install.sh | bash" >&2; exit 1; }

for m in anthropics/claude-plugins-official thedotmack/claude-mem \
         chopratejas/headroom rebelytics/one-skill-to-rule-them-all; do
  echo "==> маркетплейс $m"
  claude plugin marketplace add "$m" || true   # уже добавлен — не ошибка
done

for p in claude-code-setup@claude-plugins-official claude-mem@thedotmack \
         headroom@headroom-marketplace task-observer@one-skill-to-rule-them-all; do
  echo "==> плагин $p ($SCOPE)"
  claude plugin install --scope "$SCOPE" "$p"
done

echo
claude plugin list
echo
echo "Готово. Перезапустите Claude Code, чтобы плагины загрузились."
