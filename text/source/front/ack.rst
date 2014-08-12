Acknowledgments
===============

This book is the culmination of so many lectures, books, discussions,
conferences, *etc.* that it is impossible to provide a full accounting
to all the people who've had an impact on the book.  Undoubtedly,
there are people I've failed to mention here and I apologize in
advance to anyone who feels they've been overlooked.

Technical
---------

On the subject of Modelica, the primary acknowledgment has to be to
Hilding Elmqvist for not only having the technical vision to recognize
the potential impact that symbolic manipulation techniques could have
on solving engineering problems but having the leadership to push this
vision forward as an open standard.  Hilding is the undisputed "father
of Modelica" and he deserves considerable credit for all that Modelica
has become.

Second only to Hilding is Martin Otter, a man who has worked
tirelessly for the advancement of Modelica.  I can honestly say that
Martin works harder than anybody else I know.  He has not only made
countless technical contributions to Modelica, but he's taken on the
unenviable and generally thankless task of managing the Modelica
Association.  It is important to remember that having great technical
ideas is by no means a recipe for success.  Somebody has to be there
to push and push and push those ideas along.  I'd like to thank Martin
for all his hard work in making the Modelica Association what it is
today.

Of course, Martin isn't alone in running the Modelica Association.
The Modelica Association Board and the Members are also extremely
important for raising awareness about Modelica.  In the end, the
Modelica Association is an organization committed to open standards
that support engineering and I'd like to thank all the members for
their hard work in this regard.

There wasn't always a Modelica Association, but there was always a
Modelica Design Group.  These are the people who come together several
times a year and work on continuously improving the Modelica language.
It is astounding how much time and energy people have volunteered
toward this effort.  I'd like to thank all those people who've
participated in the development of the Modelica Language and the
Modelica Standard Library.

Personal
--------

On a personal note, I am forever indebted to my mother, my father, my
wife, my kids and my in-laws for their endless support of my passion
for science, engineering and math.  They are responsible for
cultivating and sustaining my interests in these topics so I owe all
the energy and time I'm able to apply to projects like this one to
them.

The very idea of a book that is available for free might seem radical
to some.  The basic premise of this project was largely inspired by
listening to and reading the works of Cory Doctorow and Lawrence
Lessig.  I'd like to thank them for opening my eyes to the idea of
Creative Commons licensing.  I'd also like to thank Dietmar Winkler
for the many discussions we had on alternative publishing models.  We
would frequently discuss the ideas of Doctorow and Lessig and how
their ideas could be applied to the creation of more accessible
content for the Modelica world.

Looking back, I feel very fortunate to have worked for several
companies that supported my involvement in Modelica.  I first got
involved with Modelica while I was working at Ford Motor Company and I
was fortunate that they were willing to sponsor my participation in
many different Modelica related events.  After Ford, I went to work at
Emmeskay (eventually acquired by LMS).  I benefited enormously from
the interactions I had with my Emmeskay family.  In particular, I'd
like to thank my partners, Swami Gopalswamy and Shiva Shivashankar for
giving me the opportunity to be part of Emmeskay and for being great
friends.  While at Emmeskay, it was a privilege to work with Michael
Sasena and John Batteh on several Modelica related projects.  Emmeskay
was an incredible company and this was entirely a reflection on the
great group of people who worked there.  Finally, I'd like to thank
Dassault Systèmes for giving me the opportunity to work with all the
excellent people there as well.  In particular, I'd like to thank
Hilding Elmqvist and Marc Frouin for encouraging me to come work
there.  I'd also like to thank Martin Malmheden, Dag Brück and
Sandrine Loembe for all the good times during my excellent year in
Paris.

Contributors
------------

This project was really an experiment to see if the Kickstarter
approach to publishing could be applied to a niche technical field
like Modelica.  I was pleasantly surprised to see that it could and
that this project had enough support to be funded.  For that reason,
I'd like to thank the backers of the Kickstarter project.  In
particular, I'd like the thank the following people for their
exceptionally generous contributions:

    * Hilding Elmqvist
    * Robert Norris
    * Matthis Thorade
    * Henning Francke
    * Yang Ji
    * Christoph Höger
    * Philipp Mossmann
    * John Batteh
    * Dirk Zimmer
    * Jan Brugård
    * Swami Gopalswamy
    * Peter Aronsson
    * Michael P. Case
    * Markus Groetsch
    * Vicente Ramírez Perea
    * Tisha Villanueva
    * Adrian Pop
    * Nimalendiran Kailasanathan
    * Kevin Davies
    * Peter Harman
    * Dietmar Winkler
    * Johan Rhodin

