Functions
*********

Examples
========

Review
======

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
