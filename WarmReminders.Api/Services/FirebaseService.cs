using AuthService.Interfaces;
using FirebaseAdmin.Messaging;
using WarmReminders.Api.Interfaces;

namespace WarmReminders.Api.Services;

public class FirebaseService : IFirebaseService
{
    public async Task SendNotificationsAsync(string token, string title, string body, Dictionary<string, string>? data = null)
    {
        var message = new Message()
        {
            Token = token,
            Notification = new Notification()
            {
                Title = title,
                Body = body,
                ImageUrl = "https://climblogapi.s3.ap-southeast-2.amazonaws.com/play_store_512.png"
            }
        };

        await FirebaseMessaging.DefaultInstance.SendAsync(message);
    }
}

