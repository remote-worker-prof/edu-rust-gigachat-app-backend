# Справочные материалы по зависимостям проекта

## 1. Введение

Настоящий документ содержит краткое описание основных библиотек (крейтов), используемых в демонстрационном проекте `rust-gigachat-demo`. Цель данного справочника — предоставить студентам отправную точку для изучения каждой из технологий.

## 2. Основные зависимости

### 2.1. Rocket

**Назначение:** веб-фреймворк для создания HTTP-сервера.

**Описание:** Rocket является основой нашего веб-приложения. Он отвечает за прием HTTP-запросов, их маршрутизацию к соответствующим функциям-обработчикам и отправку ответов. Его сильной стороной является простота и типобезопасность.

| Ресурс | Ссылка |
|---|---|
| Официальный сайт | [https://rocket.rs/](https://rocket.rs/) |
| Руководство (англ.) | [https://rocket.rs/guide/](https://rocket.rs/guide/) |
| Статья на Habr | [Использование Rust в Веб-Разработке](https://habr.com/ru/articles/721856/) |
| Статья (сравнение) | [Исследование инфраструктуры Rocket и Actix](https://rusty-code.ru/posts/rust-web-development-rocket-and-actix-infrastructure-research/) |

**⚠️ Важно знать:**

1. **Импорт макросов:**
   
   Макросы Rocket необходимо импортировать явно:
   ```rust
   use rocket::{get, post, catch};  // Для обработчиков
   use rocket::{routes, catchers};  // Для конфигурации
   ```
   
   В старых версиях Rust использовался `#[macro_use] extern crate rocket`, но это устаревший подход.

2. **Коды ответов:**
   
   - Невалидный JSON в теле запроса вернёт `400 Bad Request` (не `422`)
   - Обработчик `#[catch(422)]` срабатывает при других проблемах валидации

3. **Управление состоянием:**
   
   Используйте `.manage()` для глобального состояния и `&State<T>` для доступа к нему:
   ```rust
   rocket::build()
       .manage(config)
       .manage(ai_service)
   ```
   
   Типы в состоянии должны быть `Send + Sync`.

### 2.2. Tokio

**Назначение:** асинхронная среда выполнения (runtime).

**Описание:** Rust использует Tokio для эффективного управления асинхронными операциями, такими как сетевые запросы. Rocket работает поверх Tokio. Все `async` функции в нашем коде выполняются в среде Tokio.

| Ресурс | Ссылка |
|---|---|
| Официальный туториал | [https://tokio.rs/tokio/tutorial](https://tokio.rs/tokio/tutorial) |
| Туториал на Habr (часть 1) | [https://habr.com/ru/companies/timeweb/articles/815811/](https://habr.com/ru/companies/timeweb/articles/815811/) |
| Туториал на Habr (часть 2) | [https://habr.com/ru/companies/timeweb/articles/816743/](https://habr.com/ru/companies/timeweb/articles/816743/) |
| Книга по асинхронному Rust | [https://doc.rust-lang.ru/async-book/](https://doc.rust-lang.ru/async-book/) |

### 2.3. Serde

**Назначение:** сериализация и десериализация данных.

**Описание:** Serde (SERialize/DEserialize) — это мощнейший фреймворк для преобразования структур данных Rust в различные форматы (например, JSON) и обратно. В проекте он используется для автоматического преобразования входящих JSON-запросов в структуры Rust и для преобразования структур-ответов в JSON.

| Ресурс | Ссылка |
|---|---|
| Официальный сайт | [https://serde.rs/](https://serde.rs/) |
| Документация `serde_json` | [https://docs.rs/serde_json](https://docs.rs/serde_json) |
| Статья на Habr | [Кратко про Serde в Rust](https://habr.com/ru/companies/otus/articles/806247/) |
| Примеры в Rust Cookbook | [https://doc.rust-lang.ru/rust-cookbook/encoding/json.html](https://doc.rust-lang.ru/rust-cookbook/encoding/json.html) |

### 2.4. gigalib

**Назначение:** клиентская библиотека для GigaChat API.

**Описание:** Данная библиотека предоставляет удобный и высокоуровневый интерфейс для взаимодействия с GigaChat API, избавляя от необходимости вручную формировать HTTP-запросы и управлять токенами аутентификации.

| Ресурс | Ссылка |
|---|---|
| Репозиторий на GitHub | [https://github.com/commmrade/gigalib](https://github.com/commmrade/gigalib) |
| Документация на docs.rs | [https://docs.rs/gigalib](https://docs.rs/gigalib) |
| Официальная документация GigaChat | [https://developers.sber.ru/docs/ru/gigachat/api/overview](https://developers.sber.ru/docs/ru/gigachat/api/overview) |

**⚠️ Важные технические детали:**

1. **API методов конфигурации:**
   - Используйте `set_temp()` для установки температуры (не `set_temperature()`)
   - Метод `set_max_tokens()` принимает `u32`
   - Метод `set_basic_token()` принимает `&str` (не `String`)

2. **Проблемы многопоточности:**
   
   Клиент GigaChat не реализует трейт `Send`, что вызывает проблемы при работе в асинхронном контексте Rocket. Существует два подхода к решению:
   
   **Подход 1** (использован в проекте): Создавать клиент при каждом запросе внутри `spawn_blocking`:
   ```rust
   tokio::task::spawn_blocking(move || {
       let client = ClientBuilder::new()
           .set_basic_token(&token)
           .set_msg_cfg(msg_config)
           .build();
       
       let runtime = tokio::runtime::Runtime::new().unwrap();
       runtime.block_on(async {
           // работа с клиентом
       })
   }).await
   ```
   
   **Подход 2**: Хранить только токен и конфигурацию, пересоздавая клиента для каждого запроса.

3. **Рекомендации по архитектуре:**
   - Не храните `GigaClient` напрямую в структурах, которые должны быть `Send`
   - Создавайте клиент локально при необходимости выполнить запрос
   - Используйте `Arc<Mutex<>>` с осторожностью — это может привести к deadlock'ам

**Пример правильного использования:**

```rust
pub struct GigaChatService {
    token: String,
    config: GigaChatConfig,
}

impl GigaChatService {
    async fn ask(&self, question: &str) -> Result<String, AiServiceError> {
        let token = self.token.clone();
        let config = self.config.clone();
        let question = question.to_string();
        
        tokio::task::spawn_blocking(move || {
            // Создаём клиент здесь, а не в конструкторе
            let client = create_client(&token, &config);
            // ... остальная логика
        }).await
    }
}
```

## 3. Вспомогательные зависимости

### 3.1. config

**Назначение:** управление конфигурацией.

**Описание:** Позволяет загружать настройки из файлов (например, `config.toml`) и переопределять их переменными окружения, что является стандартной практикой для современных приложений.

| Ресурс | Ссылка |
|---|---|
| Документация на docs.rs | [https://docs.rs/config](https://docs.rs/config) |

### 3.2. thiserror

**Назначение:** упрощение создания типов ошибок.

**Описание:** Предоставляет удобный макрос для декларативного создания кастомных типов ошибок, что делает код обработки ошибок более чистым и читаемым.

| Ресурс | Ссылка |
|---|---|
| Документация на docs.rs | [https://docs.rs/thiserror](https://docs.rs/thiserror) |

### 3.3. tracing

**Назначение:** логирование (запись информации о работе приложения).

**Описание:** `tracing` — это фреймворк для инструментирования программ с целью сбора структурированных, событийно-ориентированных диагностических данных. Проще говоря, это мощная система логирования.

| Ресурс | Ссылка |
|---|---|
| Документация на docs.rs | [https://docs.rs/tracing](https://docs.rs/tracing) |
| Книга по `tracing` (англ.) | [https://tokio.rs/tokio/topics/tracing](https://tokio.rs/tokio/topics/tracing) |

## 4. Общие ресурсы по языку Rust

| Ресурс | Ссылка |
|---|---|
| «Книга» по Rust (рус.) | [https://doc.rust-lang.ru/book/](https://doc.rust-lang.ru/book/) |
| Rust на примерах (рус.) | [https://doc.rust-lang.ru/rust-by-example/](https://doc.rust-lang.ru/rust-by-example/) |
| Практическое руководство по Rust | [https://my-js.org/docs/guide/rust](https://my-js.org/docs/guide/rust) |

## 5. Важные практические рекомендации

### 5.1. Версия Rust

**Минимальная требуемая версия:** Rust 1.93.0

Современные зависимости проекта требуют актуальную версию Rust. Если при компиляции возникают ошибки типа "feature `edition2024` is required", обновите Rust:

```bash
rustup update
```

Проверить текущую версию:
```bash
rustc --version
```

### 5.2. Структура Cargo.toml

**Правильный порядок секций:**

```toml
[package]
# метаданные пакета

[dependencies]
# основные зависимости, включая async-trait

[dev-dependencies]
# зависимости для тестов

[features]
# флаги компиляции

[[bin]]
# конфигурация бинарного файла
```

**Распространённые ошибки:**

- ❌ Дублирование секций `[dev-dependencies]`
- ❌ Размещение зависимостей вне секций
- ❌ Указание `async-trait` после секции `[[bin]]`

### 5.3. Тестирование и отладка

**Запуск тестов:**

```bash
cargo test              # Все тесты
cargo test --lib        # Только модульные тесты
cargo test --test integration_test  # Конкретный интеграционный тест
```

**Полезные команды:**

```bash
cargo check             # Быстрая проверка без компиляции
cargo clippy            # Линтер для улучшения кода
cargo fmt               # Автоформатирование
```

### 5.4. Работа с предупреждениями

Компилятор Rust может выдавать предупреждения о неиспользуемом коде. Это нормально для учебных проектов:

- Неиспользуемые поля конфигурации часто оставляют для будущего расширения
- Можно подавить конкретные предупреждения через `#[allow(dead_code)]`
- В production-коде рекомендуется устранять все предупреждения

### 5.5. Отладка асинхронного кода

При работе с async/await:

1. **Проблемы с `Send` trait:**
   - Используйте `tokio::task::spawn_blocking` для синхронного кода
   - Избегайте хранения `Mutex` guards через границы `.await`

2. **Deadlock'и:**
   - Не блокируйте async runtime синхронными операциями
   - Используйте `tokio::sync::Mutex` вместо `std::sync::Mutex` в async контексте

3. **Тестирование:**
   - Помечайте тесты async функций как `#[tokio::test]`
   - Используйте mock-объекты для изоляции от внешних сервисов

### 5.6. Тестирование API

#### curl (универсальный инструмент)

```bash
# Health check
curl http://localhost:8000/health

# POST запрос
curl -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"question": "What is Rust?"}'
```

#### HTTPie (современная альтернатива curl)

HTTPie предоставляет более удобный и человекочитаемый синтаксис:

```bash
# Health check
http GET localhost:8000/health

# POST запрос (автоматическое определение JSON)
http POST localhost:8000/ask question="What is Rust?"

# С явным JSON
echo '{"question": "What is Rust?"}' | http POST localhost:8000/ask

# Красивый вывод с подсветкой синтаксиса (по умолчанию)
http --pretty=all POST localhost:8000/ask question="Hello"
```

**Установка HTTPie:**

| Платформа | Команда установки |
|-----------|------------------|
| **Windows** (Chocolatey) | `choco install httpie` |
| **macOS** (Homebrew) | `brew install httpie` |
| **Linux** (Debian/Ubuntu) | `sudo apt install httpie` |
| **Linux** (Fedora/RHEL) | `sudo dnf install httpie` |
| **Arch Linux** | `sudo pacman -S httpie` |
| **Универсально** (pip) | `pip install httpie` |

**Преимущества HTTPie:**
- Автоматическая подсветка синтаксиса и форматирование JSON
- Более короткий синтаксис для JSON запросов
- Автоматическое определение Content-Type
- Поддержка сессий и аутентификации
- Лучшая читаемость вывода

#### PowerShell (Windows)

```powershell
# Health check
Invoke-RestMethod -Uri "http://127.0.0.1:8000/health"

# POST запрос
$body = '{"question": "What is Rust?"}'
Invoke-RestMethod -Uri "http://127.0.0.1:8000/ask" -Method POST -Body $body -ContentType "application/json"
```

**Готовый демо-скрипт:**
```powershell
powershell -ExecutionPolicy Bypass -File demo_mock.ps1
```

### 5.7. Язык mock-ответов

Mock-сервис возвращает ответы **на английском языке**. Это сделано намеренно для корректного отображения в терминалах с различными кодировками. При интеграции с реальным GigaChat API ответы будут на языке запроса.
