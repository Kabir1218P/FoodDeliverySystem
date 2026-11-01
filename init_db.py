"""
Database initialization script
"""
from app import create_app, db
from app.models import (
    Customer, Restaurant, MenuItem, DeliveryPartner,
    Order, OrderItem, Payment
)

app = create_app()

def init_db():
    """Initialize database with tables."""
    with app.app_context():
        print("Creating database tables...")
        db.create_all()
        print("Database tables created successfully!")
        
        # Check if data already exists
        if Customer.query.count() == 0:
            print("\nDatabase is empty. You can load sample data using:")
            print("psql -U your_user -d foodexpress -f sample_data.sql")
        else:
            print(f"\nDatabase already contains {Customer.query.count()} customers.")

if __name__ == '__main__':
    init_db()

