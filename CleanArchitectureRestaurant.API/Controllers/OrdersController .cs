using CleanArchitectureRestaurant.Application.Services;
using Microsoft.AspNetCore.Mvc;

namespace CleanArchitectureRestaurant.API.Controllers;

/// <summary>
/// API controller for handling orders.
/// الكنترولر الخاص بالـ API للتعامل مع الطلبات
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    private readonly OrderService _orderService;

    public OrdersController(OrderService orderService)
    {
        _orderService = orderService;
    }

    /// <summary>
    /// Get all orders.
    /// جلب كل الطلبات
    /// </summary>
    [HttpGet]
    public async Task<IActionResult> GetOrders()
    {
        var orders = await _orderService.GetOrdersAsync();
        return Ok(orders);
    }

    /// <summary>
    /// Create a new order.
    /// إنشاء طلب جديد
    /// </summary>
    [HttpPost]
    public async Task<IActionResult> CreateOrder([FromBody] CreateOrderRequest request)
    {
        var order = await _orderService.CreateOrderAsync(request.CustomerName, request.Total);
        return Ok(order);
    }
}

/// <summary>
/// Request body for creating an order.
/// جسم الطلب لإنشاء أوردر جديد
/// </summary>
public record CreateOrderRequest(string CustomerName, decimal Total);
