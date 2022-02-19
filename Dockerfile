#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["ApiDeProdutos/ApiDeProdutos.csproj", "ApiDeProdutos/"]
RUN dotnet restore "ApiDeProdutos/ApiDeProdutos.csproj"
COPY . .
WORKDIR "/src/ApiDeProdutos"
RUN dotnet build "ApiDeProdutos.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ApiDeProdutos.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
CMD ASPNETCORE_URLS="http://*$PORT" dotnet ApiDeProdutos.dll