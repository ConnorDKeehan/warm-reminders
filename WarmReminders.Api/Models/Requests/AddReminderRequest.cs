namespace WarmReminders.Api.Models.Requests;

public record AddReminderRequest(string ReminderText, string Category, int Importance);
