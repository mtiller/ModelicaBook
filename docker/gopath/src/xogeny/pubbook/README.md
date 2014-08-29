# Building

To build the image for this application, you need to run the following command:

```
$ tar zcf - . | docker build -t xogeny/book-hook -
```

This tars (and compresses) the current directory and pipes it to the
docker server where it can be extracted for the build process.  This
is necessary because this build requires additional files beyond just
the instructions contained in the `Dockerfile`.  Those additional
files need to be available for the build (which is not done locally).
