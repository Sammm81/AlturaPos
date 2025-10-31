# Altura POS - API Documentation

## Overview

This document describes the REST API endpoints that the Altura POS mobile/desktop application communicates with. The API follows RESTful principles and uses JSON for request/response payloads.

## Base URL

- **Development**: `http://localhost:3000/api`
- **Staging**: `https://staging-api.alturapos.com/api`
- **Production**: `https://api.alturapos.com/api`

## Authentication

All API requests (except login) require authentication using JWT tokens.

### Headers
```
Authorization: Bearer <access_token>
Content-Type: application/json
Accept: application/json
```

### Token Refresh
Tokens expire after 24 hours. Use the refresh endpoint to obtain a new token.

---

## Authentication Endpoints

### POST /auth/login
Authenticate user and obtain access token.

**Request:**
```json
{
  "username": "string",
  "password": "string"
}
```

**Response:** (200 OK)
```json
{
  "user": {
    "id": "uuid",
    "username": "string",
    "fullName": "string",
    "role": "cashier|manager|admin",
    "branchId": "uuid|null",
    "isActive": true
  },
  "accessToken": "string",
  "refreshToken": "string",
  "expiresIn": 86400
}
```

### POST /auth/refresh
Refresh access token using refresh token.

**Request:**
```json
{
  "refreshToken": "string"
}
```

**Response:** (200 OK)
```json
{
  "accessToken": "string",
  "refreshToken": "string",
  "expiresIn": 86400
}
```

### POST /auth/logout
Invalidate current session.

**Response:** (204 No Content)

---

## Menu Endpoints

### GET /menu/items
Get all menu items.

**Query Parameters:**
- `categoryId` (optional): Filter by category
- `available` (optional): Filter by availability (true/false)

**Response:** (200 OK)
```json
{
  "items": [
    {
      "id": "uuid",
      "categoryId": "uuid",
      "name": "string",
      "description": "string|null",
      "basePrice": 0.00,
      "imageUrl": "string|null",
      "isAvailable": true,
      "hasVariants": false,
      "variants": [],
      "modifiers": [],
      "createdAt": "ISO8601",
      "updatedAt": "ISO8601"
    }
  ]
}
```

### GET /menu/items/:id
Get single menu item by ID.

