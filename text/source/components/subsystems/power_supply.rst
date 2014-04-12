DC Power Supply
---------------

In this section, we'll consider how a DC power supply model could be
implemented in Modelica.  We'll show, once again, how a flat system
model can be refactored to make use of a reusable subsystem model.

Flat Power Supply Model
^^^^^^^^^^^^^^^^^^^^^^^

In this case, our flat system model will be the DC power supply
circuit shown here:

.. image:: /ModelicaByExample/Subsystems/PowerSupply/Examples/FlatCircuit.*
   :width: 100%
   :align: center
   :alt: Flat switching power supply model

Implemented in Modelica, this model looks like this:

.. literalinclude:: /ModelicaByExample/Subsystems/PowerSupply/Examples/FlatCircuit.mo
   :language: modelica

This kind of power supply works by taking an AC input voltage (120V at
60Hz), rectifying it and then passing it through a low-pass filter.
If we simulate this model, we see the following voltage across the
``load`` resistor:

.. plot:: ../plots/FC.py
   :class: interactive

Note that our target here is an output voltage of 12 volts.  However,
the greater the load on the power supply, the lower the quality of the
output signal will be.  In this particular simulation, the load is
initially zero (because the load connecting the switch to the power
supply is open).  But when the switch is closed and current begins to
flow through the load (the resistor named ``load``), we start to see
some artifact.

Hierarchical Power Supply
^^^^^^^^^^^^^^^^^^^^^^^^^

Once again, we'll improve upon the flat version of our system by
taking some collection of components and organizing them into a
subsystem model.  Our system level circuit then becomes:

.. image:: /ModelicaByExample/Subsystems/PowerSupply/Examples/SubsystemCircuit.*
   :width: 100%
   :align: center
   :alt: Hierarchical power supply model

This model uses the ``BasicPowerSupply`` model whose diagram is shown here:

.. image:: /ModelicaByExample/Subsystems/PowerSupply/Components/BasicPowerSupply.*
   :width: 100%
   :align: center
   :alt: Reusable power supply subsystem model

The Modelica source code for this reusable power supply subsystem
model is:

.. literalinclude:: /ModelicaByExample/Subsystems/PowerSupply/Components/BasicPowerSupply.mo
   :language: modelica

There are a couple of interesting things to note about this model.
First, we see the same organizational structure as we have before
where parameters and connectors are made ``public`` while the internal
components are ``protected``.  We can also see the use of the
:ref:`dialog-anno` annotation to organize parameters into distinct
groupings (in this case, ``"General"`` and ``"Transformer"``).  We can
also see the use of the ``enable`` annotation in conjunction with
``considerMagnetization`` parameter to selectively expose the ``Lm1``
parameter only in the cases where ``considerMagnetization`` is true.

Using our hierarchical system model we get, as expected, exactly the
same results as we got for the flat version:

.. plot:: ../plots/SSC.py
   :class: interactive

We can augment our system model to include an additional load (that
comes online after some delay):

.. image:: /ModelicaByExample/Subsystems/PowerSupply/Examples/AdditionalLoad.*
   :width: 100%
   :align: center
   :alt: Flat switching power supply model

In that case, if we simulate the model we can see the impact that
additional load will have on the quality of power supply output:

.. plot:: ../plots/SSC_AL.py
   :class: interactive

By increasing the capacitance in the power supply, we can reduce the
amplitude of the voltage fluctuations, *e.g.,*

.. plot:: ../plots/SSC_ALC.py
   :class: interactive

However, if we increase the capacitance level too much, we will find
that the power supply output is very slow to respond to load changes,
*e.g.,*

.. plot:: ../plots/SSC_ALC2.py
   :class: interactive

Conclusion
^^^^^^^^^^

This example illustrates, once again, how a collection of components
can be organized into a reusable subsystem model.  This example
follows the best practice of placing parameters and connectors in the
``public`` section of the resulting subsystem model while keeping the
internal components in the ``protected`` section.
