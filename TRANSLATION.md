# Translation

This document attempts to describe the process that translators should
follow.  This will be an evolving discussion and I will gladly accept
pull requests from translators or others who have experience in such
matters in an effort to improve the translation process.

## Current Status

At this point, it should be "safe" to translate any text up to and
including **Chapter 2 (Vectors and Arrays)** without fear of the
underlying text changing.

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
  * **Italian** - [Marco Romanoni](mailto:marco.romanoni@dofware.com)

## Explanation

I've tried to make the translation process as simple as possible for
translators by trying to do as much of the "up front" work on my end.

When you check out the Git repository, you'll find a directory called
`text/locale`.  In there, you'll find directories that
correspond to all the different languages for which translations are
being done (*e.g.,* `es`=Spanish, `cn`=Chinese).  Simply go into the
directory corresponding to the language you interested in translating
and then into the `LC_MESSAGES` directory inside there and look for
the `.po` files contained in those directories.  These files contain
the text to be translated.

The file contains lots of entries corresponding to different passages
of text.  A typical passage might look like this:

```
#: ../../source/front/dedication.rst:11
msgid ""
"This book started as a Kickstarter project.  The idea of writing a book and "
"making it freely available, under a Creative Commons license, was largely "
"inspired by the writings of Cory Doctorow and Lawrence Lessig.  Their "
"message of sharing resonated very strongly with me. I'm not interested in "
"capitalizing on my knowledge of Modelica, I want to share it with others so "
"they can experience the same joy I do in exploring this subject.  Happily, "
"this Kickstarter project was successfully funded on December 4th, 2012 and "
"my odyssey to create an entire Creative Commons licensed book began.  If "
"circumstances had been different, this book would probably be dedicated to "
"Cory Doctorow and Lawrence Lessig for inspiring me to take on this project."
msgstr ""

#: ../../source/front/dedication.rst:23
```

To translate this text, what is required is to add text below the
**`msgstr`** line that is a translated version of the English language
text above.  For example, the code above might be translated (*e.g.,*
into French) as:

```
#: ../../source/front/dedication.rst:11
msgid ""
"This book started as a Kickstarter project.  The idea of writing a book and "
"making it freely available, under a Creative Commons license, was largely "
"inspired by the writings of Cory Doctorow and Lawrence Lessig.  Their "
"message of sharing resonated very strongly with me. I'm not interested in "
"capitalizing on my knowledge of Modelica, I want to share it with others so "
"they can experience the same joy I do in exploring this subject.  Happily, "
"this Kickstarter project was successfully funded on December 4th, 2012 and "
"my odyssey to create an entire Creative Commons licensed book began.  If "
"circumstances had been different, this book would probably be dedicated to "
"Cory Doctorow and Lawrence Lessig for inspiring me to take on this project."
msgstr ""
"Ce livre a commencé comme un projet Kickstarter. L'idée d'écrire un livre et " 
"rendant disponible gratuitement, sous une licence Creative Commons, était en grande partie " 
"inspiré par les écrits de Cory Doctorow et Lawrence Lessig. Leur " 
"un message de partage résonné très fort avec moi. Je ne suis pas intéressé par " 
"capitaliser sur ma connaissance de Modelica, je veux le partager avec d'autres pour " 
"ils peuvent éprouver la même joie que je fais dans l'exploration de ce sujet. Heureusement, " 
"ce projet Kickstarter a été financé avec succès le 4 Décembre 2012 et " 
"mon odyssée à créer un ensemble de Creative Commons livre licence a commencé. Si " 
"circonstances avaient été différentes, ce livre serait probablement dédié à " 
"Cory Doctorow et Lawrence Lessig de m'inspirer de prendre sur ce projet."
```

Note the addition of the lines following the line with the `msgstr` directive on it.

## Retranslation

In some cases, I may fix a typo or adjust the text after something has
been translated.  So I want to take a moment to explain what happens
in that case.  If a section of the original text has changed, the
translation will be commented out using both a `#` character **and** a
`~`, as follows:

```
#: ../../source/front/dedication.rst:11
#~ msgid ""
#~ "This book started as a Kickstarter project.  The idea of writing a book and "
#~ "making it freely available, under a Creative Commons license, was largely "
#~ "inspired by the writings of Cory Doctorow and Lawrence Lessig.  Their "
#~ "message of sharing resonated very strongly with me. I'm not interested in "
#~ "capitalizing on my knowledge of Modelica, I want to share it with others so "
#~ "they can experience the same joy I do in exploring this subject.  Happily, "
#~ "this Kickstarter project was successfully funded on December 4th, 2012 and "
#~ "my odyssey to create an entire Creative Commons licensed book began.  If "
#~ "circumstances had been different, this book would probably be dedicated to "
#~ "Cory Doctorow and Lawrence Lessig for inspiring me to take on this project."
#~ msgstr ""
#~ "Ce livre a commencé comme un projet Kickstarter. L'idée d'écrire un livre et " 
#~ "rendant disponible gratuitement, sous une licence Creative Commons, était en grande partie " 
#~ "inspiré par les écrits de Cory Doctorow et Lawrence Lessig. Leur " 
#~ "un message de partage résonné très fort avec moi. Je ne suis pas intéressé par " 
#~ "capitaliser sur ma connaissance de Modelica, je veux le partager avec d'autres pour " 
#~ "ils peuvent éprouver la même joie que je fais dans l'exploration de ce sujet. Heureusement, " 
#~ "ce projet Kickstarter a été financé avec succès le 4 Décembre 2012 et " 
#~ "mon odyssée à créer un ensemble de Creative Commons livre licence a commencé. Si " 
#~ "circonstances avaient été différentes, ce livre serait probablement dédié à " 
#~ "Cory Doctorow et Lawrence Lessig de m'inspirer de prendre sur ce projet."
```

