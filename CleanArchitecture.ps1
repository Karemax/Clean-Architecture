param(
    [string]$SolutionName = "CleanArchitecture"
)

# إنشاء فولدر المشروع
mkdir $SolutionName -Force
cd $SolutionName

# إنشاء Solution
dotnet new sln -n $SolutionName

# إنشاء المشاريع
dotnet new classlib -n "$SolutionName.Domain" -f net8.0
dotnet new classlib -n "$SolutionName.Application" -f net8.0
dotnet new classlib -n "$SolutionName.Infrastructure" -f net8.0
dotnet new webapi    -n "$SolutionName.API" -f net8.0

# إضافة المشاريع للـ Solution
dotnet sln add "$SolutionName.Domain/$SolutionName.Domain.csproj"
dotnet sln add "$SolutionName.Application/$SolutionName.Application.csproj"
dotnet sln add "$SolutionName.Infrastructure/$SolutionName.Infrastructure.csproj"
dotnet sln add "$SolutionName.API/$SolutionName.API.csproj"

# إضافة References
dotnet add "$SolutionName.Application" reference "$SolutionName.Domain"
dotnet add "$SolutionName.Infrastructure" reference "$SolutionName.Application"
dotnet add "$SolutionName.Infrastructure" reference "$SolutionName.Domain"
dotnet add "$SolutionName.API" reference "$SolutionName.Application"
dotnet add "$SolutionName.API" reference "$SolutionName.Infrastructure"
dotnet add "$SolutionName.API" reference "$SolutionName.Domain"

# إضافة Packages
dotnet add "$SolutionName.Infrastructure" package Microsoft.EntityFrameworkCore
dotnet add "$SolutionName.Infrastructure" package Microsoft.EntityFrameworkCore.InMemory
dotnet add "$SolutionName.Infrastructure" package Microsoft.EntityFrameworkCore.Design
dotnet add "$SolutionName.API" package Swashbuckle.AspNetCore
dotnet add "$SolutionName.API" package Serilog.AspNetCore
dotnet add "$SolutionName.Application" package FluentValidation

# إنشاء الفولدرات + ملفات مبدئية
mkdir "$SolutionName.Domain\Entities" -Force
mkdir "$SolutionName.Domain\Enums" -Force
"public class Order { public int Id {get;set;} }" | Out-File "$SolutionName.Domain\Entities\Order.cs"
"public enum OrderStatus { Pending, Completed, Cancelled }" | Out-File "$SolutionName.Domain\Enums\OrderStatus.cs"

mkdir "$SolutionName.Application\Interfaces" -Force
mkdir "$SolutionName.Application\DTOs" -Force
mkdir "$SolutionName.Application\Services" -Force
"public interface IOrderRepository { }" | Out-File "$SolutionName.Application\Interfaces\IOrderRepository.cs"
"public record OrderDto(int Id, decimal Total);" | Out-File "$SolutionName.Application\DTOs\OrderDto.cs"
"public class OrderService { }" | Out-File "$SolutionName.Application\Services\OrderService.cs"

mkdir "$SolutionName.Infrastructure\Persistence" -Force
mkdir "$SolutionName.Infrastructure\Repositories" -Force
"public class AppDbContext { }" | Out-File "$SolutionName.Infrastructure\Persistence\AppDbContext.cs"
"public class OrderRepository { }" | Out-File "$SolutionName.Infrastructure\Repositories\OrderRepository.cs"

mkdir "$SolutionName.API\Controllers" -Force
@"
using Microsoft.AspNetCore.Mvc;
namespace $SolutionName.API.Controllers {
    [ApiController]
    [Route("api/[controller]")]
    public class OrdersController : ControllerBase {
        [HttpGet]
        public IActionResult Get() => Ok("Hello from OrdersController");
    }
}
"@ | Out-File "$SolutionName.API\Controllers\OrdersController.cs" -Encoding UTF8

Write-Output "✅ $SolutionName setup is complete!"
