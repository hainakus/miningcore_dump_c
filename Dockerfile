FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy as BUILDER
WORKDIR /app
RUN apt-get update && \
    apt-get -y install cmake libgmp3-dev  build-essential libssl-dev pkg-config libboost-all-dev libsodium-dev libzmq5 libzmq3-dev golang-go
COPY . .
WORKDIR /app/src/Miningcore
RUN dotnet publish -c Release --framework net6.0 -o ../../build

FROM mcr.microsoft.com/dotnet/aspnet:6.0-jammy
WORKDIR /app
RUN apt-get update && \
    apt-get install -y libzmq5 libzmq3-dev libsodium-dev curl && \
    apt-get clean
EXPOSE  4000-4090
COPY --from=BUILDER /app/build ./
COPY config.json .
CMD ["./Miningcore", "-c", "config.json" ]