**Response:** (200 OK)
```json
{
  "id": "uuid",
  "categoryId": "uuid",
  "name": "string",
  "description": "string|null",
  "basePrice": 0.00,
  "imageUrl": "string|null",
  "isAvailable": true,
  "hasVariants": false,
  "variants": [
    {
      "id": "uuid",
      "name": "Small",
      "priceAdjustment": -5000
    }
  ],
  "modifiers": [
    {
      "id": "uuid",
      "name": "Extra Cheese",
      "price": 5000,
      "category": "Toppings"
    }
  ],
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

### GET /menu/categories
Get all categories.

**Response:** (200 OK)
```json
{
  "categories": [
    {
      "id": "uuid",
      "name": "string",
      "description": "string|null",
      "displayOrder": 0,
      "isActive": true,
      "icon": "string|null",
      "createdAt": "ISO8601",
      "updatedAt": "ISO8601"
    }
  ]
}
```

### PUT /menu/items/:id
Update menu item (Manager/Admin only).

**Request:**
```json
{
  "name": "string",
  "description": "string|null",
  "basePrice": 0.00,
  "isAvailable": true,
  "variants": [],
  "modifiers": []
}
```

**Response:** (200 OK) - Returns updated menu item

---

## Order Endpoints

### POST /orders
Create new order.

**Request:**
```json
{
  "orderNumber": "ORD-20251031-0001",
  "orderType": "dineIn|takeAway",
  "tableNumber": "string|null",
  "customerName": "string|null",
  "items": [
    {
      "menuItemId": "uuid",
      "menuItemName": "string",
      "basePrice": 0.00,
      "selectedVariant": {
        "id": "uuid",
        "name": "string",
        "priceAdjustment": 0.00
      },
      "selectedModifiers": [],
      "quantity": 1,
      "unitPrice": 0.00,
      "itemTotal": 0.00,
      "notes": "string|null"
    }
  ],
  "subtotal": 0.00,
  "taxAmount": 0.00,
  "discountAmount": 0.00,
  "totalAmount": 0.00,
  "notes": "string|null"
}
```

**Response:** (201 Created)
```json
{
  "id": "uuid",
  "orderNumber": "string",
  "status": "confirmed",
  "createdAt": "ISO8601"
}
```

### GET /orders
Get orders with optional filters.

**Query Parameters:**
- `status`: Filter by status (draft|confirmed|completed|cancelled)
- `startDate`: Start date (ISO8601)
- `endDate`: End date (ISO8601)
- `branchId`: Filter by branch

**Response:** (200 OK) - Returns array of orders

### GET /orders/:id
Get single order by ID.

**Response:** (200 OK) - Returns order object

---

## Transaction Endpoints

### POST /transactions
Create transaction (payment).

**Request:**
```json
{
  "orderId": "uuid",
  "transactionNumber": "TXN-20251031-0001",
  "paymentMethod": "cash|qris|card|other",
  "totalAmount": 0.00,
  "amountPaid": 0.00,
  "changeAmount": 0.00,
  "paymentReference": "string|null"
}
```

**Response:** (201 Created)
```json
{
  "id": "uuid",
  "transactionNumber": "string",
  "createdAt": "ISO8601"
}
```

---

## Sync Endpoints

### GET /sync/pull
Pull updates since last sync.

**Query Parameters:**
- `since`: ISO8601 timestamp

**Response:** (200 OK)
```json
{
  "menuItems": [],
  "categories": [],
  "users": [],
  "timestamp": "ISO8601"
}
```

### POST /sync/push
Push local changes to server.

**Request:**
```json
{
  "orders": [],
  "transactions": [],
  "menuUpdates": []
}
```

**Response:** (200 OK)
```json
{
  "success": true,
  "synced": {
    "orders": 5,
    "transactions": 5
  },
  "conflicts": []
}
```

---

## Analytics Endpoints

### GET /analytics/sales/daily
Get daily sales summary.

**Query Parameters:**
- `date`: Date (ISO8601)
- `branchId`: Branch ID (optional for managers)

**Response:** (200 OK)
```json
{
  "date": "2025-10-31",
  "totalSales": 0.00,
  "totalOrders": 0,
  "avgOrderValue": 0.00,
  "paymentMethods": {
    "cash": 0.00,
    "qris": 0.00,
    "card": 0.00
  }
}
```

### GET /analytics/items/top
Get top selling items.

**Query Parameters:**
- `startDate`: Start date
- `endDate`: End date
- `limit`: Number of items (default: 10)

**Response:** (200 OK)
```json
{
  "items": [
    {
      "menuItemId": "uuid",
      "name": "string",
      "quantitySold": 0,
      "totalRevenue": 0.00
    }
  ]
}
```

---

## Error Responses

### 400 Bad Request
```json
{
  "error": "Validation failed",
  "message": "Invalid request data",
  "errors": {
    "field": "error message"
  }
}
```

### 401 Unauthorized
```json
{
  "error": "Unauthorized",
  "message": "Invalid or expired token"
}
```

### 403 Forbidden
```json
{
  "error": "Forbidden",
  "message": "Insufficient permissions"
}
```

### 404 Not Found
```json
{
  "error": "Not Found",
  "message": "Resource not found"
}
```

### 500 Internal Server Error
```json
{
  "error": "Internal Server Error",
  "message": "An unexpected error occurred"
}
```

---

## Rate Limiting

- Rate limit: 1000 requests per hour per IP
- Header: `X-RateLimit-Remaining`
- When exceeded: 429 Too Many Requests

## Versioning

API version is included in the base URL. Current version: v1

---

## Notes

- All timestamps are in ISO8601 format (UTC)
- All monetary values are in Indonesian Rupiah (IDR)
- UUIDs are version 4
- Pagination uses `page` and `limit` query parameters where applicable
