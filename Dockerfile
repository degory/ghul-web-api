# Use the official Microsoft ASP.NET Core runtime image
# Pull the ASP.NET 8 runtime from Microsoft Container Registry
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 443

# Use SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY .config .config
COPY ["ghul-web-api.ghulproj", "Directory.Build.props", "./"]
RUN dotnet tool restore
RUN dotnet restore "ghul-web-api.ghulproj"
COPY src/ src/
RUN dotnet build -c Release -o /app/build

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

# Final stage/image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ghul-web-api.dll"]
