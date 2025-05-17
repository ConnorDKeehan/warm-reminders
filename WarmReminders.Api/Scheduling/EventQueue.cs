using System.Threading.Channels;
using WarmReminders.Api.Interfaces;

namespace WarmReminders.Api.Scheduling;

public class EventQueue : IEventQueue
{
    private readonly Channel<ScheduledEvent> _queue = Channel.CreateUnbounded<ScheduledEvent>();

    public async Task EnqueueAsync(ScheduledEvent evt)
        => await _queue.Writer.WriteAsync(evt);

    public async Task<ScheduledEvent> DequeueAsync(CancellationToken token)
        => await _queue.Reader.ReadAsync(token);
}

