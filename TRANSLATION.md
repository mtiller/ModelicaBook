# Translation

This document attempts to describe the process that translators should
follow.  This will be an evolving discussion and I will gladly accept
pull requests from translators or others who have experience in such
matters in an effort to improve the translation process.

## Coordinators

The following people have taken on the responsibility for translation
into various languages.  If you have are interested in helping with
the translation in one of these languages, please contact the
associated coordinator.  If the language you would like to translate
the book into is not mentioned here, then contact
[me](mailto:michael.tiller+trans@gmail.com) if you are interested in
volunteering to coordinate the translation into that language:

  * **Spanish** - [Susana López](mailto:susana.lopez@tekniker.es)
  * **Chinese** - [Lionel Belmon](mailto:lionel.belmon@globalcrown.com.cn)

## Explanation

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

