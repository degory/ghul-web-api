# ghūl programming language ASP.NET 8 web API example

This project is straightforward ASP.NET 8 web API, implemented in the ghūl programming language. It provides CRUD interface for managing dummy product objects with Swagger API documentation.

## prerequisites

### build
To build the example you need:
- [ghūl compiler](https://www.nuget.org/packages/ghul.compiler) version 0.8.47 or later
- [ghūl Visual Studio Code language extension](https://marketplace.visualstudio.com/items?itemName=degory.ghul) 0.6.32 or later
- [.NET SDK 8](https://dotnet.microsoft.com/en-us/download/dotnet/8.0)

If you want to create a container image that will host the example API, then you also need:
- [Docker](https://www.docker.com/get-started)

### run

To run the example you need **one** of the following, depending on your setup:
- [ASP.NET Core Runtime 8](https://dotnet.microsoft.com/en-us/download/dotnet/8.0) (for production environments)
- [.NET 8 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/8.0) (for development environments)
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

## ghūl implementation issues
ghūl lacks a number of language features that the ASP.NET framework takes for granted: 
- **extension methods**: ghūl's lack of extension methods precludes the usual fluent coding style. The workaround is to call the extension methods directly as static methods on their class
- **attributes**: ghūl doesn't support attributes, meaning those parts the ASP.NET framework that rely on attributes are not practically accessible from ghūl code. Attribute support will be added to the compiler in a future release
- **async/await**: ghūl doesn't support async/await. Asynchronous coding is still possible, but it's not pretty.
- **unchecked constraints**: Some generic methods in ASP.NET have type parameter constraints that are not currently enforced by the ghūl compiler. It's important to manually ensure these constraints are met or the resulting code may fail to assemble or may throw at runtime 

