# Getting Started

## Location on the Web

This book is currently published at http://mbe.modelica.university. This is an
**early access** version that gives people a chance to comment on the book
before making an "official" release. The goal is to collect sufficient feedback
that we can move forward with the publication of a paper (printed) version of
the book without concerns that the material will still require significant
revisions.

## Contributing

If you find an issue with the current version of the book or have a suggestion
for improving it, there are several ways you can contribute to the book. They
are listed here in order of most likely to be incorporated first:

- Send me a [pull
  request](https://help.github.com/articles/using-pull-requests). By submitting
  a pull request to me, you make it very easy for me to comment on and/or
  incorporate your suggested change. As such, I strongly recommend you take this
  route since it is much more time consuming for me to apply your changes myself
  (and, therefore, it makes such changes less likely).
- Report the issue as an issue in [the issue
  tracker](https://github.com/mtiller/ModelicaBook/issues). This helps me keep
  track of all the various issues. This approach should be a last resort for
  changes where the "fix" isn't obvious (and therefore you cannot make the
  change yourself).

If you send me email suggesting something, I will almost certainly send you back
to this section. It is much harder for me to keep track of issues via email. So
if you aren't willing to submit a pull request, please take the second option of
submitting an issue to the issue tracker.

## Translations

I **welcome** translations. My goal is that translations should be distributed
under the same terms as the English language of the book. Specifically, this
means:

- An HTML version of the book will be hosted at modelica.university and
  published under a creative commons license.
- ePub and PDF versions of the book should be made available for purchase using
  a "pay what you can" pricing model.
- Publication of a paper version of the book are a possibility, but I can't
  commit to physical publishing without further discussion.

In all cases where there is potential revenue, I would be willing to enter into
a revenue sharing agreement with the translators.

To learn more about what translations are planned, who to contact about helping
with translations or instructions about the translation workflow, please see
[this dedicated document on
translations](https://github.com/mtiller/ModelicaBook/blob/master/TRANSLATION.md).

# Technical Details

## Background

This book is being written using [Sphinx](http://sphinx-doc.org/). I chose this
system after evaluating several others. The main things I liked about Sphinx
were:

- The numerous output formats it supports (HTML, ePub and PDF being the
  important ones).
- The extensibility of the Sphinx system.
- The fact that it supports internationalization.
- The fact that it allows custom templates and CSS to be used.

## Compilation

Sphinx is completely portable so in theory, it should be possible to run Sphinx
under nearly any operating system.

Although previous versions required a bunch of tools to build the book, the
current version only requires that you have Node and Docker installed. I highly
recommend the [Docker for Mac](https://www.docker.com/docker-mac) and [Docker
for Windows](https://www.docker.com/docker-windows) flavors if you are on macOS
or Windows, respectively.

Recently, I had some success using the `Remote - Containers` extension in Visual
Studio Code along with the `mtiller/flat-book-builder` image mentioned below. If
you open this folder in Visual Studio Code and you have the `Remote - Containers` extension installed, you should get an option to re-open VS Code in
the container. Doing so, you should be setup to build. As such, I've bundled the
`.devcontainer` directory that include the configuration necessary to do the
builds in containers. This could also be useful when building on Windows (if you
have VS Code and the `Remote - Containers` extension installed).

In order to build this, the first thing you need to do is ensure all submodules
have been checked out, _i.e.,_

```sh
$ git submodule init
$ git submodule update
```

There is now a root level Makefile. You should be able to simply run:

```
make all
```

...which should build the book (if I'm forgetting something, send me a pull
request for this `README` adding any further instructions). The source will be
generated in `./text/build/dirhtml`.

### M1 Macs

I've seen two odd things while building on M1 Macs. The first was related
to `clang` not being able to determine the proper CPU target. I fixed that
by forcing some specific `CFLAGS` values (although I also realized that
I could fix it simply by setting the `ARCH` variable to `x86-64` during
the build process) when running on an M1.

The other issue is trickier. As I've reported
[here](https://github.com/NixOS/nix/issues/4485#issuecomment-803317881), you can
occasionally get an out of memory error while building. This appears to be a bug
in the current M1 support in Docker Desktop. It is an intermittent bug so the
only solution I've found is to simply restart the build whenever it comes up. It
seems to be localized to the OpenModelica compiler `omc` because it only
triggers while running that. This is frustrating because it can take many, many
attempts to build all the necessary results files.

### Flat Image

The original `mtiller/book-builder` Docker image had multiple layers and
this led to lots of warnings like this during builds:

```sh
Unexpected end of /proc/mounts line `cker/overlay2/l/TH5GPGEDJZF3YVOCTK2ZVB6S7X:/var/lib/docker/overlay2/l/JP6Q3UKNSJBYBAGJCE4R2BAOIS:/var/lib/docker/overlay2/l/IPRRIXJ6IQ3FUHM67CYISMADBD:/var/lib/docker/overlay2/l/U24HKOEVMHAXULWB3YYLUHRLJK:/var/lib/docker/overlay2/l/H4OLNB6XZPU7OHA2XDXMCXNUY4:/var/lib/docker/overlay2/l/EF4M5E33IEXKDQ6OMU2D3QRH7A:/var/lib/docker/overlay2/l/5OIOMB6J7SBUOYA3SZZY7J2WYK:/var/lib/docker/overlay2/l/ZK5AEX73ZAABW7ZY2Y6YWWFYWW:/var/lib/docker/overlay2/l/NTTTRZPNBKPKTMQ7YAKMGG5ILF:/var/lib/docker/overlay2/l/MUVGOVJFK'
```

So I created a new image called `mtiller/flat-book-builder` to avoid those
messages. Both images still exist in case there are any issues with the "flat"
version.
