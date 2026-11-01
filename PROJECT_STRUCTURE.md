# Project Structure Documentation

## Overview

FoodExpress is organized following Flask best practices with a modular, scalable architecture.

## Directory Structure

```
DBMSPRO/
├── app/                          # Main application package
│   ├── __init__.py              # Application factory
│   ├── api/                     # API layer
│   │   ├── __init__.py
│   │   ├── routes.py            # API route registration
│   │   └── resources/           # API resource classes
│   │       ├── __init__.py
│   │       ├── customers.py     # Customer API endpoints
│   │       ├── restaurants.py   # Restaurant API endpoints
│   │       ├── menu_items.py    # Menu item API endpoints
│   │       ├── orders.py        # Order API endpoints
│   │       ├── delivery_partners.py  # Delivery partner API
│   │       └── payments.py      # Payment API endpoints
│   ├── models/                  # Database models
│   │   ├── __init__.py
│   │   ├── customer.py          # Customer model
│   │   ├── restaurant.py        # Restaurant model
│   │   ├── menu_item.py         # Menu item model
│   │   ├── order.py             # Order model
│   │   ├── order_item.py        # Order item model
│   │   ├── delivery_partner.py  # Delivery partner model
│   │   └── payment.py           # Payment model
│   ├── services/                # Business logic layer
│   │   ├── __init__.py
│   │   └── order_service.py     # Order business logic
│   ├── utils/                   # Utility functions
│   │   ├── __init__.py
│   │   ├── errors.py            # Error handling
│   │   └── validators.py        # Input validation
│   ├── templates/               # HTML templates
│   │   └── index.html           # Home page
│   └── static/                  # Static files (CSS, JS, images)
│       ├── css/
│       ├── js/
│       └── images/
├── config.py                    # Configuration management
├── run.py                       # Development server entry point
├── wsgi.py                      # Production WSGI entry point
├── init_db.py                   # Database initialization script
├── gunicorn_config.py           # Gunicorn configuration
├── requirements.txt             # Python dependencies
├── schema.sql                   # Database schema
├── sample_data.sql              # Sample data
├── .env.example                 # Environment variables template
├── .gitignore                   # Git ignore rules
├── README.md                    # Main documentation
├── SETUP.md                     # Quick setup guide
└── PROJECT_STRUCTURE.md         # This file
```

## Architecture Layers

### 1. Application Layer (`app/__init__.py`)
- Application factory pattern
- Extension initialization
- Blueprint registration
- Error handler registration

### 2. API Layer (`app/api/`)
- RESTful API endpoints
- Request/response handling
- Input validation
- Error responses

### 3. Service Layer (`app/services/`)
- Business logic
- Complex operations
- Transaction management
- Data validation

### 4. Model Layer (`app/models/`)
- Database models
- Relationships
- Data serialization
- Model methods

### 5. Utility Layer (`app/utils/`)
- Error classes
- Validation functions
- Helper functions

## Key Design Patterns

### Application Factory Pattern
The application is created using a factory function (`create_app()`) which allows:
- Multiple app instances
- Testing with different configurations
- Better separation of concerns

### Resource-Based API
Using Flask-RESTful for:
- Clean URL structure
- Standard HTTP methods
- Consistent response format

### Service Layer Pattern
Business logic separated from API layer:
- Reusable logic
- Easier testing
- Better maintainability

## Data Flow

1. **Request** → API Resource
2. **API Resource** → Validates input
3. **Service Layer** → Processes business logic
4. **Model Layer** → Database operations
5. **Response** → JSON formatted data

## Configuration Management

- **Development**: Uses `.env` file
- **Production**: Environment variables
- **Testing**: In-memory SQLite database

## Database Models Relationships

```
Customer (1) ──< (N) Order
Restaurant (1) ──< (N) Order
Restaurant (1) ──< (N) MenuItem
Order (1) ──< (N) OrderItem
Order (1) ──< (1) Payment
MenuItem (1) ──< (N) OrderItem
DeliveryPartner (1) ──< (N) Order
```

## API Endpoint Structure

All API endpoints follow RESTful conventions:
- `GET /api/v1/{resource}` - List resources
- `POST /api/v1/{resource}` - Create resource
- `GET /api/v1/{resource}/{id}` - Get resource
- `PUT /api/v1/{resource}/{id}` - Update resource
- `DELETE /api/v1/{resource}/{id}` - Delete resource

## Error Handling

- Custom exception classes
- Consistent error response format
- Proper HTTP status codes
- Logging of errors

## Security Considerations

- Environment variables for secrets
- Input validation
- SQL injection prevention (SQLAlchemy ORM)
- CORS configuration
- Secret key management

