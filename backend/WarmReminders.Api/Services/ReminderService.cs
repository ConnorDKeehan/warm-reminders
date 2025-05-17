using WarmReminders.Api.Contexts;
using WarmReminders.Api.Interfaces;
using WarmReminders.Api.Models.Commands;
using WarmReminders.Api.Models.Entities;
using Microsoft.EntityFrameworkCore;

namespace WarmReminders.Api.Services;

public class ReminderService(WarmRemindersContext dbContext) : IReminderService
{
    public async Task<List<Reminder>> GetRemindersByLoginId(int loginId)
    {
        var result = await dbContext.Reminders
            .Where(x => x.LoginId == loginId)
            .OrderByDescending(x => x.Id)
            .ToListAsync();

        return result;
    }

    public async Task AddReminder(AddReminderCommand command)
    {
        await dbContext.Reminders.AddAsync(new Reminder { 
            LoginId = command.LoginId,
            ReminderText = command.ReminderText,
            Category = command.Category,
            DateCreatedUtc = DateTime.UtcNow,
            AmountOfTimesShown = 0,
            Importance = command.Importance,
        });

        await dbContext.SaveChangesAsync();
    }

    public async Task PatchReminder(PatchReminderCommand command)
    {
        var reminder = await dbContext.FindAsync<Reminder>(command.Id) ??
            throw new KeyNotFoundException($"No reminder with {command.Id}");

        if (reminder.LoginId != command.LoginId)
        {
            throw new UnauthorizedAccessException($"The schedule: {reminder.Id} does not belong to the login: {command.LoginId}");
        }

        reminder.ReminderText = command.ReminderText;
        reminder.Category = command.Category;

        await dbContext.SaveChangesAsync();
    }

    public async Task<Reminder> GetRandomReminderToShow(int loginId)
    {
        var usersReminders = await dbContext.Reminders
            .Where(x => x.LoginId == loginId)
            .ToListAsync();

        var weightedReminders = usersReminders
            .SelectMany(item => Enumerable.Repeat(item, item.Importance))
            .ToList();

        var random = new Random();

        var randomReminder = weightedReminders
            .OrderBy(x => random.Next())
            .FirstOrDefault();

        if (randomReminder == null)
        {
            throw new Exception($"LoginId:{loginId} has no reminders");
        }

        randomReminder.DateLastShownUtc = DateTime.UtcNow;
        randomReminder.AmountOfTimesShown++;

        await dbContext.SaveChangesAsync();

        return randomReminder;
    }

    public async Task DeleteReminder(int id, int loginId)
    {
        await dbContext.Reminders
            .Where(x => x.Id == id && x.LoginId == loginId)
            .ExecuteDeleteAsync();
    }
}

