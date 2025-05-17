using AuthService.Contexts;
using AuthService.Models.Entities;
using FirebaseAdmin.Messaging;
using Google.Api.Gax;
using WarmReminders.Api.Contexts;
using WarmReminders.Api.Interfaces;
using WarmReminders.Api.Models.Commands;
using WarmReminders.Api.Models.Entities;
using WarmReminders.Api.Models.Requests;
using WarmReminders.Api.Scheduling;
using Microsoft.EntityFrameworkCore;

namespace WarmReminders.Api.Services;

public class ScheduleService(
    WarmRemindersContext dbContext, 
    IFirebaseService firebaseService, 
    IReminderService reminderService,
    ILogger<ScheduleService> logger,
    IEventQueue queue) : IScheduleService
{
    public async Task<List<Schedule>> GetSchedules(int loginId)
    {
        var result = await dbContext.Schedules
            .Where(x => x.LoginId == loginId)
            .ToListAsync();

        return result;
    }
    
    public async Task PatchSchedule(PatchScheduleCommand command)
    {
        var schedule = await dbContext.FindAsync<Schedule>(command.Id) ??
            throw new KeyNotFoundException($"No schedule found with {command.Id}");
        
        if(schedule.LoginId != command.LoginId)
        {
            throw new UnauthorizedAccessException($"The schedule: {schedule.Id} does not belong to the login: {command.LoginId}");
        }

        schedule.IntervalHours = command.IntervalHours;
        schedule.NextNotificationTimeUtc = command.NextNotificationTimeUtc;

        await dbContext.SaveChangesAsync();
    }

    public async Task AddSchedule(AddScheduleCommand command)
    {
        var schedule = new Schedule
        {
            LoginId = command.LoginId,
            DateCreatedUtc = DateTime.UtcNow,
            NextNotificationTimeUtc = command.NextNotificationTimeUtc,
            IntervalHours = command.IntervalHours
        };

        await dbContext.Schedules.AddAsync(schedule);
        await dbContext.SaveChangesAsync();

        await queue.EnqueueAsync(new ScheduledEvent(schedule.Id, schedule.NextNotificationTimeUtc));
    }

    public async Task DeleteSchedule(int id, int loginId)
    {
        await dbContext.Schedules
            .Where(x => x.Id == id && x.LoginId == loginId)
            .ExecuteDeleteAsync();
    }

    public async Task RescheduleNotifications()
    {
        var schedules = await dbContext.Schedules.ToListAsync();

        foreach(var schedule in schedules)
        {
            if(schedule.NextNotificationTimeUtc < DateTime.UtcNow)
            {
                logger.LogWarning($"Somehow the next schedule time is less than now for schedule: {schedule.Id}");
                schedule.NextNotificationTimeUtc = DateTime.UtcNow.AddHours(schedule.IntervalHours);
                await dbContext.SaveChangesAsync();
            }

            await queue.EnqueueAsync(new ScheduledEvent(schedule.Id, schedule.NextNotificationTimeUtc));
        }
    }

    public async Task HandleScheduledNotification(int scheduleId)
    {
        var schedule = await dbContext.Schedules
            .Include(x => x.Login)
            .Where(x => x.Id == scheduleId)
            .SingleAsync();

        if (schedule == null)
        {
            //Implies schedule has been deleted therefore should not trigger push notification or requeue.
            return;
        }

        var login = schedule.Login ?? throw new Exception($"Failed to link scheduleId: {scheduleId} to a login");

        var pushNotificationToken = login.PushNotificationToken;

        if(pushNotificationToken == null)
        {
            await dbContext.Schedules.Where(x => x.LoginId == login.Id).ExecuteDeleteAsync();
            logger.LogError("User has no push notification set, deleting this schedule, deleting their schedules");

            throw new ArgumentNullException("Push notification token cannot be null");
        }

        await SendRandomEvent(login.Id, pushNotificationToken);

        var nextTimeToNotify = DateTime.UtcNow.AddHours(schedule.IntervalHours);

        schedule.NextNotificationTimeUtc = nextTimeToNotify;
        await queue.EnqueueAsync(new ScheduledEvent(scheduleId, nextTimeToNotify));

        await dbContext.SaveChangesAsync();
    }

    private async Task SendRandomEvent(int loginId, string pushNotificationToken)
    {
        try
        {
            var reminder = await reminderService.GetRandomReminderToShow(loginId);

            string title = $"A Warm Reminder";

            if (reminder.Category != null)
                title += " - " + reminder.Category;

            await firebaseService.SendNotificationsAsync(pushNotificationToken, title, reminder.ReminderText);
        }
        catch (FirebaseMessagingException ex) when (ex.Message.Contains("Requested entity was not found"))
        {
            logger.LogError($"Login: {loginId}, push notification token is invalid, deleting their schedules");
            await dbContext.Schedules.Where(x => x.LoginId == loginId).ExecuteDeleteAsync();

            throw;
        }
    }
}

