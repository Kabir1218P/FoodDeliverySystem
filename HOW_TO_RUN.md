# How to Run FoodExpress Application

## Prerequisites

Before running the application, make sure you have:
- Python 3.8 or higher installed
- PostgreSQL database installed and running
- pip (Python package manager)

## Step-by-Step Instructions

### Step 1: Activate Virtual Environment

```bash
# If virtual environment doesn't exist, create it
python3 -m venv venv

# Activate virtual environment
# On macOS/Linux:
source venv/bin/activate

# On Windows:
# venv\Scripts\activate
```

### Step 2: Install Dependencies

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

**Or use the setup script:**
```bash
chmod +x setup.sh
./setup.sh
```

### Step 3: Set Up PostgreSQL Database

```bash
# Create database
createdb foodexpress

# Or using psql:
psql -U postgres
CREATE DATABASE foodexpress;
CREATE USER foodexpress WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE foodexpress TO foodexpress;
\q
```

### Step 4: Configure Environment Variables

```bash
# Copy the example environment file
cp .env.example .env

# Edit .env file with your database credentials
nano .env
# or
vim .env
# or use any text editor
```

**Update these values in `.env`:**
```env
DATABASE_URL=postgresql://foodexpress:your_password@localhost/foodexpress
SECRET_KEY=your-secret-key-here
```

**Generate a secure secret key:**
```bash
python -c "import secrets; print(secrets.token_hex(32))"
```

### Step 5: Initialize Database

**Option A: Using SQL files (Recommended)**
```bash
# Run schema
psql -U foodexpress -d foodexpress -f schema.sql

# Load sample data (optional)
psql -U foodexpress -d foodexpress -f sample_data.sql
```

**Option B: Using Python (Auto-creates tables)**
```bash
python init_db.py
```

### Step 6: Run the Application

**Development Mode:**
```bash
python run.py
```

**Or using Flask directly:**
```bash
export FLASK_APP=run.py
export FLASK_ENV=development
flask run
```

**Production Mode:**
```bash
gunicorn -c gunicorn_config.py wsgi:app
```

### Step 7: Access the Application

Once running, open your browser and visit:

- **Home Page**: http://localhost:5000
- **Admin Dashboard**: http://localhost:5000/admin
- **API Base URL**: http://localhost:5000/api/v1

## Quick Start (All-in-One)

```bash
# 1. Activate venv
source venv/bin/activate

# 2. Install dependencies
pip install -r requirements.txt

# 3. Create .env file
cp .env.example .env
# Edit .env with your database credentials

# 4. Set up database
createdb foodexpress
psql -U your_user -d foodexpress -f schema.sql

# 5. Run application
python run.py
```

## Testing the API

### Using curl:

```bash
# Get all restaurants
curl http://localhost:5000/api/v1/restaurants

# Create a customer
curl -X POST http://localhost:5000/api/v1/customers \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "1234567890",
    "address": "123 Main St"
  }'

# Get all customers
curl http://localhost:5000/api/v1/customers
```

### Using Python:

```python
import requests

# Get restaurants
response = requests.get('http://localhost:5000/api/v1/restaurants')
print(response.json())

# Create customer
data = {
    "name": "Jane Doe",
    "email": "jane@example.com",
    "address": "456 Oak Ave"
}
response = requests.post('http://localhost:5000/api/v1/customers', json=data)
print(response.json())
```

## Troubleshooting

### Issue: ModuleNotFoundError

**Solution:**
```bash
# Make sure virtual environment is activated
source venv/bin/activate

# Reinstall dependencies
pip install -r requirements.txt
```

### Issue: Database Connection Error

**Solution:**
1. Check PostgreSQL is running:
   ```bash
   # macOS
   brew services list
   
   # Linux
   sudo systemctl status postgresql
   ```

2. Verify database credentials in `.env` file
3. Test connection:
   ```bash
   psql -U foodexpress -d foodexpress
   ```

### Issue: Port Already in Use

**Solution:**
```bash
# Find process using port 5000
lsof -ti:5000

# Kill the process
lsof -ti:5000 | xargs kill

# Or change port in run.py
```

### Issue: Permission Denied

**Solution:**
```bash
# Make setup script executable
chmod +x setup.sh

# Check file permissions
ls -la
```

### Issue: Import Errors

**Solution:**
```bash
# Make sure you're in the project root directory
cd /Users/abhinavpratapsingh/Desktop/DBMSPRO

# Verify Python path
python -c "import sys; print(sys.path)"

# Reinstall in development mode
pip install -e .
```

## Running in Production

### Using Gunicorn:

```bash
# Basic
gunicorn wsgi:app

# With configuration file
gunicorn -c gunicorn_config.py wsgi:app

# With custom settings
gunicorn --bind 0.0.0.0:8000 --workers 4 wsgi:app
```

### Using systemd (Linux):

Create `/etc/systemd/system/foodexpress.service`:
```ini
[Unit]
Description=FoodExpress Gunicorn Application Server
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/path/to/DBMSPRO
Environment="PATH=/path/to/DBMSPRO/venv/bin"
ExecStart=/path/to/DBMSPRO/venv/bin/gunicorn -c gunicorn_config.py wsgi:app

[Install]
WantedBy=multi-user.target
```

Then:
```bash
sudo systemctl start foodexpress
sudo systemctl enable foodexpress
```

## Environment Variables Reference

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | Required |
| `SECRET_KEY` | Flask secret key | Required |
| `FLASK_ENV` | Environment (development/production) | development |
| `FLASK_DEBUG` | Enable debug mode | True |
| `API_PREFIX` | API URL prefix | /api/v1 |
| `LOG_LEVEL` | Logging level | INFO |
| `LOG_FILE` | Log file path | logs/app.log |

## Next Steps

1. **Explore the Admin Dashboard**: Visit http://localhost:5000/admin
2. **Test the API**: Use the examples above or tools like Postman
3. **Read the Documentation**: Check README.md for detailed API documentation
4. **Customize**: Modify models, add features, or customize the UI

## Need Help?

- Check the README.md for detailed documentation
- Review PROJECT_STRUCTURE.md for architecture details
- Check logs/app.log for error messages
- Verify all environment variables are set correctly