You will generally also find an untranslated version of the *new* original text, e.g.:

```
#: ../../source/front/dedication.rst:11
msgid ""
"This book started as a simple Kickstarter project.  The idea of writing a book and "
"making it freely available, under a Creative Commons license, was largely "
"inspired by the writings of Cory Doctorow and Lawrence Lessig.  Their "
"message of sharing resonated very strongly with me. I'm not interested in "
"capitalizing on my knowledge of Modelica, I want to share it with others so "
"they can experience the same joy I do in exploring this subject.  Happily, "
"this Kickstarter project was successfully funded on December 4th, 2012 and "
"my odyssey to create an entire Creative Commons licensed book began.  If "
"circumstances had been different, this book would probably be dedicated to "
"Cory Doctorow and Lawrence Lessig for inspiring me to take on this project."
msgstr ""
```

*(note the addition of the word "simple" in the first line)*

The key point is that any previous translation is provided as a
reference (just commented out with `#~` characters).  Ideally
(assuming changes are small), it should be possible to reuse much of
the translated text.  Unfortunately, I don't know if any easy way to
identify what change has occurred except by looking at both versions
of the original text and trying to identify the difference.  But
hopefully we can avoid retranslations as much as possible.

## Git Workflow

If you would like to contriute to the translation effort but are not
familiar with Git, this section will give a simple walk-through of
using Git to translate the dedication.

### Git

It is worth pointing out up front that Git is not quite like other
version control systems you might be used to (*e.g.,* Subversion).
This is because Git is a distributed version control system.  What
this means is that you will have your own copy of the complete
repository for the book.  In this section, we'll discuss how you
should make your changes and what will be required to merge them into
the book.

### Getting a GitHub account

