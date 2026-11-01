# Table Usage Summary

This document explains how all database tables are used in the Food Delivery Management System (DBMSPRO).

## Database Schema Overview

The system uses **7 main tables**:

1. **customers** - Customer information
2. **restaurants** - Restaurant information
3. **menu_items** - Restaurant menu items
4. **delivery_partners** - Delivery personnel
5. **orders** - Customer orders (central table)
6. **order_items** - Items in each order (junction table)
7. **payments** - Payment records for orders

---

## Table Relationships

```
customers (1) ──→ (N) orders
restaurants (1) ──→ (N) orders
restaurants (1) ──→ (N) menu_items
delivery_partners (1) ──→ (N) orders
orders (1) ──→ (N) order_items
menu_items (1) ──→ (N) order_items
orders (1) ──→ (1) payments
```

---

## 1. CUSTOMERS Table (`customers`)

### Purpose
Stores customer information for the food delivery platform.

### Fields
- `id` (Primary Key)
- `name` - Customer name
- `email` - Unique email address
- `phone` - Contact phone number
- `address` - Delivery address
- `created_at` - Account creation timestamp

### API Endpoints
- `GET /customers` - List all customers (with pagination)
- `POST /customers` - Create new customer
- `GET /customers/<id>` - Get specific customer
- `PUT /customers/<id>` - Update customer
- `DELETE /customers/<id>` - Delete customer

### Usage in Code
- **Resource**: `app/api/resources/customers.py`
- **Model**: `app/models/customer.py`
- Used in orders to identify who placed the order
- Cascades: Deleting a customer also deletes their orders

### Example Usage
```python
# Creating a customer
customer = Customer(
    name="John Doe",
    email="john@example.com",
    phone="1234567890",
    address="123 Main St"
)

# Customer is referenced in orders
order = Order(customer_id=customer.id, ...)
```

---

## 2. RESTAURANTS Table (`restaurants`)

### Purpose
Stores restaurant information and details.

### Fields
- `id` (Primary Key)
- `name` - Restaurant name
- `address` - Restaurant location
- `phone` - Contact number
- `cuisine` - Type of cuisine (e.g., Italian, Chinese)
- `rating` - Restaurant rating (0-5)

### API Endpoints
- `GET /restaurants` - List all restaurants (filterable by cuisine, can include menu)
- `POST /restaurants` - Create new restaurant
- `GET /restaurants/<id>` - Get specific restaurant (can include menu items)
- `PUT /restaurants/<id>` - Update restaurant
- `DELETE /restaurants/<id>` - Delete restaurant

### Usage in Code
- **Resource**: `app/api/resources/restaurants.py`
- **Model**: `app/models/restaurant.py`
- Has relationship with `menu_items` (one restaurant has many menu items)
- Has relationship with `orders` (one restaurant has many orders)
- Can include menu items when retrieving restaurant details

### Example Usage
```python
# Creating a restaurant
restaurant = Restaurant(
    name="Pizza Palace",
    address="456 Food St",
    cuisine="Italian",
    rating=4.5
)

# Restaurant referenced in orders and menu items
order = Order(restaurant_id=restaurant.id, ...)
menu_item = MenuItem(restaurant_id=restaurant.id, ...)
```

---

## 3. MENU_ITEMS Table (`menu_items`)

### Purpose
Stores individual food items available at restaurants.

### Fields
- `id` (Primary Key)
- `restaurant_id` (Foreign Key → restaurants)
- `name` - Item name
- `description` - Item description
- `price` - Item price
- `available` - Availability flag (boolean)

### API Endpoints
- `GET /menu-items` - List all menu items (filterable by restaurant_id, available_only)
- `POST /menu-items` - Create new menu item
- `GET /menu-items/<id>` - Get specific menu item
- `PUT /menu-items/<id>` - Update menu item
- `DELETE /menu-items/<id>` - Delete menu item

### Usage in Code
- **Resource**: `app/api/resources/menu_items.py`
- **Model**: `app/models/menu_item.py`
- Referenced in `order_items` to track what was ordered
- Validated during order creation to ensure:
  - Item exists
  - Item is available
  - All items in order belong to same restaurant

### Example Usage
```python
# Creating a menu item
menu_item = MenuItem(
    restaurant_id=1,
    name="Margherita Pizza",
    price=12.99,
    available=True
)

# Used when creating orders
order_item = OrderItem(
    menu_item_id=menu_item.id,
    quantity=2,
    price=menu_item.price
)
```

