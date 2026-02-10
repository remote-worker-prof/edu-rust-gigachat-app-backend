# CORS для edu-rust-gigachat-app-frontend (Rocket 0.5)

Документ предназначен для студентов и преподавателей и описывает, как добавить
CORS‑поддержку в backend (Rocket), чтобы учебный UI мог обращаться к API.

Текст написан простым техническим языком с академической точностью.

## 1. Контекст

UI запускается на `http://127.0.0.1:8080`, backend — на `http://127.0.0.1:8000`.
Это **разные origin** (разные порты). Браузер запрещает такие запросы,
если сервер явно не разрешает их через CORS‑заголовки.

### Симптомы в UI

- сообщение `Failed to fetch` или «Ошибка шлюза: Сетевая ошибка»;
- в консоли браузера — `blocked by CORS policy`.

## 2. Что должен делать backend

Минимум:

1. Добавлять `Access-Control-Allow-Origin` в ответы API.
2. Обрабатывать **preflight** (OPTIONS)‑запросы.

Минимальный набор заголовков:

- `Access-Control-Allow-Origin: http://127.0.0.1:8080`
- `Access-Control-Allow-Methods: GET, POST, OPTIONS`
- `Access-Control-Allow-Headers: Content-Type`

## 3. Где в проекте вносить изменения

- Основная конфигурация Rocket: `src/main.rs`.
- Маршруты: `src/handlers/mod.rs`.

## 4. Рекомендуемое решение (без сторонних крейтов)

### Шаг 1. Добавить маршрутизатор для OPTIONS

В `src/handlers/mod.rs`:

```rust
use rocket::http::Status;
use rocket::options;
use std::path::PathBuf;

#[options("/<_path..>")]
fn cors_preflight(_path: PathBuf) -> Status {
    Status::NoContent
}
```

Смысл: Rocket вернёт корректный статус 204 на любые preflight‑запросы.
Не забудьте, что в `src/handlers/mod.rs` все маршрутные макросы
импортируются явно — добавьте `options` рядом с `get`, `post`, `catch`.

### Шаг 2. Добавить CORS‑fairing

В удобном месте (например, `src/main.rs` или отдельном модуле):

```rust
use rocket::fairing::{Fairing, Info, Kind};
use rocket::http::Header;
use rocket::{Request, Response};

pub struct Cors;

#[rocket::async_trait]
impl Fairing for Cors {
    fn info(&self) -> Info {
        Info {
            name: "Add CORS headers",
            kind: Kind::Response,
        }
    }

    async fn on_response<'r>(&self, _req: &'r Request<'_>, res: &mut Response<'r>) {
        res.set_header(Header::new(
            "Access-Control-Allow-Origin",
            "http://127.0.0.1:8080",
        ));
        res.set_header(Header::new(
            "Access-Control-Allow-Methods",
            "GET, POST, OPTIONS",
        ));
        res.set_header(Header::new(
            "Access-Control-Allow-Headers",
            "Content-Type",
        ));
    }
}
```

### Шаг 3. Подключить fairing и OPTIONS‑маршрут

В `rocket()` (в `src/main.rs`) добавить:

```rust
rocket::custom(figment)
    .attach(Cors)
    .mount("/", routes![/* existing routes */, cors_preflight])
```

## 5. Проверка (ручная)

1. Запустить backend.
2. Запустить UI.
3. Нажать «Проверить» на экране статуса.
4. В консоли браузера не должно быть ошибок CORS.

Дополнительно можно проверить через curl:

```bash
curl -i -H "Origin: http://127.0.0.1:8080" http://127.0.0.1:8000/health

curl -i -X OPTIONS \
  -H "Origin: http://127.0.0.1:8080" \
  -H "Access-Control-Request-Method: POST" \
  http://127.0.0.1:8000/ask
```

В ответе должны быть заголовки `Access-Control-Allow-*`.

## 6. Важные примечания

- В учебной среде допустимо использовать `Access-Control-Allow-Origin: *`,
  но в реальных проектах лучше разрешать **конкретный** origin.
- Если в будущем UI будет на другом порте, нужно обновить значение origin.
- Можно сделать origin настраиваемым через конфиг, но это не обязательно
  для лабораторной работы.

## 7. Отсылки к основной документации

- `docs/common_issues.md` — объяснение ошибки CORS для студентов.
- `docs/api_examples.md` — примеры запросов к API.
- `docs/student_guide.md` — общие правила запуска.
- В проекте UI: `edu-rust-gigachat-app-frontend/docs/common_issues.md` и
  `edu-rust-gigachat-app-frontend/docs/build_and_run.md`.
