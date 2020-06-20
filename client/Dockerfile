# Base is a Debian image with the Go 1.13 installed.
FROM golang:1.13

# Create the container workspace.
WORKDIR /app

# Copy the local files to the container's workspace.
COPY . .

# Build the app.
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o client ./cmd/client/main.go

# Run the client app by default when the container starts.
ENTRYPOINT ["/app/client"]

# Document that the service listens on port 8080.
EXPOSE 8080