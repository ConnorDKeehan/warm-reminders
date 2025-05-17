namespace WarmReminders.Api.Interfaces
{
    public interface IFirebaseService
    {
        Task SendNotificationsAsync(string token, string title, string body, Dictionary<string, string>? data = null);
    }
}
