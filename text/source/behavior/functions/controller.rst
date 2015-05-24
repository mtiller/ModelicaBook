.. _sil-controller:

Software-in-the-Loop Controller
===============================

In the previous :ref:`interpolation` example, we saw external C
functions could be used to manage and interpolate data.  In this
section, we will explore how to integrate C code for an embedded
controller into a Modelica model.

When building mathematical models of physical systems in Modelica, it
is sometimes useful to integrate (external) control strategies into
these models.  In many cases, these strategies exist as C code
generated for use with an embedded controller.  This example revisits
the topic of :ref:`hysteresis`, but with an interesting twist.  Instead
of implementing the hysteresis behavior in Modelica using discrete
states, we will implement it in an external C function.  Although this
example is extremely simple, it demonstrates all the essential steps
necessary to integrate external control strategies.

Physical Model
--------------

Let's start by looking at our "physical model".  In this case, it is
essentially just a reimplementation of the model we created previously
during our discussion on :ref:`hysteresis`.  Our revised
implementation looks like this:

.. literalinclude:: /ModelicaByExample/Functions/ImpureFunctions/HysteresisEmbeddedControl.mo
   :language: modelica
   :lines: 2-

Let's take a closer look at the ``equation`` section:

.. literalinclude:: /ModelicaByExample/Functions/ImpureFunctions/HysteresisEmbeddedControl.mo
   :language: modelica
   :lines: 17-22

The function ``computeHeat`` is called every 10 milliseconds to
determine the amount of heat to be used.  As we will see in a moment,
the controller implements a "bang-bang" control strategy.  That means
it flips between zero heat generation and full heat generation.  As we
saw in our previous discussion on :ref:`hysteresis`, this kind of
approach can lead to "chattering".  For that reason, we put the
calculation of ``Q`` inside a ``when`` statement that is executed
every 10 milliseconds.  This 10 millisecond interval is essentially
implementing the behavior of what is normally called a "scheduler"
which decides when different control strategies are executed.

Embedded Control Strategy
-------------------------

The Modelica function ``computeHeat`` used to determine how much heat
should be applied to the system at any given time is implemented as:

.. literalinclude:: /ModelicaByExample/Functions/ImpureFunctions/computeHeat.mo
   :language: modelica
   :lines: 2-

Note the presence of the ``external`` keyword.  This time, however, we
don't see the name of the external C function like we did in the
previous examples.  This means that the external C function has
exactly the same name and arguments as its Modelica counterpart.
Looking at the source code for the C function, we see that is the
case:

.. literalinclude:: /ModelicaByExample/Functions/ImpureFunctions/source/ComputeHeat.c
   :language: c

In other words, we can save ourselves the trouble of specifying how
the input and output arguments of our Modelica function map to those
of the underlying C function by defining them in such a way that no
mapping is truly necessary.

Note the presence of the ``static`` variable ``state`` in the C
implementation of ``computeHeat``.  The use of the ``static`` keyword
here indicates that the value of the variable ``state`` is preserved
from one invocation of ``computeHeat`` to another.  This kind of
variable is quite common in embedded control strategies because they
need to preserve information from one invocation of the scheduler to
the next (*e.g.,* to implement hysteresis control, as we see here).

.. index:: side effects

The presence of this ``static`` variable is a significant problem
because it means that the function ``computeHeat`` can return
**different results for the same input arguments**.  Mathematically
speaking, this is not a true mathematical function since a
mathematical function can only depend on its input arguments.  In
computer science, we say such a function is "impure".  This
means that each invocation of the function changes some internal
memory or variable which affects that value returned by the function.

Given that such impurity is implemented in embedded control
strategies **by design**, we need to be careful when using them in a
mathematically oriented environment like Modelica.  This is because
the Modelica compiler assumes, by default, that all functions are pure and side
effect free and the presence of impurity or side effects can result in very
inefficient simulations, at best, or completely erroneous results, at
worst.

These problems occur because the underlying solvers must compute many
"candidate" solutions before they compute the "real" solution.  If
generating candidate solutions requires the solver to invoke functions
with side effects, the solver will be unable to anticipate the effects
triggered by the changes to variables it is not aware of.

It is for precisely this reason that the ``impure`` qualifier is
applied to the definition of ``computeHeat``:

.. literalinclude:: /ModelicaByExample/Functions/ImpureFunctions/computeHeat.mo
   :language: modelica
   :lines: 2-3

This informs the Modelica compiler that this function **has side
effects or returns a result that depends on something other than its inputs** and that it **should not** be invoked when generating
candidate solutions.  At first, this seems like it would completely
prohibit calling the function, but that isn't the case.  Recall our
integration of the control strategy:

.. literalinclude:: /ModelicaByExample/Functions/ImpureFunctions/HysteresisEmbeddedControl.mo
   :language: modelica
   :lines: 17-22

In particular, note that ``computeHeat`` is invoked only within the
``when`` statement and not as part of a "continuous" equation.  As a
result, we can be certain that ``computeHeat`` will only be invoked in
response to an event but not when evaluating candidate solutions for the
continuous variables.

Results
-------

In the C function ``computeHeat``, we see that these two statements
implement a +/- 2 degree deadband around the setpoint:

.. literalinclude:: /ModelicaByExample/Functions/ImpureFunctions/source/ComputeHeat.c
   :language: c
   :lines: 15-16

It is this functionality that prevents chattering and which can be
clearly observed in the simulated results for our example:

.. plot:: ../plots/SIL.py
   :class: interactive
