# Clode_1 — Claude Code + 5 плагинов

| # | Что | Тип | Как подключено |
|---|-----|-----|----------------|
| 1 | **OmniRoute** — локальный AI-шлюз (fallback между провайдерами, сжатие) | npm-программа, не плагин | `npm i -g omniroute` → `./scripts/omniroute.sh` |
| 2 | **Claude-Mem** — память между сессиями | плагин `claude-mem@thedotmack` | `.claude/settings.json` |
| 3 | **Headroom** — сжатие контекста/выводов инструментов | плагин `headroom@clode-1` + CLI `headroom-ai` | `.claude/settings.json` + `scripts/install-plugins.sh` |
| 4 | **Setup** — официальный Anthropic `claude-code-setup` (советует хуки, скиллы, MCP) | плагин | `.claude/settings.json` |
| 5 | **Task Observer** — мета-скилл, учится на ваших правках | плагин `task-observer@clode-1` | `.claude/settings.json` + `CLAUDE.md` |

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

## Что лежит в репозитории

- `.claude-plugin/marketplace.json` + `plugins/` — ваш маркетплейс `clode-1` с копиями `headroom` и `task-observer`
- `.claude/settings.json` — какие плагины включать в этом проекте
- `scripts/install-plugins.sh` — программы Headroom и OmniRoute
- `scripts/install-claude-plugins.sh` — 4 плагина Claude Code одной командой
- `scripts/omniroute.sh` — запуск Claude Code через OmniRoute одной командой (+ `start`/`status`/`stop`/`dashboard`)
- `scripts/sync-plugins.sh` — обновить копии плагинов из оригиналов
- `INSTALL.md` — полная инструкция

## Важно

- **OmniRoute** подменяет `ANTHROPIC_BASE_URL` — запросы идут через сторонний шлюз и
  других провайдеров. «Бесплатные токены» — это free-тиры чужих API со своими лимитами.
  Не используйте с конфиденциальным кодом, если не доверяете провайдерам.
- **Claude-Mem** хранит наблюдения локально (SQLite/Chroma) в `~/.claude-mem`. Лицензия AGPL-3.0.
- **Headroom**-хуки без CLI просто ничего не делают (пишут предупреждение) — поставьте `headroom-ai`.
