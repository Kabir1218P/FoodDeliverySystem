#!/bin/bash

echo "🚀 FoodExpress Quick Start"
echo "=========================="
echo ""

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "📥 Installing dependencies..."
pip install --upgrade pip -q
pip install -r requirements.txt -q

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "⚙️  Creating .env file..."
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "⚠️  IMPORTANT: Please edit .env file with your database credentials!"
        echo "   Edit: DATABASE_URL and SECRET_KEY"
    else
        echo "❌ .env.example not found. Creating basic .env..."
        cat > .env << EOF
DATABASE_URL=postgresql://foodexpress:your_password@localhost/foodexpress
SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_hex(32))")
FLASK_ENV=development
FLASK_DEBUG=True
API_PREFIX=/api/v1
LOG_LEVEL=INFO
LOG_FILE=logs/app.log
EOF
        echo "⚠️  Please edit .env file with your database credentials!"
    fi
else
    echo "✓ .env file already exists"
fi

# Create logs directory
mkdir -p logs

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Edit .env file with your PostgreSQL credentials"
echo "2. Set up database:"
echo "   createdb foodexpress"
echo "   psql -U your_user -d foodexpress -f schema.sql"
echo "3. Run the application:"
echo "   python run.py"
echo ""
echo "🌐 Then visit:"
echo "   - Home: http://localhost:5000"
echo "   - Admin: http://localhost:5000/admin"
echo "   - API: http://localhost:5000/api/v1"
echo ""

