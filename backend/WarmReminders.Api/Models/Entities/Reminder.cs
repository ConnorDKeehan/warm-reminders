namespace WarmReminders.Api.Models.Entities;

public class Reminder
{
    public int Id { get; set; }
    public int LoginId { get; set; }
    public required string ReminderText { get; set; }
    public required string Category { get; set; }
    public DateTime DateCreatedUtc { get; set; }
    public DateTime? DateLastShownUtc { get; set; }
    public int AmountOfTimesShown { get; set; }
    public int Importance { get; set; }
}