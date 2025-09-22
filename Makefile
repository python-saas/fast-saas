# =============================================================================
# FastSaaS Development Makefile
# =============================================================================
# Quick setup: make setup
# Full setup:  make setup-full

.PHONY: help setup setup-full check-prereqs setup-env setup-secrets install-deps dev-up dev-down
.PHONY: test test-backend test-frontend lint format clean migrate logs db-shell db-reset
.PHONY: build-backend build-frontend build-all deploy-staging deploy-prod

# Default target
help: ## Show this help message
	@echo "FastSaaS Development Environment"
	@echo "================================"
	@echo ""
	@echo "Quick Start Commands:"
	@echo "  make setup         - Complete project setup for new developers"
	@echo "  make setup-full    - Full setup with dependency installation"
	@echo "  make dev           - Start development environment"
	@echo ""
	@echo "Development Commands:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# =============================================================================
# Setup Commands
# =============================================================================

setup: check-prereqs setup-env install-deps dev-up setup-complete ## Complete project setup (recommended for new developers)

setup-full: check-prereqs setup-env setup-secrets install-deps dev-up migrate setup-complete ## Full setup including secrets generation and migrations

check-prereqs: ## Check if required tools are installed
	@echo "🔍 Checking prerequisites..."
	@command -v docker >/dev/null 2>&1 || { echo "❌ Docker is required but not installed. Please install Docker and try again."; exit 1; }
	@command -v docker compose >/dev/null 2>&1 || { echo "❌ Docker Compose is required but not installed. Please install Docker Compose and try again."; exit 1; }
	@command -v uv >/dev/null 2>&1 || { echo "❌ uv is required but not installed. Please install uv (https://docs.astral.sh/uv/) and try again."; exit 1; }
	@command -v node >/dev/null 2>&1 || { echo "❌ Node.js is required but not installed. Please install Node.js and try again."; exit 1; }
	@echo "✅ All prerequisites are installed!"

setup-env: ## Set up environment files from templates
	@echo "⚙️  Setting up environment files..."
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "📝 Created .env from .env.example"; \
	else \
		echo "⚠️  .env already exists, skipping..."; \
	fi
	@if [ ! -f frontend/.env ]; then \
		cp frontend/.env.example frontend/.env; \
		echo "📝 Created frontend/.env from frontend/.env.example"; \
	else \
		echo "⚠️  frontend/.env already exists, skipping..."; \
	fi
	@echo "⚠️  Remember to update the following in .env for production:"
	@echo "   - SECRET_KEY (run: make generate-secret)"
	@echo "   - POSTGRES_PASSWORD (run: make generate-secret)"
	@echo "   - FIRST_SUPERUSER_PASSWORD"
	@echo "   - Stripe keys (STRIPE_SECRET_KEY, STRIPE_PUBLISHABLE_KEY)"
	@echo "   - Email service settings"

setup-secrets: ## Generate secure secrets for .env file
	@echo "🔐 Generating secure secrets..."
	@echo "SECRET_KEY=$$(python3 -c 'import secrets; print(secrets.token_urlsafe(32))')"
	@echo "POSTGRES_PASSWORD=$$(python3 -c 'import secrets; print(secrets.token_urlsafe(16))')"
	@echo "FIRST_SUPERUSER_PASSWORD=$$(python3 -c 'import secrets; print(secrets.token_urlsafe(12))')"
	@echo ""
	@echo "📝 Copy these values to your .env file!"

generate-secret: ## Generate a single secret key
	@python3 -c "import secrets; print(secrets.token_urlsafe(32))"

setup-complete: ## Show setup completion message
	@echo ""
	@echo "🎉 Setup Complete!"
	@echo "=================="
	@echo ""
	@echo "Your FastSaaS development environment is ready!"
	@echo ""
	@echo "URLs:"
	@echo "  Frontend:      http://localhost:5173"
	@echo "  Backend API:   http://localhost:8000"
	@echo "  API Docs:      http://localhost:8000/docs"
	@echo "  Database UI:   http://localhost:8080"
	@echo ""
	@echo "Next Steps:"
	@echo "  1. Update .env with your Stripe keys and email settings"
	@echo "  2. Run 'make migrate' to set up the database"
	@echo "  3. Run 'make logs' to monitor the application"
	@echo "  4. Visit http://localhost:5173 to see your app!"
	@echo ""

