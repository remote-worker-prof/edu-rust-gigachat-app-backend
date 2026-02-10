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

## Issue Tracking

This project uses **bd (beads)** for issue tracking.
Run `bd prime` for workflow context, or install hooks (`bd hooks install`) for auto-injection.

Quick reference:
- `bd ready` - Find unblocked work
- `bd create "Title" --type task --priority 2` - Create issue
- `bd update <id> --status in_progress` - Claim work
- `bd close <id>` - Complete work
- `bd sync` - Sync with git (if this repo is a git repo)

For full workflow details: `bd prime`
