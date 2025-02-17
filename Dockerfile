FROM golang:bullseye as builder
RUN mkdir /build
COPY . /build
WORKDIR /build
RUN CGO_ENABLED=0 go build -a -o trufflehog main.go
RUN mkdir /empty

FROM alpine
RUN apk add git
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /build/trufflehog /usr/bin/trufflehog
ENTRYPOINT ["/usr/bin/trufflehog"]