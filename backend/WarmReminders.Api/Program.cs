using Azure.Extensions.AspNetCore.Configuration.Secrets;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Microsoft.OpenApi.Models;
using WarmReminders.Api;

var builder = WebApplication.CreateBuilder(args);

// Configure CORS to allow all origins
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder =>
    {
        builder.AllowAnyOrigin() // Allow all origins
            .AllowAnyMethod() // Allow all HTTP methods (GET, POST, etc.)
            .AllowAnyHeader(); // Allow all headers
    });
});

var secretClient = new SecretClient(new Uri("https://warm-reminders-secrets.vault.azure.net/"), new DefaultAzureCredential());
builder.Configuration.AddAzureKeyVault(secretClient, new KeyVaultSecretManager());

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "My API", Version = "v1" });

    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "JWT Authorization, ONLY PUT THE TOKEN IN, NO \"Bearer\" to start it. Stupid boilerplate, it's implied."
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

builder.Services.AddWarmRemindersServices(builder.Configuration);

var app = builder.Build();


app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
