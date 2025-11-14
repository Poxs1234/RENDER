FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copia todo el repositorio (si prefieres optimizar, copia csproj primero y luego el resto)
COPY . .

# Restaura y publica
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Copia la publicación y el entrypoint
COPY --from=build /app/publish ./
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Render asigna PORT automáticamente; exponemos 80 por convención
ENV ASPNETCORE_URLS=http://+:$PORT
EXPOSE 80

ENTRYPOINT ["/app/entrypoint.sh"]
