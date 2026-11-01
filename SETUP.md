# Quick Setup Guide

## Step 1: Install Dependencies

```bash
pip install -r requirements.txt
```

## Step 2: Configure Environment

```bash
# Copy the example environment file
cp .env.example .env

# Edit .env and update:
# - DATABASE_URL with your PostgreSQL credentials
# - SECRET_KEY (generate one using: python -c "import secrets; print(secrets.token_hex(32))")
```

## Step 3: Set Up Database

```bash
# Create PostgreSQL database
createdb foodexpress

# Run schema
psql -U your_user -d foodexpress -f schema.sql

# Load sample data (optional)
psql -U your_user -d foodexpress -f sample_data.sql
```

## Step 4: Run the Application

```bash
# Development
python run.py

# Production
gunicorn -c gunicorn_config.py wsgi:app
```

## Step 5: Access the Application

- **Home Page**: http://localhost:5000
- **Admin Dashboard**: http://localhost:5000/admin
- **API Base URL**: http://localhost:5000/api/v1

## Troubleshooting

### Database Connection Error
- Verify PostgreSQL is running
- Check DATABASE_URL in .env file
- Ensure database and user exist

### Import Errors
- Make sure you're in the project root directory
- Verify virtual environment is activated
- Reinstall dependencies: `pip install -r requirements.txt`

### Port Already in Use
- Change port in run.py or gunicorn_config.py
- Kill existing process: `lsof -ti:5000 | xargs kill`

