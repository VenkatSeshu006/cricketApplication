# Build stage
FROM golang:1.24-alpine AS builder

WORKDIR /app

# Copy everything
COPY . .

# Download all dependencies explicitly
RUN go get github.com/lib/pq \
    github.com/golang-jwt/jwt/v5 \
    golang.org/x/crypto/bcrypt \
    github.com/go-chi/chi/v5 \
    github.com/google/uuid \
    github.com/go-chi/cors && \
    go mod download

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Run stage
FROM alpine:latest

WORKDIR /app

# Install ca-certificates for HTTPS
RUN apk --no-cache add ca-certificates

# Copy binary from builder
COPY --from=builder /app/main .

# Expose port
EXPOSE 8080

# Run the application
CMD ["./main"]
