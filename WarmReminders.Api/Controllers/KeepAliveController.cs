using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WarmReminders.Api.Controllers;

[AllowAnonymous]
public class KeepAliveController : LocalReminderBaseController
{
    [HttpGet]
    public IActionResult Ping()
    {
        return Ok();
    }
}
