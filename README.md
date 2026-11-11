# Clode_1 — Claude Code + 5 плагинов

| # | Что | Тип | Как подключено |
|---|-----|-----|----------------|
| 1 | **OmniRoute** — локальный AI-шлюз (fallback между провайдерами, сжатие) | npm-программа, не плагин | `npm i -g omniroute` → `omniroute run claude` |
| 2 | **Claude-Mem** — память между сессиями | плагин `claude-mem@thedotmack` | `.claude/settings.json` |
| 3 | **Headroom** — сжатие контекста/выводов инструментов | плагин `headroom@headroom-marketplace` + CLI `headroom-ai` | `.claude/settings.json` + `scripts/install-plugins.sh` |
| 4 | **Setup** — официальный Anthropic `claude-code-setup` (советует хуки, скиллы, MCP) | плагин | `.claude/settings.json` |
| 5 | **Task Observer** — мета-скилл, учится на ваших правках | плагин `task-observer@one-skill-to-rule-them-all` | `.claude/settings.json` + `CLAUDE.md` |

## Установка

📖 **Полная пошаговая инструкция: [INSTALL.md](INSTALL.md)**

Коротко:

```bash
git clone https://github.com/derevyanchenko1795-lgtm/Clode_1.git ~/Projects/Clode_1
cd ~/Projects/Clode_1
./scripts/install-plugins.sh          # программы Headroom и OmniRoute
./scripts/install-claude-plugins.sh   # 4 плагина Claude Code для всех проектов
claude
```

## Важно

- **OmniRoute** подменяет `ANTHROPIC_BASE_URL` — запросы идут через сторонний шлюз и
  других провайдеров. «Бесплатные токены» — это free-тиры чужих API со своими лимитами.
  Не используйте с конфиденциальным кодом, если не доверяете провайдерам.
- **Claude-Mem** хранит наблюдения локально (SQLite/Chroma) в `~/.claude-mem`. Лицензия AGPL-3.0.
- **Headroom**-хуки без CLI просто ничего не делают (пишут предупреждение) — поставьте `headroom-ai`.
