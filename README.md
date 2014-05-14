# Getting Started

## Location on the Web

This book is currently published at http://book.xogeny.com.  This
is an **early access** version that gives people a chance to comment
on the book before making an "official" release.  The goal is to
collect sufficient feedback that we can move forward with the
publication of a paper (printed) version of the book without concerns
that the material will still require significant revisions.

## Contributing

If you find an issue with the current version of the book or have a
suggestion for improving it, there are several ways you can contribute
to the book.  They are listed here in order of most likely to be
incorporated first:

  * Send me a [pull
    request](https://help.github.com/articles/using-pull-requests).
    By submitting a pull request to me, you make it very easy for me
    to comment on and/or incorporate your suggested change.  As such,
    I strongly recommend you take this route since it is much more
    time consuming for me to apply your changes myself (and,
    therefore, it makes such changes less likely).
  * Report the issue as an issue in [the issue
    tracker](https://github.com/xogeny/ModelicaBook/issues).  This
    helps me keep track of all the various issues.  This approach
    should be a last resort for changes where the "fix" isn't obvious
    (and therefore you cannot make the change yourself).

If you send me email suggesting something, I will almost certainly
send you back to this section.  It is much harder for me to keep track
of issues via email.  So if you aren't willing to submit a pull
request, please take the second option of submitting an issue to the
issue tracker.

## Translations

I **welcome** translations.  My goal is that translations should be
distributed under the same terms as the English language of the book.
Specifically, this means:

  * An HTML version of the book will be hosted at xogeny.com and
    published under a creative commons license.
  * ePub and PDF versions of the book should be made available for
    purchase using a "pay what you can" pricing model.
  * Publication of a paper version of the book are a possibility, but
    I can't commit to physical publishing without further discussion.

In all cases where there is potential revenue, I would be willing to
enter into a revenue sharing agreement with the translators.

To learn more about what translations are planned, who to contact
about helping with translations or instructions about the translation
workflow, please see [this dedicated document on
translations](https://github.com/xogeny/ModelicaBook/blob/master/TRANSLATION.md).

# Technical Details

## Background

This book is being written using [Sphinx](http://sphinx-doc.org/).  I
chose this system after evaluating several others.  The main things I
liked about Sphinx were:

  * The numerous output formats it supports (HTML, ePub and PDF being
    the important ones).
  * The extensibility of the Sphinx system.
  * The fact that it supports internationalization.
  * The fact that it allows custom templates and CSS to be used.

## Compilation

Sphinx is completely portable so in theory, it should be possible to
run Sphinx under nearly any operating system.

I wrote most of the book under MacOS, but I'm confident it can be
compiled without much effort under Linux as well.  In order to compile
the complete version of the book, you need to have
[OpenModelica](https://openmodelica.org/) and a bunch of other tools.
Unfortunately, I've lost track of exactly what the dependencies are.

For Ubuntu, the requirements are listed in [requirements.txt](requirements.txt)
which you can install by doing:

    $ cat requirements.txt | xargs sudo apt-get install

In addition you will need an updated development version of
[Pygments](http://pygments.org/). The easiest way is to install the updated
version of Pygments from @dietmarw by doing:

    $ sudo pip install --upgrade https://bitbucket.org/dietmarw/pygments-main/get/default.tar.gz

### Building

To build the book in HTML, go to `ModelicaBook/text` and use this command:

    $ make

If that doesn't work for some reason, the following can be used to troubleshoot the problem:

    $ make specs
    $ make results
    $ make dirhtml
    $ make server

Other options for `make` can be found by using `make help`
