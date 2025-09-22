# Disclaimer!

This is a preview of [FastSaas](https://www.fast-saas.com).

This repository shows the architecture, file structure and main features of the template. Start your SaaS today and get the full version at [www.fast-saas.com](https://www.fast-saas.com).

# FastSaaS Quick Start Guide

Get your FastSaaS development environment running in minutes!

## 🚀 One-Command Setup

For new developers, just run:

```bash
make setup
```

This single command will:
- ✅ Check all prerequisites are installed
- 📝 Set up environment files from templates
- 📦 Install Python and Node.js dependencies
- 🚀 Start the development environment
- 🎉 Show you all the URLs to access your app

## 📋 Prerequisites

Make sure you have these installed:
- **Docker & Docker Compose** - For containerized development
- **uv** - Python package manager ([install guide](https://docs.astral.sh/uv/))
- **Node.js** - For the React frontend

## 🔧 Full Setup (Recommended)

For a complete setup with secure secrets:

```bash
make setup-full
```

This includes everything from `make setup` plus:
- 🔐 Generates secure secrets for your `.env` file
- 🗄️ Runs database migrations

## ⚡ Development URLs

Once setup is complete, access your app at:

| Service | URL | Description |
|---------|-----|-------------|
| Frontend | http://localhost:5173 | React development server |
| Backend API | http://localhost:8000 | FastAPI backend |
| API Docs | http://localhost:8000/docs | Interactive API documentation |
| Database UI | http://localhost:8080 | Adminer database interface |

## 📝 Next Steps

After running `make setup`:

1. **Configure Services** (Optional):
   ```bash
   # Generate secure secrets for production
   make setup-secrets

   # Copy the generated values to your .env file
   # Update Stripe keys and email settings
   ```

2. **Start Development**:
   ```bash
   # Start development environment
   make dev

   # View logs from all services
   make logs

   # Run tests
   make tests

   # Format code
   make format
   ```

3. **Database Operations**:
   ```bash
   # Run migrations
   make migrate

   # Create new migration
   make migrate-create msg="add new feature"

   # Connect to database
   make db-shell
   ```

4. **Test the application**:

Login using the credentials defined in your FIRST_SUPERUSER and FIRST_SUPERUSER_PASSWORD environment variables

## 🛠️ Common Commands

```bash
# Start development environment
make dev

# Stop development environment
make dev-down

# Restart everything
make dev-restart

# View help for all available commands
make help

# Clean up containers and caches
make clean
```

## 🔍 Troubleshooting

**Command not found?**
- Make sure `make` is installed on your system
- On macOS: `brew install make` or use Xcode Command Line Tools

**Docker issues?**
- Ensure Docker is running: `docker --version`
- Check Docker Compose: `docker compose version`

**Python/Node issues?**
- Install uv: `curl -LsSf https://astral.sh/uv/install.sh | sh`
- Install Node.js: https://nodejs.org/

**Need help?**
- Run `make help` to see all available commands
- Contact us at admin@fast-saas.com, we'll be happy to assist!

## 🏗️ Project Structure

```
fastapi-saas/
├── app/                 # Python backend (FastAPI)
├── frontend/           # React frontend
├── scripts/           # Development scripts
├── .env.example       # Environment template
├── Makefile          # Development commands
└── docker-compose.yml # Container configuration
```

---

**That's it!** 🎉

Your FastSaaS development environment should now be running. Visit http://localhost:5173 to see your application!
