.. _annotations:

Annotations
===========

Recall in the discussion on :ref:`experimental-conditions` we included
information about the simulation start and stop time using an
``annotation``.  An ``annotation`` is a way to include information
that is not related to the behavior of the model.  In the case of
experimental conditions, we injected information about how a
particular model should be simulated.  But annotations are used
extensively in Modelica to provide all kinds of additional information
about models.  For example, as we'll see :ref:`later in the book
<graphical-annos>`, annotations are used to describe the graphical
appearance of components and connectors.  For now, the important thing
is to understand that annotations are additional data, above and
beyond behavior, that can be "attached" to different elements in
Modelica.

In this section, we will first cover where an ``annotation`` can
appear in a Modelica model.  Next, we'll explain how we can use
:ref:`record-def` to describe the contents of an annotation.  Finally,
we'll describe a few of the many "standard" annotations that are
included as part of the Modelica specification.

Annotation Locations
--------------------

Annotations can appear in many different places in Modelica.  We will
discuss each potential location and demonstrate the syntax for each case.

Declaration Annotations
^^^^^^^^^^^^^^^^^^^^^^^

.. index:: annotation; associated with; declarations

A declaration annotation comes at the end of a declaration, right
before the ``;``.  Here is a simple declaration that includes an
annotation:

.. code-block:: modelica

    parameter Real length "Rod length" annotation(...);

Note that the ``annotation`` comes after the descriptive string and
before the ``;``.  Also, the ``...`` is simply a place holder for the
:ref:`annotation-data`, which will be discussed shortly.

Statement and Equation Annotations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. index:: annotation; associated with; equation

It is also possible to associate annotations with equations, for
example:

.. code-block:: modelica

    T = T0 "Specify initial value for T" annotation(...);

In declarations and equations, the ``annotation`` is always at the
very end and comes immediately before the ``;``.

Inheritance Annotations
^^^^^^^^^^^^^^^^^^^^^^^

.. index:: annotation; associated with; extends

We briefly discussed the ``extends`` keyword when we talked about
:ref:`modifications` and :ref:`avoiding-repetition`.  It is possible
to associate an ``annotation`` with an ``extends`` clause as follows:

.. code-block:: modelica

   extends QuiescentModelWithInheritance(gamma=0.3, delta=0.01) annotation(...);

As we've observed in each previous case, the ``annotation`` immediately
precedes the ``;``.


Model Annotations
^^^^^^^^^^^^^^^^^

.. index:: annotation; associated with; models
.. index:: annotation; associated with; definitions

A model annotation associates annotation data
directly with the model definition itself.  This is exactly the kind
of annotation we saw when describing :ref:`experimental-conditions`,
*e.g.,*

.. literalinclude:: /ModelicaByExample/BasicEquations/SimpleExample/FirstOrderExperiment.mo
   :language: modelica
   :lines: 2-
   :emphasize-lines: 3

Note how, unlike all the previous annotation locations we've
described, this annotation isn't really "attached" to anything.  This
indicates that it is annotating the model itself.

.. _annotation-data:

Annotation Data
---------------

General Syntax
^^^^^^^^^^^^^^

The syntax of an annotation is the same syntax used for
:ref:`modifications`.  This means the annotation will include either
an assignment to a variable in the annotation, *e.g.,*

.. code-block:: modelica

    annotation(Evaluate=true);

or it will include a modification to something **inside** a variable in
the annotation, *e.g.,*

.. code-block:: modelica

    annotation(experiment(StartTime=0,StopTime=8));

User Annotations
^^^^^^^^^^^^^^^^

Annotations were designed to allow model developers to attach
**arbitrary data** to their models.  For example, if a user wanted to
associate a part number with a given model definition, they might
introduce a model annotation like this:

.. code-block:: modelica

    annotation(PartNumber="FF78-E4B879");

A general principle of annotation data is that if a tool reads in a
model, **it must preserve the annotation information** when it writes
it back out.  The tool does not (and, in general, will not) have to
understand the data.  But the data must be preserved.

Multiple Annotations
^^^^^^^^^^^^^^^^^^^^

Imagine a user wanted to specify **both** a part number and an
experiment annotation.  Then they might end up with an annotation like
this one:

.. code-block:: modelica

    annotation(PartNumber="FF78-E4B879",
               experiment(StartTime=0,StopTime=8));

Note how these two pieces of information can exist side by side.  One
way to think about annotations is to visualize them as a tree like
this:

  * ``PartNumber="FF78-E4B879"``
  * ``experiment``

    * ``StartTime=0``
    * ``StopTime=8``

Namespaces
^^^^^^^^^^

This introduces another principle of annotations which is that it
should be possible to have more than one **as long as the names are
different**.  For this reason, choosing names is very important and
they should be chosen to avoid potential conflicts with other names.
For example, a better approach for including the part number
would be to enclose it in a variable that is more likely to be unique
to your company or application, *e.g.,*:

.. code-block:: modelica

    annotation(XogenyIndustries(PartNumber="FF78-E4B879"),
               experiment(StartTime=0,StopTime=8));

In this case, the variable ``XogenyIndustries`` can be used to carve
out a "namespace" for a specific organization or purpose.  If another
organization came along and wanted to associate a different part
number with the same model, they could do that by establishing their
own separate hierarchy in the annotation, *e.g.,*:

.. code-block:: modelica

    annotation(XogenyIndustries(PartNumber="FF78-E4B879"),
               AcmeEquipment(PartNumber="A23335-992"),
               experiment(StartTime=0,StopTime=8));

Occasionally, Modelica tool vendors include their own special
annotations (*e.g.,* in the Modelica Standard Library).  By
convention, tool vendors use names that are prefixed by two
underscores, *e.g.,*

.. code-block:: modelica

    annotation(XogenyIndustries(PartNumber="FF78-E4B879"),
               __ModelicateTechnologies(enableCoolFeature10=true),
               AcmeEquipment(PartNumber="A23335-992"),
               experiment(StartTime=0,StopTime=8));

Intepretation
^^^^^^^^^^^^^

Remember that annotation data is arbitrary.  This allows arbitrary
data to be associated with the model.  The **meaning** of that data
is, in general, not defined in the Modelica specification.  As we will
see shortly, there are a few "standard" annotations (they will be
described throughout this book) and they are documented in the
specification.  But when users add annotations beyond the standard
annotations it is assumed that they have some way (using some Modelica
tool, compiler or other Modelica aware technology) of extracting and
interpreting their annotation data.

The bottom line is that while you can inject (non-standard) annotation
data into the model, tools are only required to preserve it and not to
interpret it.

Documentation
^^^^^^^^^^^^^

It is very common to document Modelica annotations **as if** they had
:ref:`record-def` associated with them.  We'll see several examples of
this technique in our next topic.  Using this approach to document
expected annotation data are strongly encouraged.  In fact, this
technique is so popular and useful that there are proposals to
actually make it part of the language itself in the future.

Introductory Annotations
------------------------

This section introduces just a few of the "standard annotations" in
Modelica.  As discussed previously, annotations are generally allowed
to include arbitrary data that is preserved by tools and, presumably,
interpreted at some point.  The syntax and meaning of the standard
annotations are described in the Modelica specification so they can be
interpreted consistently and universally by Modelica tools.

We will follow a convention (whenever possible) of describing
standard annotations in terms of ``record`` definitions.  These
``record`` definitions don't formally exist, they are simply a concise
way of expressing the data contained in the annotation.

``Documentation``
^^^^^^^^^^^^^^^^^

.. index:: annotation; Documentation

**Type: Model Annotation**

The ``Documentation`` annotation in Modelica allows raw text or HTML
to be associated with a model as documentation.  This documentation is
composed of two components.  The first is information about the model
and the second is revision history information.  The structure of the
``Documentation`` annotation is described by the following record
definition:

.. code-block:: modelica

    record Documentation
      String info "Documentation in text or HTML format";
      String revision "Revision information in text or HTML format";
    end Documentation;

When embedding HTML inside an annotation, the HTML code must be
surrounded by ``<html>`` tags, *e.g.,*

.. code-block:: modelica

    model MyWidget
      // ... declarations
      annotation(
        Documentation(
          info="<html><h1 class=\"heading\">Introduction</h1><p>...</p></html>"));
      // .. equations
    end MyWidget;

Here the model ``MyWidget`` contains HTML documentation.  The
documentation is wrapped by ``<html>`` tags **and all quotes used to
define attributes are escaped by \\"** to avoid accidentally
terminating the ``info`` string.

.. index:: annotation; experiment

``experiment``
^^^^^^^^^^^^^^

.. index:: annotation; experiment

**Type: Model Annotation**

The ``experiment`` annotation is used to specify information about how
a given model should be simulated.  The annotation data can be
represented in ``record`` form as:

.. code-block:: modelica

    record experiment
      Real StartTime "Time at which the simulation should start";
      Real StopTime "Time at which the simulation should stop";
      Real Interval(min=0) "Time interval between results";
      Real Tolerance(min=0) "Solver tolerance to use";
    end experiment;

``Evaluate``
^^^^^^^^^^^^

.. index:: annotation; Evaluate

**Type: Declaration Annotation (applies to parameters)**

The ``Evaluate`` annotation indicates to a Modelica compiler that the
value of a given ``parameter`` can be transformed into a ``constant``
at compile time.  In other words, it indicates that the user does not
require the ability to change the value of the ``parameter`` from one
simulation to the next.

The motivation behind having such an annotation is that it allows the
Modelica compiler to assume many things about the ``parameter`` during
model compilation that it otherwise couldn't.  These assumptions might
restrict the system of equations in such a way that the underlying
systems of equations are easier to solve than in the general case
where the parameter could take on a range of values.

The ``Evaluate`` annotation is simply a ``Boolean`` variable (``true``
indicating that the ``parameter`` value can be transformed into a
``constant``). It is used in an annotation as follows:

.. code-block:: modelica

    parameter Real x annotation(Evaluate=true);

``HideResult``
^^^^^^^^^^^^^^

.. index:: annotation; HideResult

**Type: Declaration Annotation**

The ``HideResult`` annotation is used to indicate that the solution
for a given variable is not of interest to the analyst.  By setting
the value of ``HideResult`` to ``true``, the model developer is
indicating to the Modelica compiler that it need not store the
annotated variable in any simulation results that are produced.  This
can save both simulation time and disk space because it avoids writing
out data that will never be viewed.

The ``HideResult`` annotation would be used as follows:

.. code-block:: modelica

    Real z "Uninteresting variable" annotation(HideResult=true);
