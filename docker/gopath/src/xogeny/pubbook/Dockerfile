# This is a Dockerfile that creates a docker image with all the necessary
# dependencies for building the book.

FROM mtiller/book-go

# The rest of this we do as a user
RUN useradd builder

ADD . /opt/MBE/src/pubbook

RUN chown -R builder /opt/MBE

USER builder

# Create a directory for all the book related stuff
RUN mkdir /opt/MBE/bin
RUN mkdir /opt/MBE/pkg


ENV GOPATH /opt/MBE
ENV PATH $PATH:$GOPATH/bin

WORKDIR /opt/MBE/src/pubbook

RUN go get
RUN go install
RUN cp /opt/MBE/src/pubbook/s3cfg /opt/MBE

WORKDIR /opt/MBE

EXPOSE 3000

ENTRYPOINT ["./bin/pubbook"]
CMD []
