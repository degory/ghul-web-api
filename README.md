# ghūl programming language ASP.NET 10 web API example

This project is straightforward [ASP.NET](https://dotnet.microsoft.com/en-us/apps/aspnet) 10 [web API](https://dotnet.microsoft.com/en-us/apps/aspnet/apis), implemented in the [ghūl programming language](https://ghul.dev). It implements a CRUD interface for managing dummy product objects with [Swagger API documentation](https://github.com/domaindrivendev/Swashbuckle.AspNetCore).

## prerequisites

### build
To build the example you need:
- [ghūl compiler](https://www.nuget.org/packages/ghul.compiler) version 22.1.4 or later
- [ghūl Visual Studio Code language extension](https://marketplace.visualstudio.com/items?itemName=degory.ghul) 0.6.32 or later
- [.NET SDK 10](https://dotnet.microsoft.com/en-us/download/dotnet/10.0)

If you want to create a container image that will host the example API, then you also need:
- [Docker](https://www.docker.com/get-started)

### run

To run the example you need **one** of the following, depending on your setup:
- [ASP.NET Core Runtime 10](https://dotnet.microsoft.com/en-us/download/dotnet/10.0) (for production environments)
- [.NET 10 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/10.0) (for development environments)
- [Docker](https://www.docker.com/get-started) (to host the API in a container)


## build and run

### build
`<ctrl>+<shift>+B` and choose `build` from the menu

Alternatively, use the following command in the terminal:
```sh
dotnet build
```

### run in development mode with Swagger docs enabled
`<ctrl>+<shift>+P`, choose `Tasks: Run Test Task`, then choose `dotnet run`

Alternatively, use the following command in the terminal:
```sh
dotnet run
```

The API will start listening for HTTP requests on port 5092. To stop the server type `<ctrl>+C` 

### build container image
`<ctrl>+<shift>+B` and choose `docker build` from the menu

Alternatively, use the following command in the terminal:
```sh
docker build -t ghul-web-api:latest .
```

### run in release mode in a container
`<ctrl>+<shift>+P`, choose `Tasks: Run Test Task`, then choose `docker run`

Alternatively, use the following command in the terminal:
```sh
docker run -p 8080:8080 ghul-web-api:latest
```

The API will start listening for HTTP requests on port 8080. To stop the server type `<ctrl>+C`

## API Endpoints
This API provides a set of endpoints to manage a collection of dummy product objects stored in memory. Here are the available CRUD operations:

- **POST /products**
  - **Description**: Creates a new product and adds it to the store.
  - **Request Body**: Expects a JSON object with `name` (string) and `price` (double).
  - **Response**: Returns the ID of the newly created product.

- **GET /products/{id}**
  - **Description**: Retrieves a product by its ID.
  - **Parameters**: `id` (int) – The unique identifier of the product.
  - **Response**: Returns a JSON object with the product details or a 404 error if no product is found.

- **PUT /products/{id}**
  - **Description**: Updates an existing product identified by its ID.
  - **Parameters**: `id` (int) – The unique identifier of the product.
  - **Request Body**: Expects a JSON object with updated `name` and `price`.
  - **Response**: Returns a 200 OK if the update is successful or a 404 error if the product is not found.

- **DELETE /products/{id}**
  - **Description**: Deletes a product by its ID.
  - **Parameters**: `id` (int) – The unique identifier of the product.
  - **Response**: Returns a 200 OK if the product is successfully deleted or a 404 error if the product is not found.

### POST example
#### Request

```sh
curl -X 'POST' \
  'http://localhost:5092/products' \
  -H 'accept: */*' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "book",
  "price": 9.99
}'
```

#### Response
Status code: `201 Created`

Headers:
```http
content-type: application/json; charset=utf-8 
date: Sun,19 May 2024 18:14:54 GMT 
location: /products/1 
server: Kestrel 
transfer-encoding: chunked 
```

Body:
```JSON
{
  "name": "book",
  "price": 9.99
}
```

### GET example
#### Request

```sh
curl -X 'GET' \
  'http://localhost:5092/products/1' \
  -H 'accept: */*'
```

#### Response
Status code: `200 OK`

Headers:
```http
content-type: application/json; charset=utf-8 
date: Sun,19 May 2024 18:20:11 GMT 
server: Kestrel 
transfer-encoding: chunked 
```

Body:
```
{
  "name": "book",
  "price": 9.99
}
```
## API docs
Swagger generated API documentation is available under `/swagger` when running in development mode.

## persistence
Products are stored in a SQLite database via `Microsoft.Data.Sqlite`, with all reads and writes flowing through the `let await` / `await` desugar — the request thread really does suspend on the underlying I/O. By default the database file is `products.db` in the working directory; override with the `GHUL_WEBAPI_DB` environment variable.

## tests
A ghūl-driven HTTP smoke test lives under `tests/smoke-test/`. The orchestrator script `tests/run-smoke.sh` spins up the API against a temporary database, runs the test, and tears everything down:

```sh
tests/run-smoke.sh
```

The same script runs under GitHub Actions on every push and pull request (`.github/workflows/build-and-test.yml`).

## ghūl implementation issues
ghūl lacks a number of language features that the ASP.NET framework takes for granted:
- **extension methods**: ghūl does not surface a type's extension methods as members, so they cannot be called as `receiver.method(...)`. Instead, `use` the extension method and call it with the `|>` thread-first operator, which passes the left-hand side as the method's first argument: `builder.services |> add_swagger_gen(...)` calls `AddSwaggerGen(builder.services, ...)`. Chains read left to right, so `app |> map_post(...) |> with_name(...) |> with_open_api()` mirrors the C# minimal-API fluent style


## issues

[View open issues](https://github.com/degory/ghul/issues?q=is%3Aopen+is%3Aissue+label%3Aghul-web-api) or [raise a new one](https://github.com/degory/ghul/issues/new?labels=ghul-web-api).
