#!/bin/bash

SOLUTION_NAME="CleanArchitecture"

# إنشاء فولدر المشروع
mkdir -p $SOLUTION_NAME
cd $SOLUTION_NAME

# إنشاء Solution
dotnet new sln -n $SOLUTION_NAME

# إنشاء المشاريع
dotnet new classlib -n "$SOLUTION_NAME.Domain" -f net8.0
dotnet new classlib -n "$SOLUTION_NAME.Application" -f net8.0
dotnet new classlib -n "$SOLUTION_NAME.Infrastructure" -f net8.0
dotnet new webapi    -n "$SOLUTION_NAME.API" -f net8.0

# إضافة المشاريع للـ Solution
dotnet sln add "$SOLUTION_NAME.Domain/$SOLUTION_NAME.Domain.csproj"
dotnet sln add "$SOLUTION_NAME.Application/$SOLUTION_NAME.Application.csproj"
dotnet sln add "$SOLUTION_NAME.Infrastructure/$SOLUTION_NAME.Infrastructure.csproj"
dotnet sln add "$SOLUTION_NAME.API/$SOLUTION_NAME.API.csproj"

# إضافة References
dotnet add "$SOLUTION_NAME.Application" reference "$SOLUTION_NAME.Domain"
dotnet add "$SOLUTION_NAME.Infrastructure" reference "$SOLUTION_NAME.Application"
dotnet add "$SOLUTION_NAME.Infrastructure" reference "$SOLUTION_NAME.Domain"
dotnet add "$SOLUTION_NAME.API" reference "$SOLUTION_NAME.Application"
dotnet add "$SOLUTION_NAME.API" reference "$SOLUTION_NAME.Infrastructure"
dotnet add "$SOLUTION_NAME.API" reference "$SOLUTION_NAME.Domain"

# إضافة Packages
dotnet add "$SOLUTION_NAME.Infrastructure" package Microsoft.EntityFrameworkCore
dotnet add "$SOLUTION_NAME.Infrastructure" package Microsoft.EntityFrameworkCore.InMemory
dotnet add "$SOLUTION_NAME.Infrastructure" package Microsoft.EntityFrameworkCore.Design
dotnet add "$SOLUTION_NAME.API" package Swashbuckle.AspNetCore
dotnet add "$SOLUTION_NAME.API" package Serilog.AspNetCore
dotnet add "$SOLUTION_NAME.Application" package FluentValidation

# إنشاء الفولدرات + ملفات مبدئية
mkdir -p "$SOLUTION_NAME.Domain/Entities"
mkdir -p "$SOLUTION_NAME.Domain/Enums"
echo "public class Order { public int Id {get;set;} }" > "$SOLUTION_NAME.Domain/Entities/Order.cs"
echo "public enum OrderStatus { Pending, Completed, Cancelled }" > "$SOLUTION_NAME.Domain/Enums/OrderStatus.cs"

mkdir -p "$SOLUTION_NAME.Application/Interfaces"
mkdir -p "$SOLUTION_NAME.Application/DTOs"
mkdir -p "$SOLUTION_NAME.Application/Services"
echo "public interface IOrderRepository { }" > "$SOLUTION_NAME.Application/Interfaces/IOrderRepository.cs"
echo "public record OrderDto(int Id, decimal Total);" > "$SOLUTION_NAME.Application/DTOs/OrderDto.cs"
echo "public class OrderService { }" > "$SOLUTION_NAME.Application/Services/OrderService.cs"

mkdir -p "$SOLUTION_NAME.Infrastructure/Persistence"
mkdir -p "$SOLUTION_NAME.Infrastructure/Repositories"
echo "public class AppDbContext { }" > "$SOLUTION_NAME.Infrastructure/Persistence/AppDbContext.cs"
echo "public class OrderRepository { }" > "$SOLUTION_NAME.Infrastructure/Repositories/OrderRepository.cs"

mkdir -p "$SOLUTION_NAME.API/Controllers"
cat <<EOL > "$SOLUTION_NAME.API/Controllers/OrdersController.cs"
using Microsoft.AspNetCore.Mvc;
namespace $SOLUTION_NAME.API.Controllers {
    [ApiController]
    [Route("api/[controller]")]
    public class OrdersController : ControllerBase {
        [HttpGet]
        public IActionResult Get() => Ok("Hello from OrdersController");
    }
}
EOL

echo "✅ $SOLUTION_NAME setup is complete!"
