# Clode_1 — Claude Code + 5 плагинов

| # | Что | Тип | Как подключено |
|---|-----|-----|----------------|
| 1 | **OmniRoute** — локальный AI-шлюз (fallback между провайдерами, сжатие) | npm-программа, не плагин | `npm i -g omniroute` → `omniroute run claude` |
| 2 | **Claude-Mem** — память между сессиями | плагин `claude-mem@thedotmack` | `.claude/settings.json` |
| 3 | **Headroom** — сжатие контекста/выводов инструментов | плагин `headroom@headroom-marketplace` + CLI `headroom-ai` | `.claude/settings.json` + `scripts/install-plugins.sh` |
| 4 | **Setup** — официальный Anthropic `claude-code-setup` (советует хуки, скиллы, MCP) | плагин | `.claude/settings.json` |
| 5 | **Task Observer** — мета-скилл, учится на ваших правках | плагин `task-observer@one-skill-to-rule-them-all` | `.claude/settings.json` + `CLAUDE.md` |

## Установка (на своём компьютере)

```bash
git clone <этот репозиторий> && cd Clode_1
./scripts/install-plugins.sh   # Headroom CLI + OmniRoute
claude                         # примите доверие к папке — плагины поставятся из .claude/settings.json
```

Вручную внутри Claude Code (если нужно глобально, для всех проектов):

```
/plugin marketplace add anthropics/claude-plugins-official
/plugin marketplace add thedotmack/claude-mem
/plugin marketplace add chopratejas/headroom
/plugin marketplace add rebelytics/one-skill-to-rule-them-all
/plugin install claude-code-setup@claude-plugins-official
/plugin install claude-mem@thedotmack
/plugin install headroom@headroom-marketplace
/plugin install task-observer@one-skill-to-rule-them-all
```

После установки перезапустите Claude Code.

## Важно

- **OmniRoute** подменяет `ANTHROPIC_BASE_URL` — запросы идут через сторонний шлюз и
  других провайдеров. «Бесплатные токены» — это free-тиры чужих API со своими лимитами.
  Не используйте с конфиденциальным кодом, если не доверяете провайдерам.
- **Claude-Mem** хранит наблюдения локально (SQLite/Chroma) в `~/.claude-mem`. Лицензия AGPL-3.0.
- **Headroom**-хуки без CLI просто ничего не делают (пишут предупреждение) — поставьте `headroom-ai`.
