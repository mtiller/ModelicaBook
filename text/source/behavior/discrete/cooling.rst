.. _cooling_revisited:

Cooling Revisited
-----------------

Changing Ambient Conditions
^^^^^^^^^^^^^^^^^^^^^^^^^^^

We will start with a simple example that demonstrates time events.  We
will revisit the thermal model introduced previously in the section on
:ref:`physical-types`.  However, this time we will introduce a
disturbance to that system.  Specifically, we will trigger an abrupt
decrease in the ambient temperature after half a second of simulation.
This revised model is written as follows:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/CoolingRevisited/NewtonCoolingDynamic.mo
   :language: modelica
   :emphasize-lines: 21-25
   :lines: 2-

.. index:: if statement

The highlight lines show a ``if`` statement.  This particular ``if``
statement provides two different equations for computing ``T_inf``.

.. topic:: Time

   You will note in this model the variable ``time`` is not declared
   within our model.  This is because ``time`` is a built-in variable
   in all Modelica models.

The decision about which of the two equations will actually be used
depends on the conditional expression ``time<=0.5``.  It is because
this expression only depends on ``time`` and not any other variables
in our model that we can characterize the transition between these two
equations as a "time event".  The key point is that when integrating
these equations, we can tell the solver that integrates our system of
equations to stop precisely at 0.5 seconds and then resume again using
a different equation.  We'll see examples of "state events" (where
this would not be possible) in the next section when we present the
classic :ref:`bouncing-ball` example.

But for now, let us continue with our cooling example.  If we simulate
this model for one second, we get the following temperature
trajectory:

.. plot:: ../plots/NCD.py
   :include-source: no

As you can see in these results, the ambient temperature does indeed
start to decrease after half a second.  In studying the dynamic
response of the temperature itself, we see two distinct phases.  The
first phase is the initial transient response toward equilibrium (to
match the ambient temperature).  The second phase is the tracking of
the ambient temperature as it increases.

Initial Transients
^^^^^^^^^^^^^^^^^^

It is worth noting that this is a very common issue in modeling.
Frequently, you wish to model the systems response to some disturbance
(like the ambient temperature increase in this case).  However, if you
don't start your system in some kind of equilibrium state, the system
response will also include some kind of initial transient (like the
one shown here).  In order to distinguish these two responses clearly,
we want to avoid any overlap between them.  **The simplest way to do
that is to start the simulation in an equilibrium condition** (as
discussed previous in our discussion of :ref:`steady-state`).  This
avoids the initial transient altogether and allows us to focus
entirely on the disturbance that we are interested in.

As we learned during our discussion of :ref:`initialization`, we can
solve this problem of initial transients by simply including an
initial equation that will determine a value for ``T`` such that our
system starts in an equilibrium state, *i.e.,*

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/CoolingRevisited/NewtonCoolingSteadyThenDynamic.mo
   :language: modelica
   :emphasize-lines: 15
   :lines: 2-

The only thing we've changed is the initial equation.  Instead of
starting our system at some fixed temperature, we start it at a
temperature such that the change in temperature (at least initially,
prior to our disturbance) is zero.  Now the temperature response no
longer includes any initial transient and we can focus only on the
response to the disturbance:

.. plot:: ../plots/NCSTD.py
   :include-source: no

Compactness
^^^^^^^^^^^

One issue with ``if`` statements is that they can make relatively
simple changes in behavior appear quite complicated.  There are a
couple of alternative constructs we can use to get the same behavior
with fewer lines of code.

.. index:: if expression

The first approach is to use an ``if`` **expression**.  Whereas an
``if`` statement includes "branches" containing equations, an ``if``
expression has branches that contain only expressions.  Furthermore,
the syntax for an ``if`` expression is also less verbose.  If we had
chosen to use an ``if`` expression our ``equation`` second could have
been simplified to:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/CoolingRevisited/NewtonCoolingIfExpression.mo
   :language: modelica
   :lines: 16-18

.. index:: max

Alternatively, we could use one of the many built-in Modelica
functions, like ``max``, to represent the change in the ambient
temperature, *e.g.,*

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/CoolingRevisited/NewtonCoolingMinFunction.mo
   :language: modelica
   :lines: 16-18


.. todo::

   Discuss events?
