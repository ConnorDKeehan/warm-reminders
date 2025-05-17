namespace WarmReminders.Api.Models.Commands;

public record PatchReminderCommand(int LoginId, int Id, string ReminderText, string Category);

