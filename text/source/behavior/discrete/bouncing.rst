
.. _bouncing-ball:

Bouncing Ball
-------------

In the :ref:`previous example <cooling-revisited>`, we saw how some
events are related to time.  These so-called "time events" are just
one type of event.  In this section, we'll examine the other type of
event, the state event.  A state event is an event that depends on the
solution trajectory.

State events are much more complicated to handle.  Unlike time events,
where the time of the event is known *a priori*, a state event depends
on the solution trajectory.  So we cannot entirely avoid the
"searching" for the point at which the event occurs.  

To see a state even in action, let us consider the behavior of a
bouncing ball bouncing on a flat horizontal surface.  When the ball is
above the surface, it accelerates due to gravitational forces.  When
the ball eventually comes in contact with the surface, it bounces off
the surface according to the following relationship:

$$v_{final} = \epsilon v_{initial}$$

where $v_{final}$ is the (vertical) velocity of the ball immediately
after contact with the surface, $v_{initial}$ is the velocity prior to
contact and $\epsilon$ is the "coefficient of restitution" which is a
measure of the fraction of momentum retained by the ball after the
collision.

Bringing all this together in Modelica might look something like this:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/BouncingBall/BouncingBall.mo
   :language: modelica
   :lines: 2-

In this example, we use the parameter ``h0`` to specify the initial
height of the ball off the surface and the parameter ``e`` to specify
the coefficient of restitution.  The variables ``h`` and ``v``
represent the height and vertical velocity, respectively.

What makes this example interesting is the equations.  Specifically,
the existence of a ``when`` clause:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/BouncingBall/BouncingBall.mo
   :language: modelica
   :emphasize-lines: 14-16
   :lines: 11-16

.. index: ! reinit

A ``when`` clause is composed of two parts.  The first part is a
conditional expression that indicates the moment the event takes
place.  In this case, the event will take place "when" the height,
``h``, first drops below ``0``.  The second part of the ``when``
clause is what happens when the event occurs.  In this case, the value
of ``v`` is re-initialized via the ``reinit`` operator.  The
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
   :include-source: no

In this plot, we see that at around 0.48 seconds, the first impact with the
surface occurs.  This occurs because the condition ``h<0`` first becomes
true at that moment.  Note that what makes this a state event (unlike
our example in `cooling-revisited <previous cooling examples>` is the
fact that this conditional expression references continuous variables
other than ``time``.

As such, the simulation proceeds assuming the ball is in free fall
until it identifies a solution trajectory where the value of the
conditional ``h<0`` changes during a time step.  When such a step
occurs, the solver must determine the precise time when the value of
the conditional expression becomes true.  Once that time has been
identified, it computes the state of the system at that time,
processes the statements within the ``when`` clause (*e.g.* any ``reinit``
statements) that affect the state of the system and then **restarts**
the integration starting from these computed states.  In the case of
the bouncing ball, the ``reinit`` clause is used to compute a new
post-collision value for ``v`` that sends the ball (initially) upward
again.

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
   :include-source: no

It should be immediately obvious when looking at this trajectory that
something has gone wrong.
