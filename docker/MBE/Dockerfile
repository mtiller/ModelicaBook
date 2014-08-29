# This is a Dockerfile that creates a docker image with all the necessary
# dependencies for building the book.

FROM mtiller/book-py

# Create a directory for all the book related stuff
RUN mkdir /opt/MBE

# The rest of this we do as a user
RUN useradd builder

RUN chown builder /opt/MBE

USER builder

WORKDIR /opt/MBE

RUN git  clone https://github.com/xogeny/ModelicaBook.git
