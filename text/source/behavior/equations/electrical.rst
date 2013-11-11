.. _elec-example:

An Electrical Example
---------------------

Let us return now to an engineering context.  For readers who are more
familiar with electrical systems, here is a simple example of an
electrical circuit.  Consider the following circuit:

.. todo:: 

   Need to add a figure here.

As we can see from this figure, we have four variables to solve for:
:math:`V`, :math:`i_L`, :math:`i_R` and :math:`i_C`.  To solve for
each of the currents :math:`i_L`, :math:`i_R` and :math:`i_C`, we can
use the equations associated an inductor, resistor and capacitor,
respectively:

.. math:: V = i_R R
.. math:: C \frac{dV}{dt} = i_C
.. math:: L \frac{di_L}{dt} = (V_b-V)

where :math:`V_b` is the battery voltage.  Since we have only 3
equations but 4 variables, we need one additional equation.  That
additional equation is going to be Kirchoff's current law:

.. math:: i_L = i_R+i_C

Now that we have determined the equations and variables for this
problem, we will create a basic model (including physical types) by
translating the equations directly into Modelica.  But in a later
section on :ref:`electrical-components` we will return to this same
circuit and demonstrate how to create models by dragging, dropping and
connecting models that really look like the circuit components in the
previous figure.

A model composed simply of variables and equations could be written as
follows:

.. literalinclude:: /ModelicaByExample/BasicEquations/RLC/RLC1.mo
   :language: modelica
   :lines: 2-

Let's go through this example bit by bit and reinforce the meaning of
the various statements.  Let's start at the top:

.. literalinclude:: /ModelicaByExample/BasicEquations/RLC/RLC1.mo
   :language: modelica
   :lines: 2-2

Here we see that the name of the model is ``RLC``.  Furthermore, a
description of this model has been included, namely ``"A
resistor-inductor-capacitor circuit model"``.  Next, we introduce a
few physical types that we will need:

.. literalinclude:: /ModelicaByExample/BasicEquations/RLC/RLC1.mo
   :language: modelica
   :lines: 3-7

Each of these lines introduces a physical type that specializes the
built-in ``Real`` type by associating it with a particular physical
unit.  Then, we declare all of the ``parameter`` variables in our
problem:

.. literalinclude:: /ModelicaByExample/BasicEquations/RLC/RLC1.mo
   :language: modelica
   :lines: 8-11

These ``parameter`` variables represent various physical
characteristics (in this case, voltage, inductance, resistance and
capacitance, respectively).  The last variables we need to define are
the ones we wish to solve for, *i.e.*,

.. literalinclude:: /ModelicaByExample/BasicEquations/RLC/RLC1.mo
   :language: modelica
   :lines: 12-15

Now that all the variables have been declared, we add an ``equation``
section to the model that specifies the equations to use when
generating solutions for this model:

.. literalinclude:: /ModelicaByExample/BasicEquations/RLC/RLC1.mo
   :language: modelica
   :lines: 16-20

Finally, we close the model by creating an ``end`` statement that
includes the ``model`` name (*i.e.*, ``RLC`` in this case):

.. literalinclude:: /ModelicaByExample/BasicEquations/RLC/RLC1.mo
   :language: modelica
   :lines: 21-21

.. index:: state-space form

One thing that distinguishes this example from the previous examples
is the fact that it contains more equations.  As with the
``NewtonCooling`` example, we have some equations with expressions on
both the left and right hand sides.  We have some equations that
involve derivatives while others do not.  This further emphasizes the
point that in Modelica it is not necessary to put the system of
equations into the so-called "explicit state-space form" required in
some modeling environments.  We could, of course, rearrange the
equations into a more explicit form, *e.g.*,

.. literalinclude:: /ModelicaByExample/BasicEquations/RLC/RLC2.mo
   :language: modelica
   :lines: 17-20

But the important point is that with Modelica, we do not need to
perform such manipulations.  Instead, we are free to write the
equations in whatever form we chose.  If such manipulations are
necessary in order to solve these equations, it is the tools
responsibility to perform these manipulations, not the model
developer.

This is important because, as we will show in later sections, we
eventually want to get to the point where these equations are
"captured" in individual components models.  In those cases, we won't
know (when we create the component model) exactly what variable each
equation will be used to solve for.  Making such manipulations the
responsibility of the Modelica compiler not only makes the model
development simpler, but it dramatically improves the **reusability**
of the models.

The following figure shows the dynamic response of the ``RLC1`` model:

.. plot:: ../plots/RLC1.py
   :include-source: no

.. todo::

Add some kind of "aside" here or something to indicate that this is an
alternative path through the book

To see this model extended to include more complex behavior, you may
want to skip ahead to our :ref:`switched-rlc` example.

