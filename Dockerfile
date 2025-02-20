# Building the binary of the App
FROM golang:1.19 AS build

WORKDIR /go/src/tasky
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/src/tasky/tasky

# Create a .env file in the container
WORKDIR /go/src/tasky
COPY .env /app/tasky/.env

ENV MONGO_DB_NAME=admin
ENV SECRET_KEY=secret123
ENV MONGODB_URI=mongodb://myUserAdmin:tasky123@44.211.89.250:27017/admin

# Expose the MongoDB port
EXPOSE 27017

FROM alpine:3.17.0 as release

WORKDIR /app
COPY --from=build  /go/src/tasky/tasky .
COPY --from=build  /go/src/tasky/assets ./assets
EXPOSE 8080
ENTRYPOINT ["/app/tasky"]


