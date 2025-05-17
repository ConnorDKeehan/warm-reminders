namespace WarmReminders.Api.Models.Commands;

public record PatchScheduleCommand(
    int LoginId,
    int Id, 
    DateTime NextNotificationTimeUtc, 
    int IntervalHours
);
