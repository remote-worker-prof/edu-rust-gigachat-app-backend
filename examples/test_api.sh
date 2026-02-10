#!/bin/bash
# Скрипт для тестирования API через curl
# 
# Использование:
#   chmod +x examples/test_api.sh
#   ./examples/test_api.sh

set -e

BASE_URL="http://localhost:8000"

echo "🧪 Тестирование API демонстрационного приложения"
echo "================================================"
echo ""

# Цвета для вывода
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 1. Проверка корневого эндпоинта
echo -e "${BLUE}1. GET /${NC}"
curl -s "$BASE_URL/" | head -n 5
echo ""
echo ""

# 2. Проверка health
echo -e "${BLUE}2. GET /health${NC}"
curl -s "$BASE_URL/health" | jq '.'
echo ""
echo ""

# 3. Задать вопрос про Rust
echo -e "${BLUE}3. POST /ask - Вопрос про Rust${NC}"
curl -s -X POST "$BASE_URL/ask" \
  -H "Content-Type: application/json" \
  -d '{"question": "Что такое Rust?"}' | jq '.'
echo ""
echo ""

# 4. Задать вопрос про Rocket
echo -e "${BLUE}4. POST /ask - Вопрос про Rocket${NC}"
curl -s -X POST "$BASE_URL/ask" \
  -H "Content-Type: application/json" \
  -d '{"question": "Что такое Rocket?"}' | jq '.'
echo ""
echo ""

# 5. Тест с пустым вопросом (должна быть ошибка)
echo -e "${BLUE}5. POST /ask - Пустой вопрос (ожидается ошибка)${NC}"
curl -s -X POST "$BASE_URL/ask" \
  -H "Content-Type: application/json" \
  -d '{"question": ""}' | jq '.'
echo ""
echo ""

# 6. Тест несуществующего эндпоинта (404)
echo -e "${BLUE}6. GET /nonexistent - Несуществующий эндпоинт (ожидается 404)${NC}"
curl -s "$BASE_URL/nonexistent" | jq '.'
echo ""
echo ""

echo -e "${GREEN}✅ Все тесты выполнены!${NC}"
