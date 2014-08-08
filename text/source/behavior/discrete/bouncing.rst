
.. _bouncing-ball:

Bouncing Ball
-------------

Modeling a Bouncing Ball
^^^^^^^^^^^^^^^^^^^^^^^^

In the :ref:`previous example <cooling-revisited>`, we saw how some
events are related to time.  These so-called "time events" are just
one type of event.  In this section, we'll examine the other type of
event, the state event.  A state event is an event that depends on the
solution trajectory.

State events are much more complicated to handle.  Unlike time events,
where the time of the event is known *a priori*, a state event depends
on the solution trajectory.  So we cannot entirely avoid the
"searching" for the point at which the event occurs.

To see a state event in action, let us consider the behavior of a
bouncing ball bouncing on a flat horizontal surface.  When the ball is
above the surface, it accelerates due to gravitational forces.  When
the ball eventually comes in contact with the surface, it bounces off
the surface according to the following relationship:

.. math::

   v_\text{final} = -e v_\text{initial}

where :math:`v_\text{final}` is the (vertical) velocity of the ball
immediately after contact with the surface, :math:`v_\text{initial}` is the
velocity prior to contact and :math:`e` is the coefficient of
restitution, which is a measure of the fraction of momentum retained
by the ball after the collision.

Bringing all this together in Modelica might look something like this:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/BouncingBall/BouncingBall.mo
   :language: modelica
   :lines: 2-

In this example, we use the parameter ``h0`` to specify the initial
height of the ball off the surface and the parameter ``e`` to specify
the coefficient of restitution.  The variables ``h`` and ``v``
represent the height and vertical velocity, respectively.

What makes this example interesting are the equations.  Specifically,
the existence of a ``when`` statement:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/BouncingBall/BouncingBall.mo
   :language: modelica
   :emphasize-lines: 4-6
   :lines: 11-16

.. index: ! reinit

