# ghūl programming language ASP.NET 8 web API example

This is a very simple ASP.NET 8 web API project written in ghūl. It's a direct translation of the C# weather forecast example into ghūl

## prerequistites

### build
To build the example you need:
- ghūl compiler version 0.8.47 or later
- ghūl Visual Studio Code language extension 0.6.32 or later
- .NET SDK 8

If you want to create a container image containing the example API, then you also need:
- Docker

### run

To run the example you need **one** of the following, depending on your setup:
- .NET 8 Runtime (for production environments)
- .NET 8 SDK (for development environments)
- Docker (to host the API in a container)

## build and run

### build
`<ctrl>+<shift>+B` and choose `build` from the menu

Or run in the terminal:
```sh
dotnet build
```

### run in development mode with Swagger docs enabled
`<ctrl>+<shift>+P`, choose `Tasks: Run Test Task`, then choose `dotnet run`

Or run in the terminal:
```sh
dotnet run
```

The API will start listening for HTTP requests on port 5092. To stop the server type `<ctrl>+C` 

### build container image
`<ctrl>+<shift>+B` and choose `docker build` from the menu

Or run in the terminal
```sh
docker build -t ghul-web-api:latest .
```

### run in release mode in a container
`<ctrl>+<shift>+P`, choose `Tasks: Run Test Task`, then choose `docker run`

Or run in the terminal
```sh
docker run -p 8080:8080 ghul-web-api:latest
```

The API will start listening for HTTP requests on port 8080. To stop the server type `<ctrl>+C`

## service
The service responds to HTTP GET requests for `/weatherforcast` with a JSON payload holding a very simple randomly generated list of weather forecasts.

```sh
$ curl http://localhost:5092/weatherforecast
[{"date":"2024-05-20","temperatureC":14,"temperatureF":57,"summary":"Warm"},{"date":"2024-05-21","temperatureC":7,"temperatureF":44,"summary":"Mild"},{"date":"2024-05-22","temperatureC":7,"temperatureF":44,"summary":"Freezing"},{"date":"2024-05-23","temperatureC":8,"temperatureF":46,"summary":"Sweltering"},{"date":"2024-05-24","temperatureC":-14,"temperatureF":7,"summary":"Chilly"}]
```
## API docs
When running in development mode, Swagger generated API documentation is exposed under `/swagger`
