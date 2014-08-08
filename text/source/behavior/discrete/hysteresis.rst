.. _hysteresis:

Hysteresis
----------

In this section, we'll discuss the topic of hysteresis.  This is an
important concept to understand for certain types of modeling.  Recall
in our previous discussion of :ref:`state-events` we saw cases where
chattering occurred.  In those cases, we were able to use the
``noEvent`` operator to address the issue because the chattering was
purely a response to numerical noise and not triggered by abrupt
changes in behavior.

In this section, we will consider a slightly more extreme case.
Consider the following model:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/Hysteresis/ChatteringControl.mo
   :language: modelica
   :lines: 2-

If we simulate this model, we get the following results:

.. plot:: ../plots/CC1.py
   :class: interactive

However, the simulation that yields these results takes a very long
time to complete.  The reason for such poor simulation performance can
be better understood by looking at the heater output during the
simulation:

.. plot:: ../plots/CC1_Q.py
   :class: interactive

What you see is that after around 0.2 seconds, the heater is
constantly turning on and off.  This happens so frequently, in fact,
that you would have to zoom in quite a bit on the plot to see the
transitions.  With normal scaling, there are so many transitions that
the results resemble a filled rectangle.

This is actually a real problem in control systems.  If you look
carefully at the way the furnace works in your own home, you will see
that it does not turn on and off constantly as the temperature goes
above and below the desired room temperature you have specified.
Instead, it waits until the temperature gets some specified amount
above or below the desired temperature before acting.

This "band" that is introduced around the desired temperature is
called hysteresis.  The problem with the ``ChatteringControl``
model is that it doesn't have any hysteresis.  Instead, it is
constantly turning the heater off and on in response to miniscule
changes in temperature.

The tricky thing about modeling hysteresis is that it is "stateful".
Determining the behavior of the system depends on what happened in the
past.  For this reason, we cannot simply use ``if`` statements.  The
reason is that ``if`` statements consider only the current state of
the system, nothing else.  To implement hysteresis, we need to use
``when`` statements.  Consider the following model:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/Hysteresis/HysteresisControl.mo
   :language: modelica
   :lines: 2-

Examining the ``when`` statements, we see that the system only responds
when ``T>Tbar+1`` becomes true or ``T<Tbar-1`` becomes true.  **Note
that nothing happens when these expressions become false**.  This is
why an ``if`` statement won't work.  With an ``if`` statement or
``if`` expression, the behavior changes whenever the conditional
expression changes.  But with a ``when`` statement, the statements in the
``when`` statement become active **only** when the condition becomes
true.  If we simulate this model and look at the temperature, we see
that it stays within the hysteresis band of our desired temperature.

.. plot:: ../plots/Hyst.py
   :class: interactive

More importantly, if we look at the heat output from the system, we
see that, unlike our previous example, some time elapses between the
heater turning on and the heater turning off.

.. plot:: ../plots/Hyst_Q.py
   :class: interactive

The logic for implementing hysteresis can be made slightly more
explicit by using an ``algorithm`` section (as previous discussed
during our discussion on :ref:`speed estimation techniques
<pulse-counting>`).

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/Hysteresis/HysteresisControlWithAlgorithms.mo
   :language: modelica
   :emphasize-lines: 21-27
   :lines: 2-

Note how the two conditional expressions have been broken into two
separate ``when`` statements.  This makes it explicitly clear what
causes the heat to be turned on and off.  These ``when`` statements
were placed in an ``algorithm`` section because they both assign to
the same variable, ``heat``.
