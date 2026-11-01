# FoodExpress - Food Delivery Management System

A comprehensive, production-ready food delivery management system built with Flask, SQLAlchemy, and PostgreSQL. This system provides complete CRUD operations for managing customers, restaurants, menu items, orders, delivery partners, and payments.

## 🚀 Features

- **Complete REST API** - Full CRUD operations for all entities
- **Admin Dashboard** - Flask-Admin interface for easy data management
- **Database Models** - Well-structured SQLAlchemy models with relationships
- **Input Validation** - Comprehensive validation for all inputs
- **Error Handling** - Custom error handling with proper HTTP status codes
- **Pagination** - Built-in pagination for all list endpoints
- **Service Layer** - Business logic separated into service classes
- **Production Ready** - Gunicorn configuration and deployment setup
- **Environment Configuration** - Secure configuration management with .env files

## 📋 Prerequisites

- Python 3.8+
- PostgreSQL 12+
- pip (Python package manager)

## 🛠️ Installation

### 1. Clone the repository

```bash
git clone <repository-url>
cd DBMSPRO
```

### 2. Create and activate virtual environment

```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Set up PostgreSQL database

```bash
# Create database
createdb foodexpress

# Create user (optional)
createuser -P foodexpress
```

### 5. Configure environment variables

```bash
# Copy example environment file
cp .env.example .env

# Edit .env file with your database credentials
nano .env
```

Update the following in `.env`:
```
DATABASE_URL=postgresql://foodexpress:your_password@localhost/foodexpress
SECRET_KEY=your-secret-key-here
```

**Important:** Generate a secure secret key:
```python
import secrets
print(secrets.token_hex(32))
```

### 6. Initialize database

```bash
# Option 1: Using SQL files
psql -U foodexpress -d foodexpress -f schema.sql
psql -U foodexpress -d foodexpress -f sample_data.sql

# Option 2: Using Flask (tables will be created automatically)
python run.py
```

## 🏃 Running the Application

### Development Mode

```bash
python run.py
```

The application will be available at `http://localhost:5000`

### Production Mode

```bash
# Using Gunicorn
gunicorn -c gunicorn_config.py wsgi:app

# Or with custom settings
gunicorn --bind 0.0.0.0:8000 --workers 4 wsgi:app
```

## 📚 API Documentation

### Base URL
```
http://localhost:5000/api/v1
```

### Endpoints

#### Customers
- `GET /api/v1/customers` - List all customers
- `POST /api/v1/customers` - Create a new customer
- `GET /api/v1/customers/{id}` - Get customer details
- `PUT /api/v1/customers/{id}` - Update customer
- `DELETE /api/v1/customers/{id}` - Delete customer

#### Restaurants
- `GET /api/v1/restaurants` - List all restaurants
- `POST /api/v1/restaurants` - Create a new restaurant
- `GET /api/v1/restaurants/{id}` - Get restaurant details
- `PUT /api/v1/restaurants/{id}` - Update restaurant
- `DELETE /api/v1/restaurants/{id}` - Delete restaurant

#### Menu Items
- `GET /api/v1/menu-items` - List all menu items
- `POST /api/v1/menu-items` - Create a new menu item
- `GET /api/v1/menu-items/{id}` - Get menu item details
- `PUT /api/v1/menu-items/{id}` - Update menu item
- `DELETE /api/v1/menu-items/{id}` - Delete menu item

#### Orders
- `GET /api/v1/orders` - List all orders
- `POST /api/v1/orders` - Create a new order
- `GET /api/v1/orders/{id}` - Get order details
- `PUT /api/v1/orders/{id}/status` - Update order status

#### Delivery Partners
- `GET /api/v1/delivery-partners` - List all delivery partners
- `POST /api/v1/delivery-partners` - Create a new delivery partner
- `GET /api/v1/delivery-partners/{id}` - Get delivery partner details
- `PUT /api/v1/delivery-partners/{id}` - Update delivery partner
- `DELETE /api/v1/delivery-partners/{id}` - Delete delivery partner

#### Payments
- `GET /api/v1/payments` - List all payments
- `POST /api/v1/payments` - Create a new payment
- `GET /api/v1/payments/{id}` - Get payment details
- `PUT /api/v1/payments/{id}` - Update payment

### Query Parameters

- `page` - Page number for pagination (default: 1)
- `per_page` - Items per page (default: 20)
- `include_items` - Include order items (true/false)
- `include_menu` - Include menu items for restaurants (true/false)
- `status` - Filter by status
- `cuisine` - Filter restaurants by cuisine
- `restaurant_id` - Filter menu items by restaurant
- `customer_id` - Filter orders by customer

### Example API Calls

```bash
# Get all restaurants
curl http://localhost:5000/api/v1/restaurants

# Create a new customer
curl -X POST http://localhost:5000/api/v1/customers \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "1234567890",
    "address": "123 Main St"
  }'

# Create an order
curl -X POST http://localhost:5000/api/v1/orders \
  -H "Content-Type: application/json" \
  -d '{
    "customer_id": 1,
    "restaurant_id": 1,
    "items": [
      {
        "menu_item_id": 1,
        "quantity": 2
      }
    ]
  }'
```

## 🎨 Admin Dashboard

Access the admin dashboard at:
```
http://localhost:5000/admin
```

The admin interface provides:
- Visual CRUD operations for all entities
- Search and filtering capabilities
- Relationship management
- Data export options

## 📁 Project Structure

```
DBMSPRO/
├── app/
│   ├── __init__.py          # Application factory
│   ├── api/                 # API resources
│   │   ├── routes.py        # API routes
│   │   └── resources/       # API resource classes
│   ├── models/              # Database models
│   ├── services/            # Business logic
│   ├── templates/           # HTML templates
│   ├── static/              # Static files
│   └── utils/               # Utility functions
├── config.py                # Configuration management
├── run.py                   # Development server
├── wsgi.py                  # Production WSGI entry
├── gunicorn_config.py       # Gunicorn configuration
├── requirements.txt         # Python dependencies
├── schema.sql               # Database schema
├── sample_data.sql          # Sample data
└── README.md               # This file
```

## 🔒 Security Considerations

1. **Environment Variables**: Never commit `.env` file. Use `.env.example` as a template.
2. **Secret Key**: Generate a strong secret key for production.
3. **Database Credentials**: Use strong passwords and restrict database access.
4. **CORS**: Configure CORS origins appropriately for production.
5. **HTTPS**: Use HTTPS in production (configure SSL in gunicorn_config.py).

## 🧪 Testing

```bash
# Run tests (when implemented)
pytest

# With coverage
pytest --cov=app
```

## 📊 Database Migrations

To set up Alembic for database migrations:

```bash
# Initialize Alembic
alembic init migrations

# Create a migration
alembic revision --autogenerate -m "Initial migration"

# Apply migrations
alembic upgrade head
```

## 🚀 Deployment

### Using Gunicorn

```bash
gunicorn -c gunicorn_config.py wsgi:app
```

### Using Docker (example)

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["gunicorn", "-c", "gunicorn_config.py", "wsgi:app"]
```

### Environment Variables for Production

Set these in your production environment:
- `FLASK_ENV=production`
- `SECRET_KEY=<strong-secret-key>`
- `DATABASE_URL=<production-database-url>`
- `PORT=8000`

## 📝 License

This project is open source and available under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📧 Support

For issues and questions, please open an issue on the repository.

---

**Built with ❤️ using Flask, SQLAlchemy, and PostgreSQL**

