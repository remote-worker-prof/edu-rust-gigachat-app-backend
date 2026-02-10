# Demo script for MockAiService testing

Write-Host "=== Mock AI Service Demo ===" -ForegroundColor Cyan
Write-Host "Application is running in mock mode without GigaChat API" -ForegroundColor Gray
Write-Host ""

# Test 1: Health check
Write-Host "1. Server health check (/health)" -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health" -Method GET
    Write-Host "   Status: $($health.status)" -ForegroundColor Green
    Write-Host "   Version: $($health.version)" -ForegroundColor Green
    Write-Host "   GigaChat enabled: $($health.gigachat_enabled) (using mocks)" -ForegroundColor Green
} catch {
    Write-Host "   Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 2: Greeting
Write-Host "2. Greeting test" -ForegroundColor Yellow
try {
    $body = @{ question = "Hello!" } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/ask" -Method POST -Body $body -ContentType "application/json"
    Write-Host "   Question: Hello!" -ForegroundColor Cyan
    Write-Host "   Answer:" -ForegroundColor Green
    Write-Host "   $($response.answer)" -ForegroundColor White
    Write-Host "   Source: $($response.source)" -ForegroundColor DarkGray
} catch {
    Write-Host "   Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 3: Question about Rust
Write-Host "3. Question about Rust" -ForegroundColor Yellow
try {
    $body = @{ question = "What is Rust?" } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/ask" -Method POST -Body $body -ContentType "application/json"
    Write-Host "   Question: What is Rust?" -ForegroundColor Cyan
    Write-Host "   Answer:" -ForegroundColor Green
    Write-Host "   $($response.answer)" -ForegroundColor White
} catch {
    Write-Host "   Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 4: Question about Rocket
Write-Host "4. Question about Rocket" -ForegroundColor Yellow
try {
    $body = @{ question = "What is Rocket framework?" } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/ask" -Method POST -Body $body -ContentType "application/json"
    Write-Host "   Question: What is Rocket framework?" -ForegroundColor Cyan
    Write-Host "   Answer:" -ForegroundColor Green
    Write-Host "   $($response.answer)" -ForegroundColor White
} catch {
    Write-Host "   Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 5: Question about async
Write-Host "5. Question about async programming" -ForegroundColor Yellow
try {
    $body = @{ question = "Tell me about async programming" } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/ask" -Method POST -Body $body -ContentType "application/json"
    Write-Host "   Question: Tell me about async programming" -ForegroundColor Cyan
    Write-Host "   Answer:" -ForegroundColor Green
    Write-Host "   $($response.answer)" -ForegroundColor White
} catch {
    Write-Host "   Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 6: Question about REST API
Write-Host "6. Question about REST API" -ForegroundColor Yellow
try {
    $body = @{ question = "What is REST API?" } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/ask" -Method POST -Body $body -ContentType "application/json"
    Write-Host "   Question: What is REST API?" -ForegroundColor Cyan
    Write-Host "   Answer:" -ForegroundColor Green
    Write-Host "   $($response.answer)" -ForegroundColor White
} catch {
    Write-Host "   Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 7: Question about testing
Write-Host "7. Question about testing" -ForegroundColor Yellow
try {
    $body = @{ question = "How to test Rust code?" } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/ask" -Method POST -Body $body -ContentType "application/json"
    Write-Host "   Question: How to test Rust code?" -ForegroundColor Cyan
    Write-Host "   Answer:" -ForegroundColor Green
    Write-Host "   $($response.answer)" -ForegroundColor White
} catch {
    Write-Host "   Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 8: Question about error handling
Write-Host "8. Question about error handling" -ForegroundColor Yellow
try {
    $body = @{ question = "How does Rust handle errors?" } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/ask" -Method POST -Body $body -ContentType "application/json"
    Write-Host "   Question: How does Rust handle errors?" -ForegroundColor Cyan
    Write-Host "   Answer:" -ForegroundColor Green
    Write-Host "   $($response.answer)" -ForegroundColor White
} catch {
    Write-Host "   Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 9: Question about JSON/Serde
Write-Host "9. Question about JSON/Serde" -ForegroundColor Yellow
try {
    $body = @{ question = "What is JSON serialization?" } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/ask" -Method POST -Body $body -ContentType "application/json"
    Write-Host "   Question: What is JSON serialization?" -ForegroundColor Cyan
    Write-Host "   Answer:" -ForegroundColor Green
    Write-Host "   $($response.answer)" -ForegroundColor White
} catch {
    Write-Host "   Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 10: Question about how the app works
Write-Host "10. Question about how this app works" -ForegroundColor Yellow
try {
    $body = @{ question = "How does this work?" } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/ask" -Method POST -Body $body -ContentType "application/json"
    Write-Host "   Question: How does this work?" -ForegroundColor Cyan
    Write-Host "   Answer:" -ForegroundColor Green
    Write-Host "   $($response.answer)" -ForegroundColor White
} catch {
    Write-Host "   Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 11: General question (default response)
Write-Host "11. General question (default response)" -ForegroundColor Yellow
try {
    $body = @{ question = "Tell me something interesting" } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/ask" -Method POST -Body $body -ContentType "application/json"
    Write-Host "   Question: Tell me something interesting" -ForegroundColor Cyan
    Write-Host "   Answer:" -ForegroundColor Green
    Write-Host "   $($response.answer)" -ForegroundColor White
} catch {
    Write-Host "   Error: $_" -ForegroundColor Red
}

Write-Host ""

# Test 12: Empty question (validation test)
Write-Host "12. Empty question (validation test)" -ForegroundColor Yellow
try {
    $body = @{ question = "" } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/ask" -Method POST -Body $body -ContentType "application/json"
    if ($response.error) {
        Write-Host "   Validation works! Error returned:" -ForegroundColor Green
        Write-Host "   Error: $($response.error)" -ForegroundColor Yellow
        Write-Host "   Code: $($response.code)" -ForegroundColor Yellow
    } else {
        Write-Host "   Unexpected: received answer instead of error!" -ForegroundColor Red
    }
} catch {
    Write-Host "   HTTP Error received (expected)" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Demo completed ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "MockAiService provides useful answers for:" -ForegroundColor Yellow
Write-Host "  - Rust programming language" -ForegroundColor White
Write-Host "  - Rocket web framework" -ForegroundColor White
Write-Host "  - Async programming" -ForegroundColor White
Write-Host "  - REST API concepts" -ForegroundColor White
Write-Host "  - Serde and JSON serialization" -ForegroundColor White
Write-Host "  - Testing in Rust" -ForegroundColor White
Write-Host "  - Error handling" -ForegroundColor White
Write-Host ""
Write-Host "To use real GigaChat API:" -ForegroundColor Yellow
Write-Host "  1. Create .env file" -ForegroundColor White
Write-Host "  2. Add: GIGACHAT_TOKEN=your_token_here" -ForegroundColor White
Write-Host "  3. Restart the application" -ForegroundColor White
