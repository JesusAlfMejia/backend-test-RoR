# **Nexu Backend Coding Challenge**

This is my solution for the Nexu Backend Coding Challenge. The application provides a backend API, with features like average price calculations, filtering, and validations.

---

## **Setup Instructions**

### **Prerequisites**

- Ruby (version >= 3.0.0)
- Rails (version >= 7.0.0)
- PostgreSQL (should also work fine with SQLite3)

### **Installation**

1. Clone this repository:

   ```bash
   git clone https://github.com/JesusAlfMejia/backend-test-RoR.git
   cd backend-test-RoR
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Set up the database:

   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Run the server:
   ```bash
   rails server
   ```
   The server should run at [http://localhost:3000](http://localhost:3000).

---

## **API Documentation**

### **1. GET /brands**

Returns a list of all brands with their average prices.

**Note:** The average price for each brand is calculated based on the `average_price` of its models, excluding models with an `average_price` of `0`.

**Response Example**:

```json
[
  { "id": 1, "name": "Acura", "average_price": 702109 },
  { "id": 2, "name": "Audi", "average_price": 630759 }
]
```

---

### **2. GET /brands/:id/models**

Returns all models belonging to a specific brand.

**Response Example**:

```json
[
  { "id": 1, "name": "ILX", "average_price": 303176 },
  { "id": 2, "name": "MDX", "average_price": 448193 }
]
```

---

### **3. POST /brands**

Creates a new brand. The `name` must be unique.

**Request Example**:

```json
{ "name": "BYD" }
```

**Response Example**:

```json
{ "message": "Brand created successfully", "id": 62, "name": "BYD" }
```

---

### **4. POST /brands/:id/models**

Creates a new model for a specific brand. The `average_price` defaults to `0` if not provided. Additionally, the `average_price` must be higher than 100,000.

**Request Example**:

```json
{ "name": "Dolphin", "average_price": 400000 }
```

**Response Example**:

```json
{ "message": "Model created successfully", "id": 1, "name": "Dolphin" }
```

---

### **5. PUT /models/:id**

Updates the `average_price` of a model. `average_price` must be greater than `100,000`.

**Request Example**:

```json
{ "average_price": 350000 }
```

**Response Example**:

```json
{ "message": "Model updated successfully", "id": 1, "name": "Dolphin" }
```

---

### **6. GET /models?greater=&lower=**

Returns a list of all models. If the `greater` or `lower` parameter is provided, then the returned models are filtered based on the specified `average_price` range.

**Request Example**:

```bash
GET /models?greater=380000&lower=400000
```

**Response Example**:

```json
[
  { "id": 194, "name": "CX9", "average_price": 383370 },
  { "id": 1542, "name": "ELF 200", "average_price": 380933 }
]
```

---

### **7. POST /reset** (For Testing Purposes Only)

Resets the database tables (`models` and `brands`) by deleting their contents and re-seeding the `models.json` file into the database. This is meant to be used only for testing and in case you need a clean slate.

**Request Example**:

```bash
POST /reset
```

**Response Example**:

```json
{ "message": "Database reset successfully" }
```

---

## **Testing**

To run the test suite:

1. Ensure the test database is set up:

   ```bash
   rails db:test:prepare
   ```

2. Run the tests:
   ```bash
   rspec
   ```

---

## **Live API**

The API has been deployed and can be accessed at the following URL:

https://backend-test-ror.onrender.com

You can use the endpoints described above to interact with the API.

**Note:** The server enters a sleep state after a period of inactivity to save on resources. If you access an endpoint while the server is sleeping, there might be a delay as the server starts up. Thank you for your patience!

---

## **Personal Comments**

Thank you for taking the time to review my submission!

I had a lot of fun working on this assigment as I think it was somewhat challenging but also simple enough, which allowed me to show my abilities as a Software Engineer. This project was also my first experience coding in Ruby and using Rails, so it was a really amazing learning experience. I actually ended up enjoying Ruby on Rails a lot, which made this assigment even more fun and I hope to be able to work on more Ruby on Rails projects in the future.
