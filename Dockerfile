FROM golang:1.17.1 as builder

COPY ./app /app/

WORKDIR /app

RUN cd /app && \
    go mod download && \
    go build main.go

FROM alpine:3.13.6 as executor

ENV USER=appuser
ENV GROUP=appgroup
ENV PORT=8000

RUN addgroup -S $GROUP && adduser -S $USER -G $GROUP

#COPY --from=builder  /app/main /var/app

EXPOSE $PORT

ENTRYPOINT ["/var/app"]