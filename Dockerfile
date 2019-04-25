FROM golang:1.11.0-alpine3.8 as builder-confd
ENV COMMIT_HASH_CONFD cccd334562329858feac719ad94b75aa87968a99
ENV GOPATH /go
RUN apk add git
RUN go get -u github.com/kelseyhightower/confd
WORKDIR ${GOPATH}/src/github.com/kelseyhightower/confd
RUN git checkout ${COMMIT_HASH_CONFD}
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-X main.GitSHA=${COMMIT_HASH_CONFD} -w -s -v -extldflags "-static"'

FROM alpine:3.8
RUN mkdir /confd
COPY --from=builder-confd /go/src/github.com/kelseyhightower/confd/confd /bin/confd

ENTRYPOINT [ "/bin/confd" ]
