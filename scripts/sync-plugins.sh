#!/usr/bin/env bash
# Обновляет копии плагинов в plugins/ из оригинальных репозиториев авторов
# и пересобирает .claude-plugin/marketplace.json.
# claude-mem и claude-code-setup здесь не копируются: их имена зарезервированы
# (сторонний маркетплейс не может их публиковать), а claude-mem к тому же
# работает только из своего маркетплейса thedotmack. Они ставятся из оригиналов.
# Запуск:  ./scripts/sync-plugins.sh   затем  git add -A && git commit && git push
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

# имя | репозиторий | папка плагина внутри репозитория
PLUGINS=(
  "headroom|chopratejas/headroom|plugins/headroom-agent-hooks"
  "task-observer|rebelytics/one-skill-to-rule-them-all|."
)

for entry in "${PLUGINS[@]}"; do
  IFS='|' read -r name repo sub <<<"$entry"
  echo "==> $name  ←  github.com/$repo/$sub"
  src="$TMP/$name"
  GIT_LFS_SKIP_SMUDGE=1 git clone -q --depth 1 "https://github.com/$repo" "$src"
  commit="$(git -C "$src" rev-parse HEAD)"
  dest="$ROOT/plugins/$name"
  rm -rf "$dest"; mkdir -p "$dest"
  # копируем плагин без служебных папок git/CI, вложенных плагинов и source map
  tar -C "$src/$sub" --exclude=.git --exclude=.github --exclude=./plugins \
      --exclude='*.map' -cf - . | tar -C "$dest" -xf -
  [ -f "$dest/LICENSE" ] || cp "$src/LICENSE" "$dest/LICENSE"
  cat > "$dest/UPSTREAM.md" <<MD
# Копия плагина $name

Оригинал: https://github.com/$repo/tree/$commit/$sub
Коммит:   $commit
Лицензия: см. LICENSE в этой папке (сохранена из оригинала).

Не редактируйте файлы здесь вручную — они перезаписываются командой
\`./scripts/sync-plugins.sh\`.
MD
done

# Архив скилла task-observer для загрузки в приложение Claude (Settings → Customize)
echo "==> dist/task-observer.zip"
mkdir -p "$ROOT/dist" "$TMP/zip/task-observer"
cp -r "$ROOT/plugins/task-observer/"{SKILL.md,references,scripts,LICENSE} "$TMP/zip/task-observer/"
rm -f "$ROOT/dist/task-observer.zip"
(cd "$TMP/zip" && zip -qr "$ROOT/dist/task-observer.zip" task-observer)

python3 - "$ROOT" <<'PY'
import json, os, sys
root = sys.argv[1]
meta = {
  "headroom":          ("Хуки Headroom: сжимают вывод команд и экономят токены. Нужна программа headroom-ai.", "Headroom Contributors"),
  "task-observer":     ("Замечает повторяющиеся правки и предлагает улучшения скиллов (только после вашего одобрения).", "Eoghan Henn (rebelytics)"),
}
plugins = []
for name, (desc, author) in meta.items():
    pj = os.path.join(root, "plugins", name, ".claude-plugin", "plugin.json")
    version = json.load(open(pj)).get("version") if os.path.exists(pj) else None
    p = {"name": name, "source": f"./plugins/{name}", "description": desc, "author": {"name": author}}
    if version: p["version"] = version
    plugins.append(p)
m = {
  "$schema": "https://anthropic.com/claude-code/marketplace.schema.json",
  "name": "clode-1",
  "owner": {"name": "derevyanchenko1795-lgtm"},
  "metadata": {"description": "Мои плагины для Claude Code: копии headroom и task-observer."},
  "plugins": plugins,
}
os.makedirs(os.path.join(root, ".claude-plugin"), exist_ok=True)
with open(os.path.join(root, ".claude-plugin", "marketplace.json"), "w") as f:
    json.dump(m, f, ensure_ascii=False, indent=2); f.write("\n")
print("==> .claude-plugin/marketplace.json обновлён")
PY
