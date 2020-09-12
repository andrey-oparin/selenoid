FROM golang:1.15.2 as selenoid-build

ADD ./ /opt/selenoid/src

RUN cd /opt/selenoid/src && go build -ldflags '-linkmode external -w -extldflags "-static"' && ./selenoid --version

FROM alpine:3.8

RUN apk add -U ca-certificates tzdata mailcap && rm -Rf /var/cache/apk/*

COPY --from=selenoid-build /opt/selenoid/src/selenoid /usr/bin

EXPOSE 4444
ENTRYPOINT ["/usr/bin/selenoid", "-listen", ":4444", "-conf", "/etc/selenoid/browsers.json", "-video-output-dir", "/opt/selenoid/video/"]
