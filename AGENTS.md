# Agent Instructions for rust-gigachat-app

## Project Overview

rust-gigachat-app is a teaching demo: a Rust + Rocket web API with optional
GigaChat integration and a mock mode for offline use. It is designed as
course material for first-year students (semester 2) in an IT education track.

## Quick Start (Dev)

```bash
# Run server (mock mode if no token is set)
cargo run

# Run tests
cargo test

# Example client
cargo run --example simple_client

# API smoke tests (bash)
./examples/test_api.sh
```

Windows demo script:
```powershell
powershell -ExecutionPolicy Bypass -File demo_mock.ps1
```

## Configuration Notes

- Main config file: `config.toml`
- Real API: set `GIGACHAT_TOKEN` (env or .env)
- Override config path: `CONFIG_PATH=/path/to/config.toml`
- Override fields via env: `APP_*` (e.g., `APP_SERVER_PORT=9000`)
- Feature flags: default `gigachat`; disable with `cargo build --no-default-features`

## Architecture / Key Paths

- `src/main.rs` - bootstrap (config, logging, service, Rocket routes)
- `src/config/` - configuration loading + env overrides
- `src/handlers/` - HTTP handlers and error catchers
- `src/models/` - DTOs for JSON requests/responses
- `src/services/` - AiService trait, GigaChat and Mock implementations
- `tests/` - integration tests

## Beads + Git Workflow

Проект использует **beads** как встроенный issue‑трекер.

Рекомендуемый режим (по документации beads):
- авто‑синхронизация + git‑хуки + merge‑driver для `.beads/issues.jsonl`.

Если это свежий клон:
```bash
bd init
bd hooks install
git config merge.beads.driver true
```

Используйте `bd sync` только как fallback, если auto‑sync/хуки не сработали.

Полезные команды:
- `bd ready` — найти доступную работу
- `bd create "Заголовок" --type task --priority 2 --description "что и зачем"` — создать задачу
- `bd update <id> --status in_progress` — взять задачу
- `bd close <id>` — закрыть задачу

### Обязательный порядок работы (симуляция живого разработчика)

**Строго обязательно (без исключений):**

1. **До начала любой работы:** выполнить `bd create` с описанием (`--description`).
2. **Перед изменениями:** перевести задачу в `in_progress`.
3. **Только после этого:** выполнять правки, тесты и исправления.
4. **Подготовить индекс:** добавить изменения в индекс (`git add -A`).
5. **Коммит проекта:** первая строка коммита должна начинаться с ID issue
   и содержать тип и приоритет в современном формате:
   `<issue-id> <type>(P#): <issue title>`.
   Тело коммита должно совпадать с `--description`. После описания
   добавьте список изменённых файлов (см. шаблон ниже).
6. **Закрытие задачи:** `bd close <id>` выполняется после коммита проекта.
7. **Синхронизация beads:** `bd sync` выполняется после `bd close`.

**Важно:** `bd sync` коммитит **только** `.beads/issues.jsonl`
(данные beads). Изменения проекта он **не коммитит**.
Коммит проекта выполняется вручную. `bd sync` не выполняет
`git add`, поэтому новые файлы нужно добавить в индекс заранее.
Повторный push допускается только если `bd sync` не выполнялся
или завершился с ошибкой.

**Шаблон коммита (issue → commit):**
```bash
ID="<issue id>"
TYPE="<issue type>"
PRIO="<issue priority>"
TITLE="<issue title>"
DESC="<issue description>"
HEADER="$ID $TYPE($PRIO): $TITLE"
FILES=$(git diff --cached --name-only | sed 's/^/- /')
printf "%s\n\n%s\n\nИзменения:\n%s\n" "$HEADER" "$DESC" "$FILES" | git commit -F -
```

Вариант со статусами файлов (A/M/D/R/C + пояснение):
```bash
ID="<issue id>"
TYPE="<issue type>"
PRIO="<issue priority>"
TITLE="<issue title>"
DESC="<issue description>"
HEADER="$ID $TYPE($PRIO): $TITLE"
FILES=$(git diff --cached --name-status | awk '
  {
    code=$1; from=$2; to=$3;
    status="изменён";
    if (code ~ /^A/) status="создан";
    else if (code ~ /^D/) status="удалён";
    else if (code ~ /^R/) { status="переименован"; printf "- %s %s -> %s (%s)\n", code, from, to, status; next }
    else if (code ~ /^C/) { status="скопирован"; printf "- %s %s -> %s (%s)\n", code, from, to, status; next }
    printf "- %s %s (%s)\n", code, from, status;
  }')
printf "%s\n\n%s\n\nИзменения:\n%s\n" "$HEADER" "$DESC" "$FILES" | git commit -F -
```

Если `.beads/issues.jsonl` попал в индекс, его можно исключить из проектного
коммита и оставить для `bd sync`:
```bash
git restore --staged .beads/issues.jsonl
```

**Примечание про хуки:** если `bd sync` вызывается внутри git‑хуков,
он может запускать повторную синхронизацию. Это ожидаемое поведение,
и ручной `git push` после него не требуется.

**Формальное описание процесса (CNCF):**
- `agents-issue-workflow.cncf.yaml` — Serverless Workflow (CNCF) для агентских правил.

**Запрещено:**
- начинать работу без `bd create`;
- закрывать задачу до `bd sync`;
- выполнять работу, если задача не в `in_progress`.
