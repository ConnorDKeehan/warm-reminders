using WarmReminders.Api.Models.Commands;
using WarmReminders.Api.Models.Entities;
using WarmReminders.Api.Models.Requests;

namespace WarmReminders.Api.Interfaces
{
    public interface IScheduleService
    {
        Task AddSchedule(AddScheduleCommand command);
        Task DeleteSchedule(int id, int loginId);
        Task<List<Schedule>> GetSchedules(int loginId);
        Task HandleScheduledNotification(int scheduleId);
        Task PatchSchedule(PatchScheduleCommand command);
        Task RescheduleNotifications();
    }
}
