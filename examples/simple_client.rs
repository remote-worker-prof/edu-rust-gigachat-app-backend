//! Пример простого клиента для демонстрационного API.
//!
//! Этот пример показывает, как можно использовать reqwest для
//! отправки запросов к нашему API из другого Rust приложения.
//!
//! # Запуск
//!
//! ```bash
//! # Сначала запустите сервер в одном терминале
//! cargo run
//!
//! # Затем запустите этот пример в другом терминале
//! cargo run --example simple_client
//! ```

use serde::{Deserialize, Serialize};

/// Структура запроса (должна совпадать с AskRequest на сервере)
#[derive(Serialize)]
struct AskRequest {
    question: String,
}

/// Структура ответа (должна совпадать с AskResponse на сервере)
#[derive(Deserialize, Debug)]
struct AskResponse {
    answer: String,
    source: String,
}

/// Структура для health check
#[derive(Deserialize, Debug)]
struct HealthResponse {
    status: String,
    version: String,
    gigachat_enabled: bool,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let base_url = "http://localhost:8000";

    println!("🔌 Подключаемся к серверу...\n");

    // 1. Проверяем здоровье сервера
    println!("1️⃣  Проверка состояния сервера:");
    let health_response = reqwest::get(format!("{}/health", base_url))
        .await?
        .json::<HealthResponse>()
        .await?;

    println!("   Статус: {}", health_response.status);
    println!("   Версия: {}", health_response.version);
    println!("   GigaChat: {}\n", if health_response.gigachat_enabled { "включён" } else { "выключен" });

    // 2. Задаём несколько вопросов
    let questions = vec![
        "Что такое Rust?",
        "Что такое Rocket?",
        "Привет!",
    ];

    for (i, question) in questions.iter().enumerate() {
        println!("{}️⃣  Вопрос: {}", i + 2, question);

        let client = reqwest::Client::new();
        let request = AskRequest {
            question: question.to_string(),
        };

        let response = client
            .post(format!("{}/ask", base_url))
            .json(&request)
            .send()
            .await?;

        if response.status().is_success() {
            let ask_response = response.json::<AskResponse>().await?;
            println!("   Источник: {}", ask_response.source);
            println!("   Ответ: {}\n", ask_response.answer);
        } else {
            println!("   ❌ Ошибка: {}\n", response.status());
        }
    }

    println!("✅ Все запросы выполнены успешно!");

    Ok(())
}
