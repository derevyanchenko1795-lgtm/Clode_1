# Установка 5 плагинов в Claude Code

Пошаговая инструкция для macOS, Linux и Windows (через WSL). Всё делается на вашем компьютере.

| # | Плагин | Что делает | Что это технически |
|---|--------|------------|--------------------|
| 1 | **OmniRoute** | Переключает Claude Code на другие модели, когда кончаются лимиты | Отдельная программа (npm) |
| 2 | **Claude-Mem** | Помнит, что вы делали в прошлых сессиях | Плагин `claude-mem@thedotmack` |
| 3 | **Headroom** | Сжимает вывод команд, экономит токены | Плагин `headroom@clode-1` + программа `headroom-ai` |
| 4 | **Setup** | Советует хуки, скиллы и MCP-серверы для проекта | Официальный плагин Anthropic `claude-code-setup@claude-plugins-official` |
| 5 | **Task Observer** | Замечает повторяющиеся правки и предлагает улучшить скиллы | Плагин `task-observer@clode-1` |

**Коротко, если всё уже установлено (Git, Node.js, uv, Claude Code):**

```bash
git clone https://github.com/derevyanchenko1795-lgtm/Clode_1.git ~/Projects/Clode_1
cd ~/Projects/Clode_1
./scripts/install-plugins.sh          # программы Headroom и OmniRoute
./scripts/install-claude-plugins.sh   # 4 плагина Claude Code для всех проектов
claude
```

---

## Шаг 1. Подготовка компьютера

### 1.1. Терминал

- **macOS:** <kbd>⌘</kbd> + <kbd>Пробел</kbd> → «Терминал».
- **Linux:** <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>T</kbd>.
- **Windows:** нужен WSL. Откройте PowerShell от имени администратора, выполните `wsl --install`, перезагрузитесь, затем открывайте **Ubuntu** из меню Пуск. Все команды ниже вводятся в Ubuntu.

### 1.2. Нужные программы

Проверьте каждую командой из второго столбца. Если команда пишет `command not found`, установите программу командой из третьего.

| Программа | Проверка | Установка |
|-----------|----------|-----------|
| Git | `git --version` | macOS: `xcode-select --install` · Ubuntu: `sudo apt install -y git` |
| Node.js **22.22+ или 24+** | `node -v` | `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh \| bash`, затем новый терминал и `nvm install 24` |
| uv (для Headroom) | `uv --version` | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Claude Code | `claude --version` | `curl -fsSL https://claude.ai/install.sh \| bash` |

После установки откройте **новый** терминал, чтобы команды подхватились.

Если Claude Code только что установлен, запустите `claude` один раз и войдите в аккаунт Claude.

---

## Шаг 2. Скачать репозиторий

```bash
mkdir -p ~/Projects && cd ~/Projects
git clone https://github.com/derevyanchenko1795-lgtm/Clode_1.git
cd Clode_1
```

Если git просит логин и пароль, значит репозиторий приватный. Войдите через GitHub CLI и повторите `git clone`:

```bash
# macOS: brew install gh   ·   Ubuntu: sudo apt install -y gh
gh auth login    # GitHub.com → HTTPS → Login with a web browser
```

Проверка: `ls -a` должен показать `.claude  scripts  CLAUDE.md  README.md`.

---

## Шаг 3. Установить программы Headroom и OmniRoute

```bash
./scripts/install-plugins.sh
```

Займёт 2–4 минуты. Жёлтые строки `npm warn … peer` и `deprecated` — это нормально. В конце появится **«Готово. Дальше:»**.

Проверка:

```bash
headroom --version     # headroom, version 0.44.x
omniroute --version    # 3.8.x
```

---

## Шаг 4. Установить плагины в Claude Code

Выберите **один** из трёх способов.

### Способ А — одной командой (рекомендую)

Для **всех** ваших проектов:

```bash
./scripts/install-claude-plugins.sh
```

Только для этого проекта:

```bash
./scripts/install-claude-plugins.sh project
```

В конце скрипт покажет список, где у каждого плагина `Status: ✔ enabled`.

### Способ Б — автоматически при открытии проекта

В репозитории есть `.claude/settings.json` со списком плагинов. Просто запустите Claude Code в папке проекта:

```bash
cd ~/Projects/Clode_1
claude
```

1. На вопрос о доверии к папке ответьте **Yes, proceed**.
2. Claude Code предложит добавить маркетплейсы и установить плагины — соглашайтесь.

Так плагины включаются только в этом проекте.

### Способ В — вручную внутри Claude Code

Запустите `claude` и введите по одной строке:

```
/plugin marketplace add derevyanchenko1795-lgtm/Clode_1
/plugin marketplace add anthropics/claude-plugins-official
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-code-setup@claude-plugins-official
/plugin install claude-mem@thedotmack
/plugin install headroom@clode-1
/plugin install task-observer@clode-1
```

Можно и через меню: введите `/plugin`, откройте вкладку **Discover**, найдите плагин и нажмите <kbd>Enter</kbd>.

### После любого способа

**Перезапустите Claude Code**: `/exit`, затем снова `claude`. Без перезапуска Claude-Mem и Headroom не подключатся.

---

## Шаг 5. Проверить, что всё работает

| Что проверить | Как | Что должно быть |
|---------------|-----|-----------------|
| Плагины установлены | `claude plugin list` или `/plugin` внутри Claude Code | 4 плагина, все `enabled` |
| Claude-Mem | `npx claude-mem doctor` | Все проверки зелёные |
| Headroom | `headroom --version` | Номер версии |
| Setup | В Claude Code: «Порекомендуй автоматизации Claude Code для этого проекта» | Список рекомендаций |
| Task Observer | Поработайте сессию, поправьте Claude пару раз | В конце он предложит улучшения скиллов |

