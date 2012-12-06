Getting Started
===============

Background
----------

This book is being written using [Sphinx](http://sphinx-doc.org/).  I
chose this system after evaluating several others.  The main things I
liked about Sphinx were:

  * The numerous output formats it supports (HTML, ePub and PDF being
    the important ones.
  * The extensibility of the Sphinx system.
  * The fact that it supports internationalization.
  * The fact that it allows custom templates and CSS to be used.

Compilation
-----------

Sphinx is completely portable so in theory, it should be possible to
compile the book (especially the HTML version) under nearly any
operating system.  However, I only have experience compiling it under
Ubuntu.  So I will include instructions only for Ubuntu.

In order to install the complete set of tools required to compile the
book, just execute the following command in Ubuntu:

     % sudo apt-get install texlive-fonts-recommended texlive-latex-recommended texlive-latex-extra python-sphinx

Translations
------------

At this point, I'm not entirely sure how the translation workflow
should go.  The Sphinx documentation specifically discusses [document
translation](http://sphinx-doc.org/intl.html#intl).  I can confirm that

     % sphinx-build -b gettext

does generate a series of .pot files with each paragraph present.  I
haven't played around with what to do yet (other than adding a target
in the Makefile).

Ideally, what we need is a workflow that allows translators to see
what has changed in .pot files.  When the document source is changed,
I can regenerate the .pot files.  Translators generally won't care
what has disappeared from the .pot files (except for the wasted work
associated with any previous translations).  But they should be made
aware of any **new** entries in the .pot file.  I'm not sure how to do
that.  I have noted that there seem to be two existing tools out there
that are commonly used:
[Pootle](http://sourceforge.net/projects/translate/) and
[Weblate](http://weblate.org).  But I honestly don't know enough (yet)
about those tools work to understand how to create an easy workflow
for translators.  However, I do note that one feature that Weblate
makes a big deal about is its Git integration.
