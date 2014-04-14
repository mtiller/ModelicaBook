.. _electrical-components:

Electrical Components
---------------------

The previous section discussed how to create component models in the
heat transfer domain.  Now let's turn our attention to how to
construct some basic electrical components and then use them to
simulate the kinds of systems we saw in our previous :ref:`electrical
example <elec-example>`.

In this section we will implement the basic electrical component
models **twice**.  The first time through, we will implement each
component without any regard to the others.  But the second time
through, we'll see how we can use the inheritance mechanism in
Modelica to make our lives a little easier.

But in both cases, we'll use the same connector definitions.  In our
discussion of :ref:`simple-domains`, we saw how to construct an
electrical connector.  As with the previous section on heat transfer,
the examples in this section will rely on the connector definitions
from the Modelica Standard Library.  Those connector definitions look
like this:

.. code-block:: modelica

    connector PositivePin "Positive pin of an electric component"
      Modelica.SIunits.Voltage v "Potential at the pin";
      flow Modelica.SIunits.Current i "Current flowing into the pin";
    end PositivePin;

    connector NegativePin "Negative pin of an electric component"
      Modelica.SIunits.Voltage v "Potential at the pin";
      flow Modelica.SIunits.Current i "Current flowing into the pin";
    end NegativePin;

Basic Component Models
^^^^^^^^^^^^^^^^^^^^^^

Given these ``connector`` definitions, it is relatively
straightforward to construct a resistor model.  The goal of a resistor
model is to encapsulate the relationship between the voltage across
the resistor and the current through the resistor using Ohm's law.
The following model represents how one might expect such a resistor
model to look:

.. literalinclude:: /ModelicaByExample/Components/Electrical/VerboseApproach/Resistor.mo
   :language: modelica
   :lines: 1-12,31
   :emphasize-lines: 4-11

In the same way, we might create inductor and capacitor models as
follows:

.. literalinclude:: /ModelicaByExample/Components/Electrical/VerboseApproach/Inductor.mo
   :language: modelica
   :lines: 1-12,37
   :emphasize-lines: 4-11

.. literalinclude:: /ModelicaByExample/Components/Electrical/VerboseApproach/Capacitor.mo
   :language: modelica
   :lines: 1-12,36
   :emphasize-lines: 4-11

The important thing to notice about these models is the amount of
common code shared between them.  In software development, this kind
of redundancy is frowned upon.  In fact, a common software maxim is
"Redundancy is the root of all evil".  The reason this redundancy is a
problem is partly because you are doing the same work multiple times,
but also because this code needs to be *maintained* as well.  When you
repeat code and then find a mistake in that code, you have to fix it
everywhere.

.. _dry-principle:

The DRY Principle
^^^^^^^^^^^^^^^^^

This issue of redundancy is an important one.  So let's revisit
building models of resistors, inductors and capacitors with the goal
of reducing the amount of repeated code.  In software, there is
something called the *DRY principle* where DRY stands for "Don't
Repeat Yourself".  So our next step is to make our resistor,
capacitor and inductor models DRY.

.. index:: partial

The key to eliminating redundant code is to identify all the common
code between these models and create a ``partial`` model that we can
inherit from.  We highlighted the common lines previously.  Now we can
capture them in their own model as follows:

.. literalinclude:: /ModelicaByExample/Components/Electrical/DryApproach/TwoPin.mo
   :language: modelica
   :lines: 1-11,19

In summary, we've extracted the declarations for ``p``, ``n`` and
``v`` from the previous models into this model.  We've also included a
variable, ``i``, to represent the current flowing from pin ``p`` to
pin ``n``.  Finally, the conservation of charge equation is also
included.

Creating such a model then allows us to create a much more succinct
resistor model as follows:

.. literalinclude:: /ModelicaByExample/Components/Electrical/DryApproach/Resistor.mo
   :language: modelica
   :lines: 1-6,19

There are several things to notice about this ``Resistor`` model.  The
first is how much shorter it is.  This is because we inherit the
electrical pins, the conservation of charge equation and the variables
``v`` and ``i`` from the ``TwoPin`` model.  Another thing to notice is
that, by leverage the definitions of ``v`` and ``i``, Ohm's law looks
just like it would if you saw it in a text book.

We can give the same treatment to our inductor and capacitor models:

.. literalinclude:: /ModelicaByExample/Components/Electrical/DryApproach/Capacitor.mo
   :language: modelica
   :lines: 1-6,24

.. literalinclude:: /ModelicaByExample/Components/Electrical/DryApproach/Inductor.mo
   :language: modelica
   :lines: 1-6,25

Again, we see that the models are much more succinct.  Ultimately,
factoring out common code in this way means that the component models
are easier to write and easier to maintain.

Circuit Model
^^^^^^^^^^^^^

So far, we've only built component models.  In order to create a
circuit model we first need to define a few more component models.
Specifically, we need to create a step voltage source model:

.. literalinclude:: /ModelicaByExample/Components/Electrical/DryApproach/StepVoltage.mo
   :language: modelica
   :lines: 1-6,25

Note how the ``StepVoltage`` model also leverages the ``TwoPin``
model.  We will also need a ground model which we model as follows:

.. literalinclude:: /ModelicaByExample/Components/Electrical/DryApproach/Ground.mo
   :language: modelica
   :lines: 1-6,37

The ``Ground`` model has only one pin so it cannot inherit from
``TwoPin``.  Recall how we described the :ref:`amb-cond` model from
our discussion on :ref:`heat-transfer-components` an infinite
reservoir.  The ``Ground`` model serves a very similar purpose.  No
matter how much current flows in to or out of an electrical ground,
the voltage remains zero.

Having defined all these components, we can now create a circuit model
as follows:

.. literalinclude:: /ModelicaByExample/Components/Electrical/Examples/SwitchedRLC.mo
   :language: modelica

The schematic diagram for this model is rendered as:

.. image:: /ModelicaByExample/Components/Electrical/Examples/SwitchedRLC.*
   :width: 100%
   :align: center
   :alt: Modeling the step response of an RLC circuit

