# 🚀 Быстрый старт для студентов

**Добро пожаловать!** Это учебный проект веб-приложения на Rust с интеграцией GigaChat API.

## 📋 Шаг 0: Что вам понадобится

- ✅ **Rust** версии 1.93.0 или новее ([установка](https://www.rust-lang.org/tools/install))
- ✅ **Git** для клонирования проекта
- ⚠️ **GigaChat токен** (опционально, можно работать в mock-режиме)

## 🎯 Шаг 1: Получите проект

```bash
# Клонируйте репозиторий (замените URL)
git clone <URL_репозитория>
# Перейдите в каталог репозитория (имя может отличаться)
cd edu-rust-gigachat-app-backend

# Проверьте версию Rust
rustc --version
# Должно быть: rustc 1.93.0 или новее
```

**Если Rust старый:**
```bash
rustup update
```

## 🔧 Шаг 2: Первый запуск (Mock Mode)

Приложение работает **без GigaChat** в режиме заглушки:

```bash
# Компиляция и запуск
cargo run
```

Увидите:
```
✅ Конфигурация успешно загружена
💡 Переключаемся на mock mode
🤖 AI сервис: Mock AI Service
🌐 Сервер будет запущен на 127.0.0.1:8000
```

**Отлично! Сервер запущен.** Переходите к шагу 3.

## 🧪 Шаг 3: Протестируйте API

**Откройте НОВЫЙ терминал** (оставьте сервер работать) и выполните:

### Вариант A: PowerShell (Windows)

```powershell
# Запустите демо-скрипт
powershell -ExecutionPolicy Bypass -File demo_mock.ps1
```

### Вариант B: curl (Linux/macOS/Windows)

```bash
# Проверка здоровья
curl http://localhost:8000/health

# Задать вопрос
curl -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"question": "What is Rust?"}'
```

### Вариант C: HTTPie (рекомендуется!)

```bash
# Установка (один раз)
# Windows: choco install httpie
# macOS:   brew install httpie
# Linux:   sudo apt install httpie

# Проверка здоровья
http GET localhost:8000/health

# Задать вопрос (короткий синтаксис!)
http POST localhost:8000/ask question="What is Rust?"
```

## 📚 Шаг 4: Изучите код

Откройте проект в вашем редакторе (VS Code, RustRover, etc.) и изучите:

1. **`src/main.rs`** - точка входа, запуск Rocket
2. **`src/handlers/mod.rs`** - обработчики HTTP запросов
3. **`src/services/mod.rs`** - логика AI-сервиса (Mock и GigaChat)
4. **`src/models/mod.rs`** - структуры данных (JSON)
5. **`src/config/mod.rs`** - загрузка конфигурации

**💡 Совет:** В коде МНОГО обучающих комментариев на русском. Читайте их!

## 🧪 Шаг 5: Запустите тесты

```bash
# Остановите сервер (Ctrl+C)

# Запустите все тесты
cargo test

# Все тесты должны пройти ✅
```

## 🎓 Шаг 6: Изучите документацию

Откройте эти файлы в порядке приоритета:

1. 📖 **[README.md](README.md)** - общее описание проекта
2. 🎓 **[docs/student_guide.md](docs/student_guide.md)** - руководство для студентов
3. 🌐 **[docs/api_examples.md](docs/api_examples.md)** - примеры запросов
4. 🔧 **[docs/common_issues.md](docs/common_issues.md)** - решение проблем
5. 📚 **[lab/library_reference.md](lab/library_reference.md)** - справочник по библиотекам
6. 🏗️ **[docs/architecture.md](docs/architecture.md)** - архитектура проекта

## 🚀 Шаг 7 (опционально): Подключите GigaChat

Если хотите использовать **реальный** GigaChat:

```bash
# 1. Создайте .env файл
cp .env.example .env

# 2. Откройте .env и вставьте свой токен
# GIGACHAT_TOKEN=ваш_токен_здесь

# 3. Перезапустите сервер
cargo run
```

Увидите:
```
🤖 AI сервис: GigaChat Service
```

**Если API недоступен (timeout/сетевая ошибка):**  
это может быть связано с ограничениями сети. В таком случае продолжайте работу в mock‑режиме и смотрите раздел [docs/common_issues.md](docs/common_issues.md).

## 🆘 Проблемы?

### Ошибка: "feature `edition2024` is required"
```bash
rustup update
```

### Ошибка: "Address already in use"
Остановите предыдущий сервер:
```bash
# Windows
taskkill /F /IM rust-gigachat-demo.exe

# Linux/macOS
pkill rust-gigachat-demo
```
Имя процесса соответствует имени бинарника в `Cargo.toml`.
Если у вас другое имя, замените его в командах выше.

### Другие проблемы
Смотрите: [docs/common_issues.md](docs/common_issues.md)

## 📖 Дальше что?

1. **Изучите код** - читайте комментарии в `src/`
2. **Выполните лабораторную** - смотрите `lab/lab_work.md`
3. **Экспериментируйте** - измените mock-ответы, добавьте эндпоинты
4. **Задавайте вопросы** - преподавателю или в чате группы

---

**Удачи в обучении! 🎉**
