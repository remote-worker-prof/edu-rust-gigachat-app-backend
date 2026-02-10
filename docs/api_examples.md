# Примеры использования API

Этот документ содержит примеры запросов к API с использованием различных инструментов.

## Установка инструментов

### HTTPie (рекомендуется для обучения)

HTTPie — современная альтернатива curl с удобным синтаксисом и красивым выводом.

**Установка:**

| Платформа | Команда |
|-----------|---------|
| **Windows** (Chocolatey) | `choco install httpie` |
| **macOS** (Homebrew) | `brew install httpie` |
| **Linux** (Debian/Ubuntu) | `sudo apt install httpie` |
| **Linux** (Fedora/RHEL) | `sudo dnf install httpie` |
| **Arch Linux** | `sudo pacman -S httpie` |
| **Универсально** (pip) | `pip install httpie` |

**Преимущества:**
- ✅ Короткий и понятный синтаксис
- ✅ Автоматическая подсветка синтаксиса
- ✅ Красивое форматирование JSON
- ✅ Автоматическое определение Content-Type

### curl

curl предустановлен в большинстве систем.

**Преимущества:**
- ✅ Универсально доступен
- ✅ Мощный и гибкий
- ✅ Стандарт индустрии

## Сравнение синтаксиса

### GET запросы

#### curl
```bash
curl http://localhost:8000/health
curl -v http://localhost:8000/health  # Подробный вывод
```

#### HTTPie
```bash
http GET localhost:8000/health
http -v GET localhost:8000/health     # Подробный вывод
```

#### PowerShell
```powershell
Invoke-RestMethod -Uri "http://localhost:8000/health"
```

---

### POST запросы с JSON

#### curl
```bash
# Базовый запрос
curl -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"question": "What is Rust?"}'

# С подробным выводом
curl -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"question": "What is Rust?"}'

# Из файла
curl -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d @question.json
```

#### HTTPie
```bash
# Базовый запрос (короткий синтаксис!)
http POST localhost:8000/ask question="What is Rust?"

# С явным JSON
echo '{"question": "What is Rust?"}' | http POST localhost:8000/ask

# Из файла
http POST localhost:8000/ask < question.json

# С подробным выводом
http -v POST localhost:8000/ask question="What is Rust?"
```

#### PowerShell
```powershell
# Базовый запрос
$body = '{"question": "What is Rust?"}'
Invoke-RestMethod -Uri "http://localhost:8000/ask" `
  -Method POST `
  -Body $body `
  -ContentType "application/json"

# Из файла
$body = Get-Content question.json -Raw
Invoke-RestMethod -Uri "http://localhost:8000/ask" `
  -Method POST `
  -Body $body `
  -ContentType "application/json"
```

---

## Примеры запросов для демо-приложения

### 1. Проверка здоровья сервера

**curl:**
```bash
curl http://localhost:8000/health
```

**HTTPie:**
```bash
http GET localhost:8000/health
```

**Ожидаемый ответ:**
```json
{
  "status": "ok",
  "version": "0.1.0",
  "gigachat_enabled": true
}
```

---

### 2. Главная страница

**curl:**
```bash
curl http://localhost:8000/
```

**HTTPie:**
```bash
http GET localhost:8000/
```

**Ответ:** Текстовое описание API

---

### 3. Вопрос о Rust

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

**Ожидаемый ответ:**
```json
{
  "answer": "Rust is a systems programming language focused on safety, speed, and concurrency...",
  "source": "mock ai service"
}
```

---

### 4. Вопрос о Rocket

**curl:**
```bash
curl -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"question": "Tell me about Rocket framework"}'
```

**HTTPie:**
```bash
http POST localhost:8000/ask question="Tell me about Rocket framework"
```

---

### 5. Вопрос о тестировании

**curl:**
```bash
curl -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"question": "How to test code?"}'
```

**HTTPie:**
```bash
http POST localhost:8000/ask question="How to test code?"
```

---

### 6. Вопрос об обработке ошибок

**curl:**
```bash
curl -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"question": "How to handle errors?"}'
```

**HTTPie:**
```bash
http POST localhost:8000/ask question="How to handle errors?"
```

---

### 7. Тест валидации (пустой вопрос)

**curl:**
```bash
curl -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"question": ""}'
```

**HTTPie:**
```bash
http POST localhost:8000/ask question=""
```

**Ожидаемый ответ:**
```json
{
  "error": "Question cannot be empty",
  "code": "EMPTY_QUESTION"
}
```

---

### 8. Тест несуществующего эндпоинта (404)

**curl:**
```bash
curl http://localhost:8000/nonexistent
```

**HTTPie:**
```bash
http GET localhost:8000/nonexistent
```

**Ожидаемый ответ:** 404 Not Found

---

## Дополнительные возможности HTTPie

### Форматирование вывода

```bash
# Только тело ответа
http --body POST localhost:8000/ask question="Hello"

# Только заголовки
http --headers POST localhost:8000/ask question="Hello"

# Красивый вывод (по умолчанию)
http --pretty=all POST localhost:8000/ask question="Hello"

# Без форматирования
http --pretty=none POST localhost:8000/ask question="Hello"
```

### Сохранение ответов

```bash
# Сохранить ответ в файл
http POST localhost:8000/ask question="What is Rust?" > response.json

# Загрузить из файла
http POST localhost:8000/ask < request.json
```

### Сессии (для сохранения cookies и headers)

```bash
# Создать сессию
http --session=./session.json POST localhost:8000/ask question="Hello"

# Использовать существующую сессию
http --session=./session.json POST localhost:8000/ask question="Another question"
```

---

## Полезные ссылки

- [HTTPie документация](https://httpie.io/docs/cli)
- [curl документация](https://curl.se/docs/manual.html)
- [PowerShell Invoke-RestMethod](https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod)
