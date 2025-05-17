using WarmReminders.Api.Interfaces;
using WarmReminders.Api.Models.Commands;
using WarmReminders.Api.Models.Entities;
using WarmReminders.Api.Models.Requests;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WarmReminders.Api.Controllers;

[Authorize]
public class ScheduleController(IScheduleService scheduleService) : LocalReminderBaseController
{
    [HttpPost]
    public async Task<IActionResult> AddSchedule(AddScheduleRequest request)
    {
        await scheduleService.AddSchedule(new AddScheduleCommand(HttpLoginId, request.NextNotificationTimeUtc, request.IntervalHours));

        return NoContent();
    }

    [HttpGet]
    public async Task<ActionResult<List<Schedule>>> GetSchedules()
    {
        var result = await scheduleService.GetSchedules(HttpLoginId);

        return Ok(result);
    }

    [HttpPatch("{id}")]
    public async Task<IActionResult> PatchSchedule([FromRoute] int id, [FromBody] PatchScheduleRequest request)
    {
        await scheduleService.PatchSchedule(new PatchScheduleCommand(HttpLoginId, id, request.NextNotificationTimeUtc, request.IntervalHours));

        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteSchedule([FromRoute] int id)
    {
        await scheduleService.DeleteSchedule(id, HttpLoginId);

        return NoContent();
    }
}

