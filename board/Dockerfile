# Base is a Debian image with the Go 1.13 installed.
FROM golang:1.13

# Create the container workspace.
WORKDIR /app

# Copy the local files to the container's workspace.
COPY . .

# Build the app.
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o board ./cmd/board/main.go

# Run the board command by default when the container starts.
ENTRYPOINT ["/app/board"]

# Document that the service listens on port 8080.
EXPOSE 8080