I'd also like to thank the corporate sponsors:

    * Gold Sponsors

      * CyDesign
      * Wolfram Research
      * Modelon
      * Maplesoft
      * Dassault Systèmes

    * Silver Sponsors

      * Ricardo Software
      * ITI
      * Modelica Association
      * Global Crown Technology
      * Siemens

    * Bronze

      * Suzhou Tongyuan
      * Open Source Modelica Consortium
      * DOFWare
      * Bausch-Gall GmbH
      * Technische Universität Hamburg/Harburg
      * Schlegel Simulation GmbH

This project shows the power of community to achieve the mutual goal
of creating more quality educational material around Modelica.
Literally, this project could not have happened without them.

The Kickstarter funding allowed me to commit time to this project, but
I also had several people helping me on this project.  First and
foremost, I'd like to once again thank my father who helped proof-read
the initial draft of this book.  Proof-reading is a necessary but
rather boring job so I think he deserves extract credit for making
that sacrifice.  Similarly, I'd like to thank Dietmar Winkler and
Michael O'Keefe for providing additional feedback on the book
content.  Dietmar has also helped me test publishing issues related to
supporting ePub and PDF formats.

I'd like to thank Jeff Waters for being the "voice of the sponsor".  I
had several very productive discussions with Jeff during the course of
writing this book to make sure that the layout and graphical design
lived up to sponsors' expectations.

Tools
-----

Building a book like this requires a lot of different tools.  My
productivity was amplified enormously by the use of these tools.

This book was written using Sphinx, a documentation generation tool
that supports multiple outputs.  Sphinx allows me to focus on the
content of the book and takes care of generating the book in multiple
formats.

In creating this book, I needed a way to test the models that appear
in the book, generate simulation results for plots and generated
JavaScript code that allows the browser integrated simulation
capabilities in the HTML book.  OpenModelica supported all of these
use cases.  But beyond that, I owe a big "Thank You" to Martin Sjölund
and the OpenModelica team for quickly responding to various issues I
had during the creation of the book.  Many times I would see Martin on
Skype late at night (Sweden time) and he was gracious enough to help
me out.

The browser integrated simulation capabilities in the HTML version of
the book are only possible because of a tool called Emscripten which
allows ordinary code in languages like C and C++ to be cross-compiled
(via LLVM) into JavaScript.  Although I knew this was possible, I
didn't really think this avenue was viable until I saw `the work of Tom Short <https://github.com/tshort/openmodelica-javascript>`_
integrating OpenModelica and Emscripten.  The browser integrated
simulation capabilities were greatly enabled by his work in this area.

This book was written using Git as the version control system and
`GitHub <http://github.com>`_ for hosting.  Most people think of the
version control system as some arcane backup system.  But version
control systems are at the heart of collaboration and I'd like to see
them used more widely in engineering.  For this book, the "pull
request" system from GitHub was very useful in incorporating feedback
from reviewers.  I'd like to again thank Dietmar Winkler for
enlightening me about many different features in Git.

I used the Emacs editor for this book.  Despite the proliferation of
really excellent editors that support a wide range of languages and
platforms, Emacs remains the work horse of my development process for
most projects.  It seems to support just about every type of file I
need to edit out of the box.

During the production of this book several tool vendors gave me access
to their proprietary tools.  I didn't utilize these very much, but I
wanted to acknowledge their generosity in providing me with temporary
licenses.  Specifically, I'd like to thank Dassault Systèmes,
Maplesoft, Wolfram Research and ITI for giving me access to Dymola,
MapleSim, SystemModeler and SimulationX, respectively.

Much of this book was written on a MacBook Air.  My very first
computer was an Apple //e.  But since that time, I've worked mainly
with PCs and Unix workstations.  Most recently, I've done a great deal
of development on Linux machines.  I always dismissed using Macs
because I was convinced they couldn't support the kind of command-line
oriented development work I typically do.  I could not have been more
wrong.  The eco-systems for MacOSX is almost identical to the one I
was used to in the Linux world.  I am able to seamlessly transition
between MacOSX and Linux environments without any significant
adjustments.  The power and portability of the MacBook Air gave my
entire work process a big boost.

Developing this book involved a lot of testing and debugging of HTML
layout, styling and embedded JavaScript.  Most of this work was done
using Firefox but I've also used Chrome from time to time as well.
I'd like to thank both the Mozilla Foundation and Google for creating
such wonderful, standards compliant browsers.

The style of the book owes a fair amount to the `Semantic UI
<http://www.semantic-ui.com>`_ CSS framework.
