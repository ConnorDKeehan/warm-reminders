using WarmReminders.Api.Models.Commands;
using WarmReminders.Api.Models.Entities;

namespace WarmReminders.Api.Interfaces
{
    public interface IReminderService
    {
        Task AddReminder(AddReminderCommand command);
        Task DeleteReminder(int id, int loginId);
        Task<Reminder> GetRandomReminderToShow(int loginId);
        Task<List<Reminder>> GetRemindersByLoginId(int loginId);
        Task PatchReminder(PatchReminderCommand command);
    }
}
