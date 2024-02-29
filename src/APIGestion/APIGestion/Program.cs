using Microsoft.EntityFrameworkCore;
using System.Text.Json.Serialization;
using APIGestion.Models.Datos;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<BaseGestionContext>(o =>
{
    o.UseSqlServer(builder.Configuration.GetConnectionString("cadenaConexion"));
});

builder.Services.AddControllers().AddJsonOptions(o =>
{
    o.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
});

var reglasCors = "ReglasCors";
builder.Services.AddCors(o =>
{
    o.AddPolicy(name: reglasCors, builder =>
    {
        builder.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
app.UseCors(reglasCors);

app.UseAuthorization();

app.MapControllers();

app.Run();