# =============================================================================
# Development Environment
# =============================================================================

install-deps: install-backend-deps install-frontend-deps ## Install all dependencies

install-backend-deps: ## Install Python backend dependencies
	@echo "📦 Installing backend dependencies..."
	@uv sync

install-frontend-deps: ## Install Node.js frontend dependencies
	@echo "📦 Installing frontend dependencies..."
	@cd frontend && npm install

dev: dev-up ## Start development environment (alias for dev-up)

dev-up: ## Start development environment with Docker Compose
	@echo "🚀 Starting development environment..."
	@docker compose watch

dev-down: ## Stop development environment
	@echo "🛑 Stopping development environment..."
	@docker compose down

dev-restart: dev-down dev-up ## Restart development environment

logs: ## Show logs from all services
	@docker compose logs -f

logs-backend: ## Show backend logs only
	@docker compose logs -f backend

logs-frontend: ## Show frontend logs only
	@docker compose logs -f frontend

logs-db: ## Show database logs only
	@docker compose logs -f db

# =============================================================================
# Database Management
# =============================================================================

migrate: ## Run database migrations
	@echo "🗄️  Running database migrations..."
	@uv run alembic upgrade head

migrate-create: ## Create a new migration (usage: make migrate-create msg="your message")
	@if [ -z "$(msg)" ]; then \
		echo "❌ Please provide a message: make migrate-create msg='your message'"; \
		exit 1; \
	fi
	@echo "📝 Creating new migration: $(msg)"
	@uv run alembic revision --autogenerate -m "$(msg)"

migrate-rollback: ## Rollback one migration
	@echo "↩️  Rolling back one migration..."
	@uv run alembic downgrade -1

db-shell: ## Connect to database shell
	@echo "🔗 Connecting to database..."
	@docker compose exec db psql -U postgres -d app

db-reset: ## Reset database (WARNING: destroys all data)
	@echo "⚠️  WARNING: This will destroy all database data!"
	@read -p "Are you sure? Type 'yes' to continue: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		docker compose down; \
		docker volume rm $$(docker volume ls -q | grep postgres) 2>/dev/null || true; \
		docker compose up -d db; \
		sleep 5; \
		make migrate; \
		echo "✅ Database reset complete!"; \
	else \
		echo "❌ Database reset cancelled."; \
	fi

# =============================================================================
# Testing
# =============================================================================

tests: test-backend-simple

test-backend-simple: ## Run backend tests without coverage
	@echo "🧪 Running backend tests (simple)..."
	@uv run pytest

test-frontend: ## Run frontend tests (if configured)
	@echo "🧪 Running frontend tests..."
	@cd frontend && npm test

# =============================================================================
# Code Quality
# =============================================================================

lint: lint-backend lint-frontend ## Run linting on all code

lint-backend: ## Run backend linting (mypy + ruff)
	@echo "🔍 Running backend linting..."
	@uv run mypy backend
	@uv run ruff check backend

lint-frontend: ## Run frontend linting
	@echo "🔍 Running frontend linting..."
	@cd frontend && npm run lint

format: format-backend ## Format all code

format-backend: ## Format backend code
	@echo "✨ Formatting backend code..."
	@uv run ruff format backend
	@uv run ruff check --fix backend

# =============================================================================
# Build Commands
# =============================================================================

build-backend: ## Build backend Docker image
	@echo "🏗️  Building backend image..."
	@docker compose build backend

build-frontend: ## Build frontend for production
	@echo "🏗️  Building frontend..."
	@cd frontend && npm run build

build-all: build-backend build-frontend ## Build all components

# =============================================================================
# Cleanup
# =============================================================================

clean: ## Clean up Docker containers, volumes, and caches
	@echo "🧹 Cleaning up..."
	@docker compose down -v
	@docker system prune -f
	@rm -rf .mypy_cache .pytest_cache .ruff_cache
	@rm -rf frontend/node_modules/.cache
	@echo "✅ Cleanup complete!"

clean-all: clean ## Complete cleanup including node_modules and .venv
	@echo "🧹 Deep cleaning..."
	@rm -rf frontend/node_modules
	@rm -rf .venv
	@echo "✅ Deep cleanup complete!"
