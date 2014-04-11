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

#: ../../source/front/dedication.rst:23
```

Note the addition of the lines following the line with the `msgstr` directive on it.

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

Currently supported languages are: `cn`, `es`, `fr` and `de (*e.g.,* `make html_es`)

