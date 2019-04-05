# NGINX Virtual Hosting + Let's Encrypt

It turns out you can do this without the need to create an `nginx.conf` file.
The proxy container inspects the running containers and extracts the necessary
information about each running container in order to construct the virtual
hosting information.

## Proxy Setup

First, I ran these two commands from
the [instructions for the nginx-proxy-companion
image](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion):

```
$ docker run --detach \
    --name nginx-proxy \
    --publish 80:80 \
    --publish 443:443 \
    --volume /etc/nginx/certs \
    --volume /etc/nginx/vhost.d \
    --volume /usr/share/nginx/html \
    --volume /var/run/docker.sock:/tmp/docker.sock:ro \
    jwilder/nginx-proxy
$ docker run --detach \
    --name nginx-proxy-letsencrypt \
    --volumes-from nginx-proxy \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    jrcs/letsencrypt-nginx-proxy-companion
```

Those are just vanilla containers.

## Virtual Hosted Containers

To run the API behind a TLS enabled virtual hosting proxy, we run the `api` as follows:

```
$ docker run --detach \
    --name book-server \
    --env "BASE_URL=/" \
    --env "VIRTUAL_HOST=mbe-api.modelica.university" \
    --env "VIRTUAL_PORT=3000" \
    --env "LETSENCRYPT_HOST=mbe-api.modelica.university" \
    --env "LETSENCRYPT_EMAIL=michael.tiller@gmail.com" \
    mtiller/book-server
```

Note that the value of `BASE_URL` is defined so that no host information is
provided and that all URLs are relative. I tried using
`https://mbe-api.modelica.university/` as a value, but that led to some very
strange Express complaints about not being able to find things. I set the
`trust proxy` value in the app and I even tried to use Express's builtin
resolution of forwarded headers. None of those worked which how I ended up with
`BASE_URL=/`. So someday it would be nice to fix that. But fortunately, the
`siren-nav` package handles relative URLs so it should be fine to leave as is.
