FROM golang:1.24-alpine AS builder
WORKDIR /app

COPY backend/go.mod backend/go.sum ./
RUN go mod download

COPY backend/. ./

RUN GO111MODULE=on go install github.com/pressly/goose/v3/cmd/goose@v3.11.0
COPY backend/migrations /migrations

ARG SERVICE_DIR
COPY ${SERVICE_DIR} ${SERVICE_DIR}

ARG BINARY_NAME
WORKDIR /app/${SERVICE_DIR}
RUN CGO_ENABLED=0 GOOS=linux go build -o /${BINARY_NAME}

FROM alpine:latest
WORKDIR /app

ARG BINARY_NAME
ARG PORT

COPY --from=builder /${BINARY_NAME} /app/
COPY --from=builder /go/bin/goose /app/goose
COPY --from=builder /migrations /migrations
COPY devops/entrypoint.sh /app/

RUN chmod +x /app/entrypoint.sh && \
    chmod +x /app/${BINARY_NAME}

ENV PORT=${PORT}
EXPOSE ${PORT}

ENTRYPOINT ["/app/entrypoint.sh"]