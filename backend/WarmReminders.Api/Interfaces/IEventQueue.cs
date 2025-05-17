using WarmReminders.Api.Scheduling;

namespace WarmReminders.Api.Interfaces
{
    public interface IEventQueue
    {
        Task<ScheduledEvent> DequeueAsync(CancellationToken token);
        Task EnqueueAsync(ScheduledEvent evt);
    }
}
