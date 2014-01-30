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

The DRY Principle
^^^^^^^^^^^^^^^^^

