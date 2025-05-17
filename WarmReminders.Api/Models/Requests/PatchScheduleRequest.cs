namespace WarmReminders.Api.Models.Requests;

public record PatchScheduleRequest(DateTime NextNotificationTimeUtc, int IntervalHours);

