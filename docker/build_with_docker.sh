#!/bin/sh
image_name="mtiller/book-mbe"
echo $image_name

if [ -z "${S3BUCKET}" ]; then 
    S3BUCKET='book.xogeny.com'
fi

# TODO: In a CI system, we'll need to do this...
# sudo docker pull mtiller/book-py

# TODO: I don't think building fresh is the way to go.  Better to pull
# the built image so we know exactly what image will be used.
#sudo docker build --no-cache -t $image_name MBE

docker run -v ..:/opt/MBE/ModelicaBook -t $image_name
#sudo docker run -t -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
#    -e "AWS_SECRET_KEY=$AWS_SECRET_KEY" \
#    -e "S3BUCKET=$S3BUCKET" $image_name
