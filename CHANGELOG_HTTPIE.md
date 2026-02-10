# Changelog: Добавление примеров HTTPie

**Дата:** 2026-02-03

## Что изменилось

Во все документы проекта добавлены примеры использования **HTTPie** — современной альтернативы curl с более удобным синтаксисом и красивым выводом.

### Обновлённые файлы

1. **README.md**
   - Добавлены примеры HTTPie параллельно с curl
   - Инструкции по установке для Windows (Chocolatey), macOS (Homebrew), Linux
   - Обновлена структура проекта с новым файлом `docs/api_examples.md`

2. **lab_materials/lab_work.md**
   - Добавлены примеры тестирования через HTTPie
   - Инструкции по установке для всех платформ

3. **lab_materials/library_reference.md**
   - Новый раздел 5.6 с подробным сравнением curl и HTTPie
   - Таблица установки для разных платформ
   - Список преимуществ HTTPie

4. **docs/student_guide.md**
   - Добавлены примеры HTTPie в раздел тестирования
   - Быстрые инструкции по установке

5. **docs/common_issues.md**
   - Добавлены примеры проверки через HTTPie
   - Инструкции по установке

6. **docs/api_examples.md** *(новый файл)*
   - Полное сравнение синтаксиса curl vs HTTPie vs PowerShell
   - Примеры всех эндпоинтов API
   - Дополнительные возможности HTTPie (форматирование, сессии, сохранение)
   - Ссылки на официальную документацию

## Зачем HTTPie?

HTTPie предоставляет более удобный опыт для студентов:

### Преимущества
- ✅ **Короткий синтаксис**: `http POST localhost:8000/ask question="Hello"` вместо длинных curl команд
- ✅ **Автоматическая подсветка**: JSON ответы красиво форматируются и подсвечиваются
- ✅ **Интуитивно понятно**: `http GET` вместо `curl -X GET`
- ✅ **Автоопределение типов**: не нужно указывать `Content-Type: application/json`

### Сравнение

**curl:**
```bash
curl -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"question": "What is Rust?"}'
```

**HTTPie:**
```bash
http POST localhost:8000/ask question="What is Rust?"
```

## Установка

### Windows (Chocolatey)
```bash
choco install httpie
```

### macOS (Homebrew)
```bash
brew install httpie
```

### Linux
```bash
# Debian/Ubuntu
sudo apt install httpie

# Fedora/RHEL
sudo dnf install httpie

# Arch Linux
sudo pacman -S httpie
```

### Универсально (pip)
```bash
pip install httpie
```

## Для преподавателей

Рекомендуется показать студентам оба инструмента (curl и HTTPie):
- **curl** - стандарт индустрии, нужно знать
- **HTTPie** - более удобен для обучения и экспериментов

Студенты могут использовать тот инструмент, который им удобнее.

## Обратная совместимость

Все старые примеры с curl остались в документации. Новые примеры HTTPie добавлены параллельно, не заменяя curl.
