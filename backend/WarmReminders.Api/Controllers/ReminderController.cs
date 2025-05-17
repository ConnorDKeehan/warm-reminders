using WarmReminders.Api.Interfaces;
using WarmReminders.Api.Models.Commands;
using WarmReminders.Api.Models.Entities;
using WarmReminders.Api.Models.Requests;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace WarmReminders.Api.Controllers;

[Authorize]
public class ReminderController(IReminderService reminderService) : LocalReminderBaseController
{
    [HttpPost]
    public async Task<IActionResult> AddReminder(AddReminderRequest request)
    {
        var loginId = HttpLoginId;
        await reminderService.AddReminder(new AddReminderCommand(HttpLoginId, request.ReminderText, request.Category, request.Importance));

        return NoContent();
    }

    [HttpGet]
    public async Task<ActionResult<List<Reminder>>> GetReminders()
    {
        var result = await reminderService.GetRemindersByLoginId(HttpLoginId);

        return Ok(result);
    }

    [HttpPatch("{id}")]
    public async Task<IActionResult> PatchReminder([FromRoute] int id, [FromBody] PatchReminderRequest request)
    {
        await reminderService.PatchReminder(new PatchReminderCommand(HttpLoginId, id, request.ReminderText, request.Category));

        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteReminder([FromRoute] int id)
    {
        await reminderService.DeleteReminder(id, HttpLoginId);

        return NoContent();
    }
}

