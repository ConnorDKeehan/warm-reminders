using AuthService.Contexts;
using WarmReminders.Api.Models.Entities;
using Microsoft.EntityFrameworkCore;

namespace WarmReminders.Api.Contexts;

public class WarmRemindersContext : AuthContext
{
    public WarmRemindersContext(DbContextOptions<AuthContext> options) : base(options)
    {
    }

    public DbSet<Reminder> Reminders { get; set; }
    public DbSet<Schedule> Schedules { get; set; }
}