---

## 4. DELIVERY_PARTNERS Table (`delivery_partners`)

### Purpose
Stores delivery personnel information who deliver orders.

### Fields
- `id` (Primary Key)
- `name` - Partner name
- `phone` - Contact number
- `vehicle_type` - Type of vehicle (e.g., bike, car)
- `status` - Current status (available, busy, offline)

### API Endpoints
- `GET /delivery-partners` - List all delivery partners (filterable by status)
- `POST /delivery-partners` - Create new delivery partner
- `GET /delivery-partners/<id>` - Get specific delivery partner
- `PUT /delivery-partners/<id>` - Update delivery partner
- `DELETE /delivery-partners/<id>` - Delete delivery partner

### Usage in Code
- **Resource**: `app/api/resources/delivery_partners.py`
- **Model**: `app/models/delivery_partner.py`
- Referenced in `orders` (optional - order can be created without delivery partner)
- Status can be updated when assigned to order (changes from 'available' to 'busy')

### Example Usage
```python
# Creating a delivery partner
partner = DeliveryPartner(
    name="Mike Driver",
    phone="9876543210",
    vehicle_type="bike",
    status="available"
)

# Assigned to orders
order = Order(delivery_partner_id=partner.id, ...)

# Status updated in OrderService.assign_delivery_partner()
partner.status = 'busy'
```

---

## 5. ORDERS Table (`orders`) - **CENTRAL TABLE**

### Purpose
The core table that connects customers, restaurants, and delivery partners. Represents a customer order.

### Fields
- `id` (Primary Key)
- `customer_id` (Foreign Key → customers)
- `restaurant_id` (Foreign Key → restaurants)
- `delivery_partner_id` (Foreign Key → delivery_partners, nullable)
- `status` - Order status (placed, confirmed, preparing, dispatched, delivered, cancelled)
- `total_amount` - Total order amount (calculated from order_items)
- `created_at` - Order creation timestamp

### API Endpoints
- `GET /orders` - List all orders (filterable by customer_id, restaurant_id, status, can include items)
- `POST /orders` - Create new order (uses OrderService)
- `GET /orders/<id>` - Get specific order (can include items, customer, restaurant info)
- `PUT /orders/<id>/status` - Update order status

### Usage in Code
- **Resource**: `app/api/resources/orders.py`
- **Model**: `app/models/order.py`
- **Service**: `app/services/order_service.py` - Contains business logic for order creation
- Central table that connects:
  - Customer (who ordered)
  - Restaurant (where order is from)
  - Delivery Partner (who will deliver - optional)
  - Order Items (what was ordered)
  - Payment (payment record)

### Key Business Logic
1. **Order Creation** (OrderService.create_order):
   - Validates all menu items exist and are available
   - Ensures all items belong to same restaurant
   - Creates order_items records
   - Calculates total_amount from order_items

2. **Status Updates**:
   - Validates status transitions
   - Can trigger delivery partner assignment

### Example Usage
```python
# Creating an order (through OrderService)
order_data = {
    'customer_id': 1,
    'restaurant_id': 1,
    'items': [
        {'menu_item_id': 1, 'quantity': 2},
        {'menu_item_id': 2, 'quantity': 1}
    ]
}
order = OrderService.create_order(order_data)

# Order links to all related entities
order.customer      # Customer object
order.restaurant    # Restaurant object
order.order_items   # List of OrderItem objects
order.payment       # Payment object (one-to-one)
order.delivery_partner  # DeliveryPartner object (optional)
```

---

## 6. ORDER_ITEMS Table (`order_items`) - **JUNCTION TABLE**

### Purpose
Junction table connecting orders and menu_items. Stores quantity and price for each item in an order.

### Fields
- `id` (Primary Key)
- `order_id` (Foreign Key → orders)
- `menu_item_id` (Foreign Key → menu_items)
- `quantity` - Number of items ordered
- `price` - Price at time of order (snapshot for historical accuracy)

### API Endpoints
- **No direct endpoints** - Managed through orders
- Retrieved when fetching orders with `include_items=true`

### Usage in Code
- **Model**: `app/models/order_item.py`
- **Service**: Created automatically in `OrderService.create_order()`
- Stores price snapshot (even if menu item price changes later)
- Used to calculate order total

### Key Points
- Price is stored at order time (historical record)
- Quantity must be > 0
- Cascades: Deleting order deletes all order_items

