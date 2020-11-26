FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 8030
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["K8s.Test1.csproj", ""]
RUN dotnet restore "./K8s.Test1.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "K8s.Test1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "K8s.Test1.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "K8s.Test1.dll"]