FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copiar csproj y restaurar (ajusta el nombre si tu csproj tiene otro nombre)
COPY ["RENEER.csproj", "./"]
RUN dotnet restore "RENEER.csproj"

# Copiar el resto del código y publicar
COPY . .
RUN dotnet publish "RENEER.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Copiar publicación y entrypoint
COPY --from=build /app/publish ./
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENV ASPNETCORE_URLS=http://+:$PORT
EXPOSE 80

ENTRYPOINT ["/app/entrypoint.sh"]
