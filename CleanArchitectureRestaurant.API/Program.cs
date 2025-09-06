using CleanArchitectureRestaurant.Application.Interfaces;
using CleanArchitectureRestaurant.Application.Services;
using CleanArchitectureRestaurant.Domain.Entities;
using CleanArchitectureRestaurant.Infrastructure.Persistence;
using CleanArchitectureRestaurant.Infrastructure.Repositories;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

/// <summary>
/// Add services to the container.
/// هنا بنضيف الخدمات للـ Dependency Injection Container
/// </summary>

// Register DbContext with InMemory database
// تسجيل قاعدة البيانات InMemory للتجربة
builder.Services.AddDbContext<AppDbContext>(opt =>
    opt.UseInMemoryDatabase("RestaurantDb"));

// Register repository and services
// تسجيل المستودع (Repository) والخدمة (Service)
builder.Services.AddScoped<IOrderRepository, OrderRepository>();
builder.Services.AddScoped<OrderService>();

// Add controllers and Swagger
// إضافة الكنترولرز والسواجِر للتوثيق
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

/// <summary>
/// Configure the HTTP request pipeline.
/// تكوين خط سير معالجة الطلبات
/// </summary>
if (app.Environment.IsDevelopment())
{
    // Enable Swagger UI in development mode
    // تفعيل Swagger UI في وضع التطوير
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Map controllers to routes
// ربط الكنترولرز بالمسارات
app.MapControllers();

/// <summary>
/// Seed initial data into the InMemory database.
/// إضافة بيانات تجريبية أولية عند تشغيل التطبيق
/// </summary>
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();

    if (!db.Orders.Any()) // لو مفيش بيانات
    {
        db.Orders.AddRange(
            new Order { CustomerName = "Ahmed", Total = 150 },
            new Order { CustomerName = "Sara", Total = 200 },
            new Order { CustomerName = "John", Total = 120 }
        );
        db.SaveChanges();
    }
}

// Run the application
// تشغيل التطبيق
app.Run();
