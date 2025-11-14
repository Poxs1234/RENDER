FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copiar csproj y restaurar (asegúrate que el archivo exista en la raíz del contexto)
COPY ["RENEER.csproj", "./"]
RUN dotnet restore "RENEER.csproj"

# Copiar el resto del código y publicar
COPY . .
RUN dotnet publish "RENEER.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Copiar publicación al runtime
COPY --from=build /app/publish ./

ENV ASPNETCORE_URLS=http://+:$PORT
EXPOSE 80

# Ejecutar directamente con dotnet y el nombre correcto del dll
ENTRYPOINT ["dotnet", "RENEER.dll"]
