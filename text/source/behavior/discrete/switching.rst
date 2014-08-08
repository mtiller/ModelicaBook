.. _switched-rlc:

Switched RLC Circuit
--------------------

In this section, we'll present another model, like the heat transfer
model presented :ref:`earlier in this chapter <cooling-revisited>`,
that contains time events.  In this case, we'll show how we can
simulate the behavior of a switch in the context of an RLC circuit
like :ref:`the one presented in the first chapter <elec-example>`.
From the examples presented so far, nothing in this model should come
as a surprise.  The main motivation for this example is simply to
present time events in the context of an electrical model.

Our switched RLC circuit model is as follows:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/SwitchedRLC/SwitchedRLC.mo
   :language: modelica
   :lines: 2-

The time event in this model is introduced via an ``if`` expression.
The fact that the only time-varying variable in the conditional
expression is ``time`` means that this will trigger a time event and
that the underlying numerical solver will be able to determine *a
priori* when the event will occur while integrating the underlying
equations.

We can see the voltage response of this model to the switched supply
voltage in the following plot:

.. plot:: ../plots/SRLCv.py
   :class: interactive

Furthermore, we can see the current response for inductor, resistor
and capacitor components in this plot:

.. plot:: ../plots/SRLCi.py
   :class: interactive

Hopefully by this point, the basic mechanisms for generating events
and disturbances seem intuitive and familiar.