---

## Шаг 6. Как пользоваться каждый день

| Режим | Команда | Когда |
|-------|---------|-------|
| **Обычный** | `claude` | Всегда по умолчанию. Работают Claude-Mem, Headroom, Setup и Task Observer |
| **Через OmniRoute** | терминал 1: `omniroute` · терминал 2: `omniroute run claude` | Кончился лимит Claude или нужны другие модели |
| **Максимальное сжатие** | `headroom wrap claude`, затем `claude` | Очень длинные сессии. Выключить: `headroom unwrap claude` |

**Первый запуск OmniRoute:**

1. `omniroute` — оставьте это окно открытым.
2. Откройте http://localhost:20128 → **Providers** → подключите провайдера своим ключом или аккаунтом.
3. **Endpoints** → скопируйте API-ключ.
4. Проверьте: `curl http://localhost:20128/v1/models -H "Authorization: Bearer ВАШ_КЛЮЧ"`.
5. Во втором терминале: `cd ~/Projects/Clode_1 && omniroute run claude`.

> ⚠️ Не включайте `headroom wrap` и OmniRoute одновременно: оба перенаправляют запросы Claude Code через себя и мешают друг другу.

---

## Ваш маркетплейс плагинов (этот репозиторий)

Репозиторий `Clode_1` — это ещё и **ваш собственный маркетплейс** `clode-1`. В папке `plugins/` лежат копии двух плагинов, и ставятся они с вашего GitHub:

| Плагин | Откуда копия | Как поставить |
|--------|--------------|---------------|
| `headroom` | github.com/chopratejas/headroom | `/plugin install headroom@clode-1` |
| `task-observer` | github.com/rebelytics/one-skill-to-rule-them-all | `/plugin install task-observer@clode-1` |

Чтобы подключить маркетплейс на любом компьютере, введите в Claude Code:

```
/plugin marketplace add derevyanchenko1795-lgtm/Clode_1
```

**Почему здесь нет копий claude-mem и claude-code-setup.** Имена, начинающиеся с `claude-`, зарезервированы за Anthropic: сторонний маркетплейс не может публиковать плагины под ними. А claude-mem к тому же жёстко привязан к пути своего маркетплейса `thedotmack` и из чужого просто не запустится. Поэтому эти два плагина ставятся из оригиналов, а скрипт и `.claude/settings.json` уже настроены так.

**Как обновить копии** до свежих версий авторов:

```bash
cd ~/Projects/Clode_1
./scripts/sync-plugins.sh
git add -A && git commit -m "Обновил копии плагинов" && git push
```

В каждой папке плагина есть `UPSTREAM.md` с адресом оригинала и коммитом, с которого снята копия, и `LICENSE` автора.

---

## Обновление и удаление

**Обновить:**

```bash
cd ~/Projects/Clode_1 && git pull            # сам репозиторий
./scripts/sync-plugins.sh && git add -A && git commit -m "sync" && git push   # копии в plugins/
claude plugin marketplace update             # списки плагинов
claude plugin update claude-mem@thedotmack   # конкретный плагин (так же для остальных)
npm update -g omniroute
uv tool upgrade headroom-ai
```

**Удалить:**

```bash
claude plugin uninstall claude-code-setup@claude-plugins-official
claude plugin uninstall claude-mem@thedotmack
claude plugin uninstall headroom@clode-1
claude plugin uninstall task-observer@clode-1
npm rm -g omniroute
uv tool uninstall headroom-ai
```

Временно выключить плагин без удаления: `claude plugin disable <имя>`, включить обратно: `claude plugin enable <имя>`.

---

## Частые проблемы

| Что видите | Что делать |
|------------|------------|
| `permission denied: ./scripts/…` | `chmod +x scripts/*.sh` |
| `No such file or directory` | Вы не в той папке: `cd ~/Projects/Clode_1` |
| `claude: command not found` | Установите Claude Code (шаг 1.2) и откройте новый терминал |
| Плагины не появились после установки | Перезапустите Claude Code; затем `claude plugin marketplace update` |
| Claude-Mem не помнит прошлые сессии | `npx claude-mem doctor` и исправьте то, что он покажет |
| `headroom: CLI not found; … compression hooks are inactive` | `uv tool install "headroom-ai[all]"`, новый терминал |
| `EACCES` при `npm install -g` | Node установлен через систему — поставьте через `nvm` (шаг 1.2) |
| npm 11+ ругается на `allow-scripts` | `npm install -g --allow-scripts=omniroute,keytar,onnxruntime-node,@parcel/watcher,@swc/core,protobufjs,esbuild omniroute` |
| OmniRoute: порт 20128 занят | Закройте прошлый процесс `omniroute` |

---

## Что важно знать

- **OmniRoute** отправляет ваш код сторонним провайдерам. «Бесплатные токены» — это бесплатные тарифы чужих API с их лимитами, а не бесплатный Claude. Для закрытого кода лучше не использовать.
- **Claude-Mem** хранит всё локально в `~/.claude-mem`. Лицензия AGPL-3.0.
- **Headroom** сжимает всё локально, ничего никуда не отправляет. Без программы `headroom-ai` его плагин ничего не делает.

## Источники

- OmniRoute — https://github.com/diegosouzapw/OmniRoute
- Claude-Mem — https://github.com/thedotmack/claude-mem
- Headroom — https://github.com/chopratejas/headroom
- Claude Code Setup — https://github.com/anthropics/claude-plugins-official
- Task Observer — https://github.com/rebelytics/one-skill-to-rule-them-all
