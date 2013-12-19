# Getting Started

## Background

This book is being written using [Sphinx](http://sphinx-doc.org/).  I
chose this system after evaluating several others.  The main things I
liked about Sphinx were:

  * The numerous output formats it supports (HTML, ePub and PDF being
    the important ones.
  * The extensibility of the Sphinx system.
  * The fact that it supports internationalization.
  * The fact that it allows custom templates and CSS to be used.

## Compilation

Sphinx is completely portable so in theory, it should be possible to
compile the book (especially the HTML version) under nearly any
operating system.  However, I only have experience compiling it under
Ubuntu.  So I will include instructions only for Ubuntu.

In order to install the complete set of tools required to compile the
book, just execute the following command in Ubuntu:

     % sudo apt-get install texlive-fonts-recommended texlive-latex-recommended texlive-latex-extra python-sphinx python-scipy python-matplotlib
     
You'll also need a copy of [OpenModelica](https://www.openmodelica.org/)
installed.  I'm using [the Linux version](https://www.openmodelica.org/index.php/download/download-linux)
and I built the Mac version from source.

## Proofreading

Here are some guidelines on proofreading.

### Forking

First, **please** fork the repository and make any changes in your own
repository and then send me a pull request for any changes ([see here for
more details](https://help.github.com/articles/fork-a-repo)).  I would
then suggest that you use the following `git` command to track changes
to the main repository:

    $ git remote add upstream https://github.com/xogeny/ModelicaBook.git
    
With this remote branch, you can then `fetch` my latest changes (load them
your local disk but not change any actual code) with:

    $ git fetch upstream
    
And when you are ready to merge them into your local version, just do:

    $ git rebase upstream/master

### Typos

If you find typos, the simplest thing is to fix them in your copy and
send me a "pull request".  This will mean creating a branch in your
repository with your changes, pushing that branch to GitHub and the
submitting a pull request through GitHub asking me to merge that
branch with mine.  It's simpler than it sounds, just give it a try
and if you get stuck ask.

The point is that it is much more efficient to fix a typo directly and
send me a pull request then to try and explain to me what the typo
is, where I can find it and what I should change it to and then I have
to locate it and change it.  Much simpler is if you simply change it
and send me the pull request and I can quickly scan the diffs and make
sure I agree with all the changes.

### Suggestions

If you have a suggestion and you are willing to modify the text
with alternative text, feel free.  The worst that will happen is
that I will not accept it or change it.

If you don't want to formulate the alternative but still want to
suggest something, you can add a "TODO" item in the text.  It should
look like this:

    .. todo:: 
    
        This is awkward and needs to be completely
        rewritten (or whatever your comment is).
        
I can easily find these in the text and deal with them.  Furthermore,
I can generate a list of these things and quickly process them.

### Comments and Questions

If you have a comment or question (in general, not about a specific
section of text), submit it as an issue in the issue tracker.

## Translations

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
