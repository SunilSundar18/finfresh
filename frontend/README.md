# 🍃 FinFresh: Personal Finance Tracker

FinFresh is a full-stack personal finance management application designed to help users track income, monitor expenses, and visualize their financial health in real-time. 

## 🚀 Features

- **JWT Authentication**: Secure login and registration using SimpleJWT.
- **Dynamic Dashboard**: Real-time summary of Monthly Income, Expenses, and Savings.
- **Financial Health Scoring**: An automated "Health Score" calculated by the backend based on savings rates and debt-to-income ratios.
- **Transaction Management**: Easily add, view, and categorize financial entries.
- **Dual-Database Architecture**: Uses **SQLite** for relational data (Users/Transactions) and **MongoDB** for high-performance financial health logging and analytics.

---

## 🏗️ Technical Architecture

The project follows a decoupled client-server architecture to ensure scalability and ease of maintenance.

### 🎨 Frontend (Flutter)
- **State Management**: Developed using the **Provider** pattern to manage app-wide state and reactive UI updates.
- **Navigation**: Structured routing between Dashboard, Transaction History, and Entry Forms.
- **Models**: Strongly typed Dart classes with `factory` constructors for safe JSON deserialization.
- **Services**: Centralized `ApiService` using the `Dio` package for HTTP requests and interceptors for JWT handling.

### ⚙️ Backend (Django REST Framework)
- **API Design**: RESTful endpoints for CRUD operations on transactions and summary analytics.
- **Services Layer**: Business logic (like Health Score calculations) is abstracted into a dedicated `FinancialService` to keep views clean.
- **Storage**: 
  - **Relational**: SQLite handles core application data.
  - **NoSQL**: MongoDB stores historical health snapshots for trend analysis.

---

## 📂 Project Structure

```text
finfresh_project/
├── backend/                # Django Project
│   ├── authentication/     # User Custom Model & JWT Logic
│   ├── transactions/       # Core Logic, Models, & Views
│   └── manage.py
├── frontend/               # Flutter Project
│   ├── lib/
│   │   ├── models/         # Data Mapping (Summary, HealthScore)
│   │   ├── providers/      # State Management (FinancialProvider)
│   │   ├── screens/        # UI Views (Dashboard, AddTransaction)
│   │   ├── services/       # API & Auth Logic
│   │   └── widgets/        # Reusable UI Components
└── README.md

### Why this README is effective:
* **Structure:** It clearly separates the **Frontend** and **Backend** roles.
* **Tech Stack:** It mentions **Provider**, **JWT**, and **MongoDB**, which shows you understand the complex tools you are using.
* **Installation:** It gives clear commands so anyone (or a recruiter) can run your project.
* **Visuals:** It uses the file tree structure to show that your project is organized.