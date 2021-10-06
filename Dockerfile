FROM golang:1.17.1 as builder

COPY app /app/

WORKDIR /app

RUN cd /app && \
    go mod download && \
    GOOS=linux CGO_ENABLED=0 go build -o main .

FROM alpine:3.13.6 as executor

ENV USER=appuser
ENV GROUP=appgroup
ENV PORT=8000

RUN addgroup -S $GROUP && adduser -S $USER -G $GROUP

COPY --from=builder --chown=$USER /app/main /app/main
COPY --chown=$USER app/static /app/static

WORKDIR /app

EXPOSE $PORT:$PORT

ENTRYPOINT ["/app/main"]