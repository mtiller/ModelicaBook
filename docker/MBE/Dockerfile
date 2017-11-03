# This is a Dockerfile that creates a docker image with all the necessary
# dependencies for building the book.

FROM mtiller/book-py

# Create a directory for all the book related stuff
RUN mkdir /opt/MBE

# The rest of this we do as a user
RUN useradd builder

COPY default_s3cfg /home/builder/.s3cfg
RUN chown builder:builder /home/builder/.s3cfg

RUN chown builder /opt/MBE

USER builder

WORKDIR /opt/MBE

#RUN git clone https://github.com/xogeny/ModelicaBook.git
# Instead of checking this out from Git (because then we can
# only build *master*, we'll mount the repo as a volume)

# The default commands when run as a container
WORKDIR /opt/MBE/ModelicaBook/text
CMD ["/bin/bash", "build_all.sh"]
