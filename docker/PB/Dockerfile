# This is a Dockerfile that creates a docker image with all the necessary
# dependencies for building the book.

FROM xogeny/mbe

USER root

# Now install a few more bits needed by Go
RUN apt-get update -y && apt-get install --no-install-recommends -y -q curl build-essential ca-certificates git mercurial bzr

# And then install Go itself
RUN mkdir /goroot && curl https://storage.googleapis.com/golang/go1.3.linux-amd64.tar.gz | tar xvzf - -C /goroot --strip-components=1

# Setup GO environment variables
ENV GOROOT /goroot
ENV GOPATH /opt/MBE/ModelicaBook/docker/gopath
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

USER builder

WORKDIR /opt/MBE

EXPOSE 8080

RUN go install xogeny/pubbook

CMD ["pubbook"]
