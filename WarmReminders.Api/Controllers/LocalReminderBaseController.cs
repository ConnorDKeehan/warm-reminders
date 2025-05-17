using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace WarmReminders.Api.Controllers;

[Authorize]
[ApiController]
[Route("[controller]")]
public class LocalReminderBaseController : ControllerBase
{
    protected int HttpLoginId => int.Parse(User.FindFirstValue("LoginId") ?? "0");
}

