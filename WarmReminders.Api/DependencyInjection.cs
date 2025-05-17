using AuthService;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using WarmReminders.Api.Contexts;
using WarmReminders.Api.Interfaces;
using WarmReminders.Api.Scheduling;
using WarmReminders.Api.Services;
using Microsoft.EntityFrameworkCore;
using Azure.Identity;
using Azure.Storage.Blobs;
using Microsoft.IdentityModel.Tokens;

namespace WarmReminders.Api;

public static class DependencyInjection
{
    public static void AddWarmRemindersServices(this IServiceCollection services, IConfiguration configuration)
    {
         services.AddAuthService(configuration);
         
         var connectionString = configuration.GetConnectionString("WarmReminders");
         services.AddDbContext<WarmRemindersContext>(options =>
                     options.UseSqlServer(connectionString));

        var firebaseJsonUrl = configuration["FirebaseJsonUrl"];

        var firebaseJson = GetFireBaseJsonFromBlob(configuration["FirebaseJsonUrl"]);

        FirebaseApp.Create(new AppOptions
        {
            Credential = GoogleCredential.FromJson(firebaseJson)
        });
         
         //Register shiz
         services.AddScoped<IReminderService, ReminderService>();
         services.AddScoped<IScheduleService, ScheduleService>();
         services.AddSingleton<IEventQueue, EventQueue>();
         services.AddScoped<IFirebaseService, FirebaseService>();
         services.AddHostedService<ScheduledEventProcessor>();
    }

    private static string GetFireBaseJsonFromBlob(string? blobUrl)
    {
        if (blobUrl.IsNullOrEmpty())
        {
            throw new ArgumentNullException(nameof(blobUrl));
        }

        var credential = new DefaultAzureCredential();
        var blobUri = new Uri(blobUrl!);
        var blobClient = new BlobClient(blobUri, credential);

        using var stream = new MemoryStream();
        blobClient.DownloadTo(stream);
        stream.Position = 0;

        using var reader = new StreamReader(stream);
        var firebaseJson = reader.ReadToEnd();

        return firebaseJson;
    }
}
