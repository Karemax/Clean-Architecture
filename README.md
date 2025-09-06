
## 🏛️ Clean Architecture

A Practical Reference for Clean Architecture in .NET 8

## 📖 What is Clean Architecture?

Clean Architecture is a software design pattern introduced by Robert C. Martin (Uncle Bob).
Its main goal is to create systems that are:
Independent of frameworks

✅ Clear separation of concerns

✅ Easy to replace infrastructure (e.g., switch from InMemory to SQL Server)

✅ Domain remains pure and independent

✅ Great for testing and long-term scalability



## 🏗️ Project Structure

    +---------------------------+
    |       Presentation        | ← Web API / UI
    +---------------------------+
    |       Application         | ← Business Logic, Services, Use Cases
    +---------------------------+
    |          Domain           | ← Entities, Enums, Core Rules
    +---------------------------+
    |      Infrastructure       | ← Database, External APIs, Repositories
    +---------------------------+

Domain → Core business rules

Application → Use cases and business logic

Infrastructure → Data access (EF Core, repositories)

API → Exposes functionality through HTTP endpoints

🔹 Dependencies always point inward:
Infrastructure → Application → Domain
UI → Application → Domain


## 🚀 Features

✅ Layered separation (Domain, Application, Infrastructure, API)

✅ Dependency Injection & Inversion of Control

✅ In-Memory database seeding for testing

✅ Well-commented code in English and Arabic

## ⚡ Getting Started

1️⃣ Clone the repository

    git clone https://github.com/YourUsername/CleanArchitectureRestaurant.git
    cd CleanArchitectureRestaurant

2️⃣ Run the API

    dotnet run --project CleanArchitectureRestaurant.API

3️⃣ Explore Swagger UI

  Open in browser:

    https://localhost:5001/swagger

🧪 Example Endpoints

    GET /api/orders → List all orders

    POST /api/orders → Create new order
    
## 📜 License

MIT License. Free to use and modify.