If you don't already have a GitHUb account, the first thing you will
need to do is visit the [Sign Up Page](https://github.com/join) and
register.  Registering for GitHub is free.

### Forking the repository

Once you have a GitHub account, you should visit the main Modelica
book page at http://github.com/xogeny/ModelicaBook.  On this page,
you'll see a "Fork" button in the upper right corner of the page.
You'll want to press this button.  When you do, GitHub will create a
complete copy of the Xogeny repository **under your own account**.  If
you have any problems, you should consult the [GitHub documentation on
forking a repository](https://help.github.com/articles/fork-a-repo)
for more details.

When this is done, you will have your own copy of the Xogeny
repository.  The page for your repository on GitHub will have an
address like http://github.com/<username>/ModelicaBook.  If you look
carefully at the top of the page, you'll see that it says "forked from
xogeny/ModelicaBook".

### Adding Translations

There are two ways to do translations.  The first is "through the
web".  With this method you can simply edit the files you need to
change directly from the GitHub web site.  This might seem like the
easiest approach, but it has some significant downsides as well that
you will eventually run into.  The other approach is to install a
version of Git on your local machine and work with the files
there. We'll discuss each approach.  But in either case, the overall
process is the same (see the
[Explanation](https://github.com/xogeny/ModelicaBook/blob/master/TRANSLATION.md#explanation)
section above).

### Web-Based Editing

To edit a file through the GitHub web site, simply go to your
repository page (remember: http://github.com/<username>/ModelicaBook)
and click on the directories: `text`, `locale`, the language you are
translating to (*e.g.*, `de`, `it`, *etc*), and finally
`LC_MESSAGES`.  The `text/locale/<language>/LC_MESSAGES` directory is
where all the translations are stored.  To demonstrate web-based
editing, let's translate the dedication.  From the `LC_MESSAGES`
folder, go to the `front` directory and select the `dedication.po`
file.  You'll see a "read-only" version of the file.  But if you click
the "Edit" button on the right side of the bar just above line 1,
GitHub will create an edit window.

Initially, you'll see text like this:

```
#: ../../source/front/dedication.rst:11
msgid ""
"This book started as a Kickstarter project.  The idea of writing a book and "
"making it freely available, under a Creative Commons license, was largely "
"inspired by the writings of Cory Doctorow and Lawrence Lessig.  Their "
"message of sharing resonated very strongly with me. I'm not interested in "
"capitalizing on my knowledge of Modelica, I want to share it with others so "
"they can experience the same joy I do in exploring this subject.  Happily, "
"this Kickstarter project was successfully funded on December 4th, 2012 and "
"my odyssey to create an entire Creative Commons licensed book began.  If "
"circumstances had been different, this book would probably be dedicated to "
"Cory Doctorow and Lawrence Lessig for inspiring me to take on this project."
msgstr ""
```

As described previously in the
[Explanation](https://github.com/xogeny/ModelicaBook/blob/master/TRANSLATION.md#explanation),
our goal is to add translated versions of each line after the `msgstr`
token.  Using the web-based editor, we turn the code above into:

```
"Ce livre a commencé comme un projet Kickstarter. L'idée d'écrire un livre et"
" rendant disponible gratuitement, sous une licence Creative Commons, était "
"en grande partie inspiré par les écrits de Cory Doctorow et Lawrence Lessig."
" Leur un message de partage résonné très fort avec moi. Je ne suis pas "
"intéressé par capitaliser sur ma connaissance de Modelica, je veux le "
"partager avec d'autres pour ils peuvent éprouver la même joie que je fais "
"dans l'exploration de ce sujet. Heureusement, ce projet Kickstarter a été "
"financé avec succès le 4 Décembre 2012 et mon odyssée à créer un Creative "
"Commons livre licence a commencé. Si circonstances avaient été différentes, "
"ce livre serait probablement dédié à Cory Doctorow et Lawrence Lessig de "
"m'inspirer de prendre sur ce projet."
```

Note that **we do not change the English text**.  Instead, we simply
add the translated text after the `msgstr` token.  Once we do, there
is a dialog at the bottom where we can commit the changes.

Once these results are committed, they will be added to the `master`
branch of **your** repository.  To see how your repository relates to
other repositories you can visit the [Network
Graph](https://github.com/xogeny/ModelicaBook/network) for the book.
To have your changes merged into the Xogeny repository (so they end up
in the book), you need to make a [pull
request](https://github.com/xogeny/ModelicaBook/blob/master/TRANSLATION.md#pull-requests).

### Desktop Editing

For the desktop process, you'll need to have Git installed on your
computer.  There are many different graphical user interfaces for
different OSs and, of course, the command line tool.  I can't provide
detailed instructions for all of these, so I will stick with the
command line tool.  I suspect that most graphical tools also install
the "git" command line tool somewhere on your machine as well.

To do desktop editing, you'll still need to create a fork as discussed
previously.  Once you do, you need to `clone` the forked repository to
your local machine, like this:

```
% git clone http://github.com/<username>/ModelicaBook
```

From there, you should go to the `LC_MESSAGES` folder:

```
% cd ModelicaBook/text/locale/<language>/LC_MESSAGES
```

To use the same example as with the web-based approach, let's
translate the dedication.  We find the translation file for the
dedication in `front/dedication.po`.  So we can open this with a text
editor, *e.g.,*

```
% emacs front/dedication.po
```

Here was made the changes already discussed in the
[Explanation](https://github.com/xogeny/ModelicaBook/blob/master/TRANSLATION.md#explanation)
section previously.  Once we have edited the file, we can check to see
what modifications we have made locally by executing the following
command:

```
% git status
```

You should see something like this:

```
Your branch is up-to-date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   front/dedication.po
```

This is telling you that you've modified the `front/dedication.po`.
But the changes still need to be committed.  In Git, there are
normally two steps to putting your changes back into the repository.
But we can combine these steps like this:

```
% git commit -a -m "Updated the dedication"
```

The `-a` means "add" the files (the first step) and the `-m` is
followed by the commit message that explains what changes were made.

Even once this commit is done, nobody else can see these changes
because they are still stored on your local computer.  To make them
public, you need to add them to your public repository hosted on
GitHub.  This is done by "pushing" your changes back out to GitHub
with the following command:

```
% git push origin master
```

At this point, your changes are stored in GitHub.  But you'll still
want to make a "pull request"...

### Pull Requests

Once you have reached a stage where you would me (or the language
coordinator, if they are willing to take on this task) to incorporate
the results, you should send them a "pull request".  This can be done
by returning to the main page for your `ModelicaBook` repository
(*i.e.,* `https://github.com/<username>/ModelicaBook`) and clicking
the pull request button:

![Pull Request
 UI](https://github-images.s3.amazonaws.com/help/pull_requests/pull-request-start-review-button.png)

GitHub has [step by step instructions on creating pull
requests](https://help.github.com/articles/creating-a-pull-request)
that might be useful here.

## Generating Translation Files

Generally, translators don't really need to worry about this step.
But in case you have all the tools necessary to build the book, the
following is a list of the various commands needed to build a version
of the book in another language.  It should be noted that some of
these steps require installation of `sphinx-intl`.  This can be done
using `pip` (*e.g.,* `pip install sphinx-intl`).

### Generating `pot` files

```
% make gettext
```

### Updating `po` files

```
% make update
```

### Building the `mo` files:

```
% make buildmo
```

### Generating the book in language <X>

```
% make dirhtml_<X>
```

Currently supported languages are: `cn`, `es`, `fr` and `de` (*e.g.,* `make html_es`)

