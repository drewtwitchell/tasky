# syntax=docker/dockerfile:1

# Stage 1: Build the Go application
FROM golang:1.19 AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o tasky .

# Stage 2: Create a minimal image with the compiled binary
FROM alpine:latest

# Set the Current Working Directory inside the container
WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /app/tasky .

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["./tasky"]



