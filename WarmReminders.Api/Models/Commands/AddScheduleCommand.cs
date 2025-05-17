namespace WarmReminders.Api.Models.Commands;

public record AddScheduleCommand(int LoginId, DateTime NextNotificationTimeUtc, int IntervalHours);
