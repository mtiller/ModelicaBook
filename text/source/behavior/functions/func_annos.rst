.. _func-annotations:

Function Annotations
====================

Modelica includes a number of standard annotations that can be applied
to functions.  These meaning of these annotations is formally defined
in the Modelica Specification.  In this section, we'll talk about the
three general categories of annotations for functions and provide some
discussion of why you need them and how to use them.

Mathematical Annotations
------------------------

The first class of annotations are ones that provide additional
mathematical information about the function.  Because functions are
written using ``algorithm`` sections, it is not generally possible to
derive equations for the behavior of the function and many symbolic
manipulations are therefore not possible.  However, using the
annotations in this section allows us to augment the function
definition with such information.

``derivative``
~~~~~~~~~~~~~~

``inverse``
~~~~~~~~~~~

Code and Event Generation
-------------------------

The next class of annotations are related to how function definitions
are translated into code for simulation.  These annotations allow the
model developer to provide hints to the Modelica compiler on how the
code generation process should be done.

``Inline``
~~~~~~~~~~

``LateInline``
~~~~~~~~~~~~~~

``GenerateEvents``
~~~~~~~~~~~~~~~~~~

External Functions
------------------

The final class of annotations are related to functions that are
defined as ``external``.  Such functions often depend on external
include files or libraries.  These annotations inform the Modelica
compiler of these dependencies and where to locate them.

``Include``
~~~~~~~~~~~

``IncludeDirectory``
~~~~~~~~~~~~~~~~~~~~

``Library``
~~~~~~~~~~~

``LibraryDirectory``
~~~~~~~~~~~~~~~~~~~~

