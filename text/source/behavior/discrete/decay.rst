.. _state-events:

State Event Handling
--------------------

Now that we have already introduced both :ref:`time events
<cooling-revisited>` and :ref:`state events <bouncing-ball>`, let's
examine some important complications associated with state events.
Surprisingly, these complications can be introduced by even simple
models.

Basic Decay Model
^^^^^^^^^^^^^^^^^

Consider the following almost trivial model:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/Decay/Decay1.mo
   :language: modelica
   :lines: 2-

If we attempt to simulate this model for 5 seconds, we find that the
simulation terminates after about 2 seconds with the following trajectory:

.. plot:: ../plots/Decay1.py

Again, numerical issues creep in.  Even though mathematically it
should not be possible for the value of ``x`` to drop below zero,
using numerical integration techniques it is possible for small
amounts of error to creep in and drive ``x`` below zero.  When that
happens, the ``sqrt(x)`` expression generates a floating point
exception and the simulation terminates.

Guard Expressions
^^^^^^^^^^^^^^^^^

To prevent this, we might introduce an ``if`` expression to guard
against evaluating the square root of a negative number, like this:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/Decay/Decay2.mo
   :language: modelica
   :lines: 2-

Simulating this model we get the following trajectory [#tol]_:

.. plot:: ../plots/Decay2.py

Again, the simulation fails.  But why?  It fails for the same reason,
a numerical exception that results from taking the square root of a
negative number.

Most people are quite puzzled when they see an error message about a
floating point exception like this (or, for example division by zero)
after they have introduced a guard expression as we have done.  They
naturally assume that there is no way that ``sqrt(x)`` can be
evaluated if ``x`` is less than zero.  **But this assumption is incorrect.**

Events and Conditional Expressions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The Role of Events in Behavior
******************************

Given the ``if`` expression:

.. code-block:: modelica

    der(x) = if x>=0 then sqrt(x) else 0;

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
paragraph has made it clear that this is not the case.  


This time spent trying and retrying integration steps can be saved
thanks to the fact that Modelica can extract a so-called "zero
crossing" function from the ``if`` expression.  This function is
called a zero crossing function because it is normally constructed to
have a root at the point where the event will occur.  For example, if
we had the following ``if`` expression:

.. code-block:: modelica

    y = if a>b then 1 else 0;

The zero crossing function would be :math:`a-b`.  This function is
chosen because it changes from positive to negative precisely at the
point where ``a>b``.

Recall our previous equation:

.. code-block:: modelica

    der(x) = if x>=0 then sqrt(x) else 0;

In this case, the zero crossing function is simply :math:`x` since the
event occurs when :math:`x` itself crosses zero.

The Modelica compiler collects all the zero crossing functions in the
model for the integrator to use.  During integration, the integrator
checks to see if any of the zero crossing functions have changed
sign.  If they have, it uses the solution it computed during that step
to interpolate the zero crossing function to find the location, in
time, of the root of the zero crossing function and this is the point
in time where the event occurs.  This process is much more efficient
because the root finding algorithms have more information to help them
identify the location of the root (information like the derivative of
the zero crossing function) and evaluation is very cheap because it
doesn't involve taking additional integration steps, only evaluating
the interpolation functions from the triggering integration step.

.. index: noEvent

.. _no-event:

Event Suppression
^^^^^^^^^^^^^^^^^

But after all this, it still isn't clear how to avoid the problems we
saw in the ``Decay1`` and ``Decay2`` models.  The answer is a special
operator called ``noEvent``.  The ``noEvent`` operator suppresses this
special event handling.  Instead, it does what most users expected
would happen in the first place, which is to evaluate the conditional
expression for every value of ``x``.  We can see the ``noEvent``
operator in action in the following model:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/Decay/Decay3.mo
   :language: modelica
   :lines: 2-

and the results can be seen here:

.. plot:: ../plots/Decay3.py
   :class: interactive

Now the simulation completes without any problem.  This is because the
use of ``noEvent`` ensures that ``sqrt(x)`` is never called with a
negative value of ``x``.

It might seems strange that we have to explicitly include the
``noEvent`` operator in order to get what we consider the most
intuitive behavior.  Why not make the default behavior the most
intuitive one?  The answer is performance.  Using conditional
expressions to generate events improves the performance of the
simulations by giving the solver clues about when to expect abrupt
changes in behavior.  Most of the time, this approach doesn't cause
any problem.  The examples we have presented in this chapter were
designed to highlight this issue, but they are not representative of
most cases.  For this reason, ``noEvent`` is not the default, but must
be used explicitly.  It should be noted that the ``noEvent`` operator
should only be used when there is a smooth transition in behavior,
otherwise it can create performance issues.

Chattering
^^^^^^^^^^

There is a common effect known as "chattering" that you will run into
sooner or later with Modelica.  Consider the following model:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/Chatter/WithChatter.mo
   :language: modelica
   :lines: 2-

Effectively, the behavior of this model is that for any initial value
of ``x``, it will progress linearly toward 1.  Mathematically
speaking, once the value of ``x`` gets to 1, it should just stay
there.  This is because any deviation away from 1, either greater than
or less than, will immediately cause it to go back to 1.

But we will not be solving these equations in a strictly mathematical
way.  We'll be using floating point representations and using
numerical integrators. As such, we have limited precision and
integration error to content with.  The net effect will be that the
trajectory of ``x`` will not remain exactly 1 but will deviate
slightly above and below.  Each time this happens, it will generate an
event.

Simulating this model gives us the following results:

.. plot:: ../plots/WC.py

This kind of model can introduce an effect known as "chattering".
Chattering is simply the degradation in simulation performance due to
a large number of events occurring that artificially shorten the time
steps taken by the solver.  The impact on simulation performance is
clear if we look at the CPU time taken during the simulation.  It
starts to rise dramatically once ``x`` is close to 1.  This is because
behind the scenes the events are causing lots of very small time steps
which dramatically increases the number of computations being
performed.  The important thing about the ``WithChatter`` example is
that it has a seemingly obvious mathematical solutions but still
suffers from degraded simulation performance because of the high
frequency of events.

This is another case where the ``noEvent`` operator can help us out.
We can suppress the events being generated by the conditional
expression by using the ``noEvent`` operator as follows:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/Chatter/WithoutChatter.mo
   :language: modelica
   :lines: 2-

In doing so, we will get approximately the same solution, but with
better simulation performance:

.. plot:: ../plots/WOC.py

Note how there is no perceptible change in the slope of the CPU usage
before and after ``x`` arrives at 1.  Contrast this with the
significant difference seen in the case of ``WithChatter``.

In reality, equations like this are uncommon.  In this case, we've
used an extreme case in an attempt to clearly show the impact of
chattering.  The behavior being described here is not particularly
realistic or physical.  In this case, we've exaggerated the effect to
clearly demonstrate the impact on simulation performance.

More typical examples of chattering in the real world will feature a
conditional expression that sits at some stable point (``Decay2`` is a
good example).  In such cases, chattering occurs because the system
tends to naturally settle at or near the point where the conditional
expression occurs.  But because of precision and numerical
considerations, the event associated with the conditional expression
is frequently triggered.  The effect is exacerbated in cases where
there are many components in the system all sitting at or near such
equilibrium points. 


Speed vs. Accuracy
^^^^^^^^^^^^^^^^^^

Hopefully the discussion so far has made it clear why it is necessary
to suppress events in some cases.  But one might reasonably ask, why
not skip events and just evaluate conditional expressions all the
time?  So let's take some time to explore this question and explain
why, on the whole, associating events with conditional expressions is
very good idea [#Belmon]_.

Without event detection, the integrator will simply step right over
events.  When this happens, the integrator will miss important changes
in behavior and this will have a significant impact on the accuracy of
the simulation.  This is because the accuracy of most integration
routines is based on assumptions about the continuity of the
underlying function and its derivatives.  If those assumptions are
violated, we need to let the integration routines know so they can
account these changes in behavior.

This is where events come in.  They force the integration to stop at
the point where a behavior change occurs and then restart again after
the behavior change has occurred.  The result is greater accuracy but
at the cost of slower simulations.  Let's look at a concrete example.
Consider the following simple Modelica model:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/Accuracy/WithEvents.mo
   :language: modelica
   :lines: 2-

Looking at this system, we can see that half the time the derivative
of ``x`` will be ``2`` and the other half of the time the derivative
of ``x`` will be ``0``.  So over each of these cycles, the average
derivative of ``x`` should be ``1``.  This means at the end of each
cycle, ``x`` and ``y`` should be equal.

If we simulate the ``WithEvents`` model, we get the following results:

.. plot:: ../plots/WE.py
   :class: interactive

Note how, at the end of each cycle, the trajectories of ``x`` and
``y`` meet.  This is a visual indication of the accuracy of the
underlying integration.  Even if we increase the frequency of the
underlying cycle, we see that this property holds true:

.. plot:: ../plots/WEf.py
   :class: interactive

However, now let us consider the case where we use exactly the same
integration parameters but suppress events by using the ``noEvents``
operator as follows:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/Accuracy/WithNoEvents.mo
   :language: modelica
   :lines: 2-

In this case, the integrator is blind to the changes in behavior.  It
does its best to integrate accurately but without explicit knowledge of
where the behavior changes occur, it will blindly continue using the
wrong value of the derivative and extrapolate well beyond the change
in behavior.  If we simulate the ``WithNoEvents`` model, using the
same integrator settings, we can see how significantly different our
results will be:

.. plot:: ../plots/WNE.py
   :class: interactive

Note how quickly the integrator introduces some pretty significant
error.

.. plot:: ../plots/WNEf.py
   :class: interactive

The integration settings used in these examples were chosen to
demonstrate the impact that the ``noEvent`` operator can have on
accuracy.  However, the settings were admittedly chosen to accentuate
these differences.  Using more typical settings, the differences in
the results probably would not have been so dramatic.  Furthermore,
the impact of using ``noEvent`` are impossible to predict or quantify
since they will vary significantly from one solver to another.  But
the underlying point is clear, using the ``noEvent`` operator can have
a significant impact on accuracy simulation results.

.. [#tol] This model will not always fail.  The failure depends on how
	  much integration error is introduced and this, in turn,
	  depends on the numerical tolerances used.

.. [#Belmon] A special thanks to Lionel Belmon for challenging my
			 original discussion and identifying several
			 unsubstantiated assumptions on my part.  As a result,
			 this explanation is much better and includes results to
			 support the conclusions drawn.