### Example Usage
```python
# Created automatically during order creation
for item_data in order_data['items']:
    menu_item = MenuItem.query.get(item_data['menu_item_id'])
    order_item = OrderItem(
        order_id=order.id,
        menu_item_id=menu_item.id,
        quantity=item_data['quantity'],
        price=menu_item.price  # Snapshot price
    )
    total_amount += order_item.price * order_item.quantity
```

---

## 7. PAYMENTS Table (`payments`)

### Purpose
Stores payment information for orders. One payment per order (one-to-one relationship).

### Fields
- `id` (Primary Key)
- `order_id` (Foreign Key → orders, unique)
- `amount` - Payment amount
- `method` - Payment method (card, upi, cash, wallet)
- `status` - Payment status (pending, success, failed)
- `paid_at` - Timestamp when payment completed

### API Endpoints
- `GET /payments` - List all payments (filterable by order_id, status)
- `POST /payments` - Create new payment for an order
- `GET /payments/<id>` - Get specific payment
- `PUT /payments/<id>` - Update payment (especially status)

### Usage in Code
- **Resource**: `app/api/resources/payments.py`
- **Model**: `app/models/payment.py`
- One-to-one relationship with orders (unique order_id)
- Status tracking: pending → success/failed
- `paid_at` automatically set when status changes to 'success'

### Key Business Logic
- Only one payment per order allowed
- Status changes automatically update `paid_at` timestamp
- Valid payment methods: card, upi, cash, wallet

### Example Usage
```python
# Creating a payment
payment = Payment(
    order_id=order.id,
    amount=order.total_amount,
    method='upi',
    status='pending'
)

# Updating payment status
payment.status = 'success'
payment.paid_at = datetime.utcnow()  # Auto-set when status = 'success'
```

---

## Data Flow: Complete Order Lifecycle

### 1. **Setup Phase**
```
Create Restaurant → Create Menu Items → Create Customer → Create Delivery Partner
```

### 2. **Order Creation Flow**
```
Customer places order
    ↓
POST /orders (with customer_id, restaurant_id, items[])
    ↓
OrderService.create_order():
    1. Validates customer exists
    2. Validates restaurant exists
    3. Validates all menu_items exist and are available
    4. Ensures all items belong to same restaurant
    5. Creates Order record
    6. Creates OrderItem records (with price snapshots)
    7. Calculates total_amount
    ↓
Order created with status='placed'
```

### 3. **Payment Flow**
```
Order exists
    ↓
POST /payments (with order_id, amount, method)
    ↓
Payment created with status='pending'
    ↓
PUT /payments/<id> (update status='success')
    ↓
paid_at timestamp set automatically
```

### 4. **Order Fulfillment Flow**
```
Order Status Progression:
placed → confirmed → preparing → dispatched → delivered

Optional: Assign delivery partner
PUT /orders/<id>/status (or use OrderService.assign_delivery_partner())
```

---

## Key Integration Points

### OrderService (`app/services/order_service.py`)
- **Main business logic hub**
- Creates orders and order_items together
- Validates cross-table relationships
- Ensures data integrity

### Model Relationships
All relationships are bidirectional using SQLAlchemy's `relationship()` and `back_populates`:
- `Customer.orders` ↔ `Order.customer`
- `Restaurant.menu_items` ↔ `MenuItem.restaurant`
- `Restaurant.orders` ↔ `Order.restaurant`
- `Order.order_items` ↔ `OrderItem.order`
- `MenuItem.order_items` ↔ `OrderItem.menu_item`
- `Order.payment` ↔ `Payment.order`
- `DeliveryPartner.orders` ↔ `Order.delivery_partner`

---

## Summary of Table Usage

| Table | Direct API | Used Via | Main Purpose |
|-------|-----------|----------|--------------|
| customers | ✅ Yes | Orders | Store customer info |
| restaurants | ✅ Yes | Orders, Menu Items | Store restaurant info |
| menu_items | ✅ Yes | Order Items | Store food items |
| delivery_partners | ✅ Yes | Orders | Store delivery personnel |
| orders | ✅ Yes | N/A | **Central hub** - connects everything |
| order_items | ❌ No | Orders | Junction table for order contents |
| payments | ✅ Yes | Orders | Store payment records |

All tables are actively used and integrated through the orders table, which serves as the central connection point for the entire food delivery workflow.



