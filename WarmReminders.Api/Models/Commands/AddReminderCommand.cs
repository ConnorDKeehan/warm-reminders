namespace WarmReminders.Api.Models.Commands;

public record AddReminderCommand(int LoginId, string ReminderText, string Category, int Importance);

