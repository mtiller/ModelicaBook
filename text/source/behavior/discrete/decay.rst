State Event Handling
--------------------

Now that we have already introduced both :ref:`time events
<cooling-revisited>` and :ref:`state events <bouncing-ball>`, let's
examine some important complications associated with state events.
Surprisingly, these complications can be introduced by even simple
models.  Consider the following almost trivial model:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/Decay/Decay1.mo
   :language: modelica
   :lines: 2-

If we attempt to simulate this model for 5 seconds, we fine that the
simulation terminates after about 2 seconds with the following trajectory:

.. plot:: ../plots/Decay1.py
   :include-source: no

Again, numerical issues creep in.  Even though mathematically it
should not be possible for the value of ``x`` to drop below zero,
using numerical integration techniques it is possible for small
amounts of error to creep in and drive ``x`` below zero.  When that
happens, the ``sqrt(x)`` expression generates a floating point
exception and the simulation terminates.

To prevent this, we might introduce an ``if`` expression to guard
against evaluating the square root of a negative number, like this:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/Decay/Decay2.mo
   :language: modelica
   :lines: 2-

Simulating this model we get the following trajectory[#tol]:

.. plot:: ../plots/Decay2.py
   :include-source: no

Again, the simulation fails.  But why?  It fails for the same reason,
a numerical exception that results from taking the square root of a
negative number.

Most people are quite puzzled when they see an error message about a
floating point exception like this (or, for example division by zero)
after they have introduced a guard expression as we have done.  They
naturally assume that there is no way that ``sqrt(x)`` can be
evaluated if ``x`` is less than zero...**and they are wrong**.

Given the ``if`` expression:

.. code-block: modelica

    der(x) = if x>=0 sqrt(x) else 0;

it is entirely possible that ``sqrt`` will be called with a negative
argument.  The reason is related to the fact that this is a state
event.  Remember, the time at which a *time event* will occur is known
in advance.  But this is not the case for a state event.  In order to
determine when the event will occur, we have to search the solution
trajectory to see when the condition (*e.g.,* ``x>=0`` becomes
false).

The important thing to understand is that **until the event occurs,
the behavior doesn't change**.  In other words, the two sides of this
``if`` expression represent two types of behavior, ``der(x)=sqrt(x)``
and ``der(x)=0``.  Since ``x`` is initially greater than zero, the
initial behavior is ``der(x)=sqrt(x)``.  **The solver will continue
using this equation until it has determined the time of the event**
represented by ``x>=0``.  In order to determine the time of that
event, **it must go past the point where the value of the conditional
expression changes**.  This means that while attempting to determine
precisely when the condition ``x>=0`` changes from true to false, it
will continue to use the equation ``der(x)=sqrt(x)`` even though ``x``
is negative.

Most users initially assume that each time ``der(x)`` is evaluated,
the ``if`` expression is evaluated (specifically the conditional
expression in the ``if`` expression).  Hopefully the previous
paragraph has made it clear that this is not the case.  But the
question remains.  Why?

The reason has to do with performance.  If the conditional expression
led to an abrupt change in behavior (like the one we saw in our
discussion on :ref:`cooling-revisited`) it would cause a variable time
step integrator to spend an exceptional (and unnecessary) amount of
time trying to localize the source of the additional integration
error.  Because the integrator doesn't know *a priori* where the event
occurs (as with a time event) and it has no way to quickly identify
the point at which the event occurs, it has no choice but to
repeatedly re-attempt the integration step until it finds a step size
where the integration error is tolerable.

This time spent trying and retrying integration steps can be saved
thanks to the fact that Modelica can extract a so-called "zero
crossing" function from the ``if`` expression.  This function is
called a zero crossing function because it is normally constructed to
have a root at the point where the event will occur.  For example, if
we had the following ``if`` expression:

.. code-block: modelica

    y = if a>b then 1 else 0;

The zero crossing function would be :math:`a-b`.  This function is
chosen because it changes from positive to negative precisely at the
point where ``a>b``.  In our case, the zero crossing function is
simply :math:`x`.

The Modelica compiler collects all the zero crossing functions in the
model for the integrator to use.  During integration, the integrator
checks to see if any of the zero crossing functions have changed
sign.  If they have, it uses the solution it computed during that step
to interpolate the zero crossing function to find the location, in
time, of the root of the zero crossing function and this is the point
in time where the event occurs.  This process is much more efficient
because the root finding algorithms have more information to help them
identify to location of the root (information like the derivative of
the zero crossing function) and evaluation is very cheap because it
doesn't involve taking additional integration steps, only evaluating
the interpolation functions from the triggering integration step.

.. index: noEvent

But after all this, it still isn't clear how to avoid the problems we
say in the ``Decay1`` and ``Decay2`` models.  The answer is a special
operator called ``noEvent``.  The ``noEvent`` operator suppresses this
special event handling.  Instead, it does what most users expected
would happen in the first place which is to evaluate the conditional
expression for every value of ``x``.  We can see the ``noEvent``
operator in action in the following model:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/Decay/Decay3.mo
   :language: modelica
   :lines: 2-

and the results can be seen here:

.. plot:: ../plots/Decay3.py
   :include-source: no

Now the simulation completes without any problem.  This is because the
use of ``noEvent`` ensures that ``sqrt(x)`` is never called with a
negative value of ``x``.

To avoid the kinds of performance issues mentioned earlier, the
``noEvent`` operator should only be used when there is a smooth
transition in behavior.

.. todo: Smooth operator

.. [#tol] This model will not always fail.  The failure depends on how
	  much integration error is introduced and this, in turn,
	  depends on the numerical tolerances used.
