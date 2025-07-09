FROM golang:1.24-alpine AS builder
WORKDIR /app

COPY backend/go.mod backend/go.sum ./
RUN go mod download

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
COPY devops/entrypoint.sh /app/

RUN chmod +x /app/entrypoint.sh && \
    chmod +x /app/${BINARY_NAME}

ENV PORT=${PORT}
EXPOSE ${PORT}

ENTRYPOINT ["/app/entrypoint.sh"]