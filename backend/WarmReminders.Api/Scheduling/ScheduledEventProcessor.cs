using WarmReminders.Api.Interfaces;
using WarmReminders.Api.Services;

namespace WarmReminders.Api.Scheduling;

public class ScheduledEventProcessor(IEventQueue queue, ILogger<ScheduledEventProcessor> logger, IServiceScopeFactory scopeFactory) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken cancellationToken)
    {
        // Rehydrate once at startup using short-lived scope
        using (var initScope = scopeFactory.CreateScope())
        {
            var scheduleService = initScope.ServiceProvider.GetRequiredService<IScheduleService>();
            await scheduleService.RescheduleNotifications();
        }

        while (!cancellationToken.IsCancellationRequested)
        {
            var evt = await queue.DequeueAsync(cancellationToken);

            try
            {
                var delay = evt.ExecuteAt - DateTime.UtcNow;

                if (delay > TimeSpan.Zero)
                {
                    await Task.Delay(delay, cancellationToken);
                }

                using (var scope = scopeFactory.CreateScope())
                {
                    var scheduleService = scope.ServiceProvider.GetRequiredService<IScheduleService>();
                    await scheduleService.HandleScheduledNotification(evt.Id);
                }
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Failed to process event {@Event}", evt);
            }
        }
    }
}

