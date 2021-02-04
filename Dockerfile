FROM golang:alpine as builder

LABEL maintainer="ohermosa@gmail.com"

WORKDIR /go/src/github.com/ohermosa/squid-exporter
COPY . .

RUN apk add --no-cache vim jq bash sh

# Compile the binary statically, so it can be run without libraries.
RUN CGO_ENABLED=0 GOOS=linux go install -a -ldflags '-extldflags "-s -w -static"' .

FROM scratch
COPY --from=builder /go/bin/squid-exporter /usr/local/bin/squid-exporter

# Allow /etc/hosts to be used for DNS
COPY --from=builder /etc/nsswitch.conf /etc/nsswitch.conf

EXPOSE 9301

ENTRYPOINT ["/usr/local/bin/squid-exporter"]
