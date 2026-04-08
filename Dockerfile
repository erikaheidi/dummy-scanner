FROM golang:1.24-alpine AS builder

WORKDIR /app
COPY go.mod ./
COPY main.go ./
RUN go build -o /dummy-scanner .

FROM alpine:3.21

COPY --from=builder /dummy-scanner /dummy-scanner
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
