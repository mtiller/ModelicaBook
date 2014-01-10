.. _functions:

Functions
*********

Up to this point, we've used many of the built-in functions in
Modelica in previous examples and particularly in our discussion of
:ref:`array-functions`.  While Modelica includes an extensive set of
functions for many common calculations, users still need the ability
to define their own functions.  The process of defining functions is
the central topic of this chapter.

As always, we'll start with several examples to motivate the need for
user defined functions.  Then we'll review the important elements of
user defined functions in Modelica.

Examples
========

.. toctree::
   :maxdepth: 1

   functions/polynomial
   functions/interpolation
   functions/controller
   functions/nonlinear

Review
======

.. toctree::
   :maxdepth: 1

   functions/func_def
   functions/control_flow
   functions/external
   functions/func_annos

Restrictions
------------

    * time can't be referenced in a function

.. _assertions:

Assertions
----------

.. index:: ! assert

.. todo::
   
   This text needs to be reworked

The ``AssertionLevel`` attribute is used in conjunction with the
``assert`` function which was presented in our discussion of
:ref:`lotka-volterra-systems`.  In our previous discussion, only two
arguments were passed to assert.  The first was a conditional
expression that we wish to assert should always be true.  The second
was a string that represents the error message to be used should the
assertion be violated (*i.e.*, if the conditional expression becomes
false).  However, there is a *third* **optional** argument to the
``assert`` function of type ``AssertionLevel``.  If no value for the
third argument is provided, the default value is
``AssertionLevel.error``.

During simulation, the simulation environment will generally attempt,
by various means (*e.g.*, tightening tolerances, taking smaller time
steps), to find a solution trajectory that does not violate the
assertion.  However, if it cannot find a trajectory that avoids the
assertion, the value of the third argument to ``assert`` determines
how the simulation environment should respond to the assertion
violation.  If the third argument is ``AssertionLevel.error``, then
the simulation will terminate if it cannot avoid the assertion
violation.  On the other hand, if the value of the third argument is
``AssertionLevel.warning``, then the simulation will simply generate a
diagnostic error message (*i.e.*, the second argument) and
**continue** the simulation.
