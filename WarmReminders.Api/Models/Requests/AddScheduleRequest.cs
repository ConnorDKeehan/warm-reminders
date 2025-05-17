namespace WarmReminders.Api.Models.Requests;

public record AddScheduleRequest(DateTime NextNotificationTimeUtc, int IntervalHours);