A ``when`` statement is composed of two parts.  The first part is a
conditional expression that indicates the moment the event takes
place.  In this case, the event will take place "when" the height,
``h``, first drops below ``0``.  The second part of the ``when``
statement is what happens when the event occurs.  In this case, the
value of ``v`` is re-initialized via the ``reinit`` operator.  The
``reinit`` operator allows us to specify a new initial condition for a
state.  Conceptually, you can think of ``reinit`` as being like an
``initial equation`` inserted in the middle of a simulation.  But it
only changes one variable and it always sets it explicitly (*i.e.,* it
isn't as flexible as an ``initial equation``).  In this case, the
``reinit`` statement will reinitialize the value of ``v`` to be in the
opposite direction of the value of ``v`` before the collision,
represented by ``pre(v)``, and scaled by the factor ``e``.

Assuming that ``h0`` has a positive value, the relentless pull of
gravity ensures that the ball will eventually hit the surface.
Running the simulation for the case where ``h0`` is 1.0, we see the
following behavior from this model:

.. plot:: ../plots/BB1.py
   :class: interactive

In this plot, we see that at around 0.48 seconds, the first impact
with the surface occurs.  This occurs because the condition ``h<0``
first becomes true at that moment.  Note that what makes this a state
event (unlike our example in :ref:`previous cooling examples
<cooling-revisited>`) is the fact that this conditional expression
references variables other than ``time``.

As such, the simulation proceeds assuming the ball is in free fall
until it identifies a solution trajectory where the value of the
conditional ``h<0`` changes during a time step.  When such a step
occurs, the solver must determine the precise time when the value of
the conditional expression becomes true.  Once that time has been
identified, it computes the state of the system at that time,
processes the statements within the ``when`` statement (*e.g.* any
``reinit`` statements) that affect the state of the system and then
**restarts** the integration starting from these computed states.  In
the case of the bouncing ball, the ``reinit`` statement is used to
compute a new post-collision value for ``v`` that sends the ball
(initially) upward again.

But it is important to keep in mind that, in general, the solutions
for most Modelica models are derived using numerical methods.  As we
shall see shortly, this has some profound implications when we
consider discrete behavior.  This is because at the heart of all
events (time or state events) are conditional expressions, like ``h<0``
from our current example.

The implications become clear if we simulation our bouncing ball a bit
longer.  In that case, most Modelica tools will provide a solution
like this:

.. plot:: ../plots/BB2.py
   :class: interactive

It should be immediately obvious when looking at this trajectory that
something has gone wrong.  But what?

Numerical Precision
^^^^^^^^^^^^^^^^^^^

The answer, as we hinted at before, lies in the numerical handling of
the when condition ``h<0``.  More specifically, what do we do if we
start a state extremely close to an event?  Because of numerical
imprecision, we do not know whether we are starting our step right
after an event has just occurred or whether we are starting a step
where an event is just about to occur.

To address this problem, we must introduce a certain amount of
hysteresis (dead-banding).  What this means in this case is that once the condition
``h<0`` has become true, we have to get "far enough" away from the
condition before we allow the event to happen again.  In other words,
the event happens whenever ``h`` is less than zero.  But before we can
trigger the event again we require that ``h`` must first become
greater than some :math:`\epsilon`.  In other words, it is not simply
enough that `h` becomes greater than zero, `h` must become greater
than :math:`\epsilon` (where :math:`\epsilon` is determined by the
solver by examining various scaling factors).

The problem in the previous simulations is that each time the ball
bounces, the peak value of `h` goes down a little bit.  By peak value,
we mean the value of `h` when the ball first begins to fall again.
Eventually, the peak value of `h` isn't enough to exceed the critical
value of :math:`\epsilon`.  This, in turn, means that the ``when``
statement never fires and the ``reinit`` statement will never again
reset ``v``.  As a result, the ball continues, indefinitely, in free fall.

So this raises the obvious question of how to achieve the behavior we
truly intended (which is that the ball never drops below the
surface).  For that, we have to make a few minor changes to our model
as follows:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/BouncingBall/StableBouncingBall.mo
   :language: modelica
   :emphasize-lines: 17-20
   :lines: 2-

It should be noted that there are many ways to solve this problem.
The solution presented here is only one of them.  In this approach, we
have effectively created two surfaces.  One at a height of ``0`` and the
other at a height of ``-eps`` (just below ``0``).  When the ball is
bouncing "normally" it will only trigger the first condition in our
``when`` statement.  If, however, the ball does not rebound high enough
after contact and "falls through" the first surface, we detect that
(and the fact that it has fallen through) and set the ``done`` flag.
The effect of the ``done`` flag is to effectively turn off gravity.

Note the syntax of the ``when`` statement in this case:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/BouncingBall/StableBouncingBall.mo
   :language: modelica
   :lines: 18-21

In particular, note that it doesn't have just one conditional
expression, **but two**.  More specifically, it actually has a vector
of conditional expressions.  We'll introduce :ref:`vectors-and-arrays`
later in the book, but for now it is just important to point out that
in this chapter we have shown that a `when` can include either a
scalar conditional expression or a vector of conditional expressions.

If a ``when`` statement includes a vector of conditionals, then the
statements of the when statement will be triggered when **any**
conditional expression in the vector **becomes true**.  Note the
grammar of this explanation carefully.  It is very common for people
to read Modelica code like this:

.. code-block:: modelica

    when {a>0, b>0} then
      ...
    end when;

as "when a is greater than zero **or** b is greater than zero".  But
it is **very important** not to make the very common mistake of
misinterpreting this to mean that the following two ``when``
statements are equivalent:

.. code-block:: modelica

    when {a>0, b>0} then
      ...
    end when;

    when a>0 or b>0 then
      ...
    end when;

**These are not equivalent**.  To understand the difference, let's
change the conditional expressions as follows:

.. code-block:: modelica

    when {time>1, time>2} then
      ...
    end when;

    when time>1 or time>2 then
      ...
    end when;

Remember our original statement that the vector notation for ``when``
statements means that the statements in the when statement are
triggered when **any** condition becomes true.  Assuming we run a
simulation that starts at ``time=0`` and runs until ``time=3``, then
the ``when`` statement:

.. code-block:: modelica

    when {time>1, time>2} then
      ...
    end when;

will be triggered **twice**.  Once when ``time>1`` becomes true and
the other when ``time>2`` becomes true.  In contrast, in this case:

.. code-block:: modelica

    when time>1 or time>2 then
      ...
    end when;

there is only a **single** conditional expression and it becomes true
**only once** (when ``time>1`` becomes true...and stays true).  The
``or`` operator essentially masks the second conditional, ``time>2``,
such that it may as well not even be present in this particular case.
In other words, this conditional only **becomes true** once.  As a
result, the statements inside the ``when`` statement are only
triggered once.

The key thing to remember is that for ``when`` statements, a vector of
conditionals means **any, not or**.  Furthermore, the statements are
only active at the instant when the conditional **becomes true**.  The
implications of this last statement will be discussed in greater
details later in this chapter when we talk about the important
differences between :ref:`if-vs-when`.
