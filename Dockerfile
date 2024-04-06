FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
EXPOSE 8080

# copy .csproj and restore as distinct layers
COPY *.sln .
COPY "API/API.csproj" "API/API.csproj"
COPY "Application/Application.csproj" "Application/Application.csproj"
COPY "Persistence/Persistence.csproj" "Persistence/Persistence.csproj"
COPY "Domain/Domain.csproj" "Domain/Domain.csproj"

RUN dotnet restore

# copy everything else and build
COPY . .
WORKDIR /app
RUN dotnet publish -c Release -o out

# build a runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT [ "dotnet", "API.dll" ]
