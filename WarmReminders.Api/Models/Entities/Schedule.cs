using AuthService.Models.Entities;

namespace WarmReminders.Api.Models.Entities;

public class Schedule
{
    public int Id { get; set; }
    public int LoginId { get; set; }
    public DateTime DateCreatedUtc {  get; set; }
    public DateTime NextNotificationTimeUtc { get; set; }
    public int IntervalHours { get; set; }

    //Navigational Properties
    public Login? Login { get; set; }
}

