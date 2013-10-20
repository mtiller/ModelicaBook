Basic Equations
***************

As mentioned in the :ref:`preface`, our exploration of Modelica starts
with understanding how to represent basic behavior.  In this chapter,
our focus will be on demonstrating how to write basic equations.

Examples
========

.. _first-order:

Simple First Order System
-------------------------

Let us consider an extremely simple differential equation:

.. math:: \dot{x} = (1-x)

Looking at this equation, we see there is only one variable,
:math:`x`.  This equation can be represented in Modelica as follows:

.. _ex_SimpleExample_FirstOrder:

.. literalinclude:: /ModelicaByExample/BasicEquations/SimpleExample/FirstOrder.mo
   :language: modelica
   :lines: 2-

.. index:: model
.. index:: der

This code starts with the keyword ``model`` which is used to indicate
the start of the model definition.  The ``model`` is followed by the
model name, ``FirstOrder``.  This is, in turn, followed by a
declaration of all the variables we are interested.  Since the
variable :math:`x` in our equation is clearly mean to be a continuous
real valued variable, it's declaration in Modelica takes the form
``Real x;``.  After all the variables have been declared, we can begin
including the equations that describe the behavior of our model.  In
our case, we can use the ``der`` operator to represent the time
derivative of ``x``.

Unlike most programming languages, we don't approach code like this as
a "program" that can be interpreted as a set of instructions to be
executed one after the other.  Instead, we use Modelica tools to
transform this model into something that we can simulate.  This
simulation step essentially amounts to solving (usually numerically)
the equation and providing a solution trajectory.

.. plot:: ../plots/BasicEquations_SimpleExample_FirstOrder.py
   :include-source: no

This gives you the first initial hint at one of the compelling aspect
of using a modeling language to describe mathematical behavior.  We
didn't need to describe the solution scheme at all.  The focus is
entirely on behavior.  As we work our way through more complex
examples, we will see that lots of tedious work involving the solution
process is avoided using Modelica.

.. _first-order-doc:

Adding Some Documentation
^^^^^^^^^^^^^^^^^^^^^^^^^

Now that we've solved this simple mathematical equation, let's turn
our attention briefly to how we can make the model a bit more
readable.  Consider the following model:

.. _ex_SimpleExample_FirstOrderDocumented:

.. literalinclude:: /ModelicaByExample/BasicEquations/SimpleExample/FirstOrderDocumented.mo
   :language: modelica
   :lines: 2-

.. index:: descriptive strings

Note the quoted text in this model.  An important thing to understand
about that quoted text is that those strings are **not** comments.
They are "descriptive strings" and, unlike comments, they cannot be
added in arbitrary places.  Instead, they can be inserted in specific
places to provide additional documentation about the model.

For example, the first string "A simple first order differential
equation" is used to describe what this is a model of.  Note how it
follows the name of the model.  If you wish to include such
documentation about the model, it must appear immediately after the
model name as shown.  As we will see later, this kind of documentation
can be used by tools in many ways.  For example, when searching for
models tools may look for matches within this descriptive text.  When
displaying models within a package, this text may be associated with
the graphical representation of the models somehow.  And, of course,
this kind of documentation is very useful for anybody reading the
model.

As we can see in this example, there are other places that the
descriptive text can appear.  For example, it may be included after
the declaration of a variable to document that variable.  It can also
be included after an equation to document the equation.

.. _first-order-init:

Initialization
^^^^^^^^^^^^^^

As we have seen already, Modelica allows us to describe differential
equations.  But an important part of any differential equation
solution is the initial conditions.  Modelica gives us equally
powerful constructs for describing the initialization of our system of
equation.  For example, if we wanted the initial value of ``x`` in our
model to be *2*, we could add an ``initial equation`` section to our
model as follows:

.. index:: initial equation

.. _ex_SimpleExample_FirstOrderInitial:

.. literalinclude:: /ModelicaByExample/BasicEquations/SimpleExample/FirstOrderInitial.mo
   :language: modelica
   :lines: 2-

Note that the only difference between this model and the previous one
in `Adding Some Documentation`_ is the addition of the
``initial equation`` section including the equation ``x = 2``.  If we
add this equation, our system has a different initial starting
condition and the solution trajectory is quite different as we can see
in the following figure:

.. plot:: ../plots/BasicEquations_SimpleExample_FirstOrderInitial.py
   :include-source: no

Example :ref:`FirstOrderInitial <ex_SimpleExample_FirstOrderInitial>`
shows a typical way of initializing a system by providing initial
values for the states of the system.  In fact, initial value problems
are frequently written as a combination of the differential equations
and initial conditions, *e.g.*,

.. math:: \dot{x} = (1-x);\; x(0) = 2

However, there are many cases where you want a more sophisticated type
of initialization.  An ``initial equation`` section can contain more
than just explicit equations for the values of the state variables.
For example, if we wanted our first order system to be initialized to
some steady-state condition but it was too complex to compute the
explicit values for the state variables, we can simply express our
initialization as:

.. literalinclude:: /ModelicaByExample/BasicEquations/SimpleExample/FirstOrderSteady.mo
   :language: modelica
   :lines: 2-

Simulating this system gives the following solution:

.. plot:: ../plots/BasicEquations_SimpleExample_FirstOrderSteady.py
   :include-source: no

Complete coverage of the initialization topic can be found in the
:ref:`initialization` section of this chapter.

Getting Physical
----------------

Default Values
^^^^^^^^^^^^^^

Physical Units
^^^^^^^^^^^^^^

Physical Types
^^^^^^^^^^^^^^

Lotka-Volterra Systems
----------------------

Steady State Initialization
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Inheritance
^^^^^^^^^^^

Complex Initialization
^^^^^^^^^^^^^^^^^^^^^^

An Electrical Example
---------------------

A Mechanical Example
--------------------

Initial Conditions
^^^^^^^^^^^^^^^^^^

Review
======

Model Definition
----------------

.. index:: ! model

Equations
---------

.. index:: ! der

.. _initialization:

Initialization
--------------

Make sure problems are well specified.  Note default initial condition
in :ref:`first-order`
vs. :ref:`first-order-init`

.. index:: ! initial equation


.. index:: ! descriptive strings
