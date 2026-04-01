# FinFresh Backend API

FinFresh is a specialized Personal Finance Management (PFM) backend built with **Python**, **Django REST Framework**, and **MongoDB**. It provides secure user authentication, transaction tracking, and real-time financial health scoring.

---

## 1. Design Decisions

### Why Python (Django REST Framework) vs Node.js?
* **Financial Precision:** Python’s `decimal` module is natively supported by Django's `DecimalField`. This prevents the floating-point binary issues common in JavaScript (e.g., `0.1 + 0.2` not equaling `0.3`), which is critical for a finance app handling currency and preventing rounding errors.
* **Security & Speed of Development:** Django provides a "batteries-included" approach to security (SQL injection protection, clickjacking protection). By using DRF, I implemented a robust, standardized API with significantly less boilerplate than an Express/Node.js setup.
* **Complex Aggregations:** Python’s readable syntax and powerful math libraries make the implementation of multi-step financial health formulas more maintainable and easier to audit.

### Project Structure
I followed a **Layered Architecture** to maintain a clean separation of concerns:
* **Models:** Defined using `djongo.models` to support MongoDB's BSON structure while maintaining Django's ORM capabilities.
* **Serializers:** Handle data validation and transformation. A key security decision was made to **never** accept `userId` from the request body; it is injected directly from the JWT.
* **Services (`services.py`):** I extracted the business logic (Health Score & Summaries) into a dedicated service layer. This keeps views "thin" and makes the financial math reusable and easier to unit test.
* **Views:** Handle the HTTP request/response cycle and permission logic using Class-Based Views (CBVs).

### Authentication Implementation
* **Stateless JWT:** Implemented via `SimpleJWT`. This removes the need for session storage on the server, ensuring the backend remains stateless and scalable.
* **Bcrypt Hashing:** User passwords are encrypted using the `bcrypt` algorithm via Django’s `AbstractBaseUser` framework.
* **Token Policy:** * **Access Token:** Short-lived (2 hours) for minimized risk.
    * **Refresh Token:** Long-lived (24 hours) to allow a seamless user experience.

### Financial Health Computation
* **On-Demand Calculation:** The health score is computed in real-time via the `/financial-health` endpoint.
* **The Formula:** The score (0–100) is a weighted average of four key pillars:
    1. **Savings Rate (25%):** Ratio of income kept vs spent.
    2. **Debt Ratio (25%):** Debt obligations measured against total income.
    3. **Investment Ratio (25%):** Tracking wealth-building behavior.
    4. **Emergency Fund (25%):** Calculated by comparing current balance against 3-month average expenses.

---

## 2. Technical Stack
* **Language:** Python 3.12
* **Framework:** Django REST Framework (DRF)
* **Database:** MongoDB (via Djongo connector)
* **Auth:** JWT (SimpleJWT)
* **Dependencies:** Bcrypt, PyMongo, Sqlparse

---

## 3. Environment Setup & Installation

### Prerequisites
* Python 3.12+
* MongoDB running locally on `mongodb://localhost:27017/`

### Steps
1. **Clone the repository:**
   ```bash
   git clone <your-repo-link>
   cd finfresh

2.   Install Dependencies:
   pip install django==3.2.25 djongo==1.3.6 pymongo[srv]==3.12.3 sqlparse==0.2.4 djangorestframework==3.14.0 djangorestframework-simplejwt==5.2.0 bcrypt

3.   Apply Migrations:
   python manage.py makemigrations authentication transactions
   python manage.py migrate

4.  Run the Development Server:
    python manage.py runserver

  ##4. API Endpoints (Postman Testing Guide)
Authentication
>POST /auth/register: Create a new account. Returns the user profile and initial JWT pair.

>POST /auth/login: Authenticates credentials and returns access and refresh tokens.

Transactions (Requires Authorization: Bearer <token>)
>GET /transactions: List user transactions (paginated).

Query Params: Supports ?type=income or ?category=food filters.

>POST /transactions: Create a transaction.

Security: The userId is automatically extracted from the JWT; do not provide it in the body.

>GET /summary: Returns aggregated monthly totals and a category-wise spending breakdown.

>GET /financial-health: Returns the numerical FinFresh health score (0-100) and a status label (e.g., "Excellent", "Healthy").   
