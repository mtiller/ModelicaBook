# This is a Dockerfile that creates a docker image with all the necessary
# dependencies for building the book.

FROM mtiller/book-py
FROM golang:1.3

ADD . /go/src/xogeny/pubbook
WORKDIR /go/src/xogeny/pubbook

EXPOSE 3000

RUN go get && go install
ENTRYPOINT ["/go/bin/pubbook"]
CMD []
