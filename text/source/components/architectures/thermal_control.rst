Thermal Control
---------------

In this chapter, we'll consider another system that includes a plant,
controller, sensor and actuator.  The application will be thermal
control of a three zone house.  The plant will be the house itself,
sensor will be a temperature sense and the actuator will be the furnace
in the house.  Using these models, we will explore a few different
control strategies.

We'll also follow the architecture driven approach to building the
system that we followed in the previous section.  However, we'll start
using one set of interfaces and then, after discussing their
limitations, restart taking a different approach that will provide us
with greater flexibility.

.. _initial-approach:

Initial Approach
^^^^^^^^^^^^^^^^

Architecture
~~~~~~~~~~~~

Let's start with the following architecture:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Architectures/BaseArchitecture.svg
   :width: 80%
   :align: center
   :alt: Initial architecture

Here we see the same basic pieces was saw in the previous section, a
plant model, a sensor, a controller and an actuator.  In fact, this is
a pretty typical architecture.  On some cases, people may break down
the plant model into a few subsystems and/or include multiple
controllers and control loops.  But many closed loop system control
problems have a similar structure.

What tends to change from application are the specific signals
exchanged between these parts.  In this case, we can see from the
architecture schematic that our interface definitions are such:

    * The actuator receives a commanded temperature and then injects
      heat through a thermal connection to the plant

    * The sensor model also has a thermal connector (to the plant) and
      an output signal containing the measured temperature.

    * The plant has two thermal connections.  One represents where the
      furnace heat is added to the system and the other is where the
      sensor is located.

    * The controller takes the measured temperature (from the sensor)
      as an input and outputs a commanded heat output (to the
      actuator)

The Modelica code for this base system looks like this:

.. literalinclude:: /ModelicaByExample/Architectures/ThermalControl/Architectures/BaseArchitecture.mo
   :language: modelica

Initial Implementations
^^^^^^^^^^^^^^^^^^^^^^^

Plant
~~~~~

Our plant model looks like this:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Implementations/ThreeZonePlantModel.svg
   :width: 100%
   :align: center
   :alt: Three zone plant model

Here we can see that the zone where furnace heat is added is separated
from the zone where the temperature is measured by a third zone.  Our
furnace model is a simple heat source:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Implementations/ConventionalActuator.svg
   :width: 100%
   :align: center
   :alt: A conventional actuator

This actuator takes a commanded heat level as an input and then
injects that amount of heat into the system.

The sensor is similarly simple:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Implementations/ConventionalSensor.svg
   :width: 100%
   :align: center
   :alt: A conventional sensor

This sensor doesn't introduce any artifact.  Instead, it provides the
exact temperature as a continuous signal.

We will use the following PI controller to control the temperature:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Implementations/ConventionalPIControl.svg
   :width: 100%
   :align: center
   :alt: The control system

Initial Results
^^^^^^^^^^^^^^^

Populating our architecture with these implementations, our model now
looks like this:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Examples/BaseModel.svg
   :width: 80%
   :align: center
   :alt: Initial system configuration

Note how the icons for the various subsystems have changed.  This is
because when we perform a ``redeclare``, the icon for the new type
associated with that subsystem is used.  The Modelica code for this
system is:

.. literalinclude:: /ModelicaByExample/Architectures/ThermalControl/Examples/BaseModel.mo
   :language: modelica

If we simulate this system, we get the following results:

.. plot:: ../plots/TCB.py
   :include-source: no

As we can see, this approach works very well.  The furnace heat
required to achieve this degree of control looks like this:

.. plot:: ../plots/TCBh.py
   :include-source: no

Bang Bang Control
^^^^^^^^^^^^^^^^^

So far, this approach seems like it has been quite successful.  We
have a nice architecture that we can use to consider different
actuators, sensors, controllers or even plant models.  The control
system we've developed seems to do a fairly good job of controlling
our plant.

But one thing worth noting is that the furnace heat required in this
case is continuous.  However, home heating systems do not typically
use this type of control strategy.  Instead, they tend to use
something called "bang-bang" control where the furnace is either "off"
or "on".

We have this flexible architecture, so perhaps to address this
situation, we should create an implementation of our controller and
actuator models where the controller command is a boolean indicating
whether the furnace should be on or off.  However, if we start this
process, we quickly run into the following problem:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Implementations/ConventionalOnOffControl.svg
   :width: 80%
   :align: center
   :alt: A control strategy with on/off control

Note that the output from our controller is ``Boolean`` value but the
commanded ``heat`` signal from our ``ControlSystem`` interface requires a
``Real`` value.  We have the same problem on the actuator side:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Implementations/ConventionOnOffActuator.svg
   :width: 80%
   :align: center
   :alt: 

The interface supplies an actuator that is a ``Real`` value but again
we see that if our furnace expects an "on" or "off" command, we have a
mismatch.

So the question then becomes, **how can we handle situations where
choosing different subsystems requires us to have different
interfaces**?

.. _expandable-approach:

Expandable Approach
^^^^^^^^^^^^^^^^^^^

.. index:: expandable connectors
.. index:: connectors; expandable

The solution to this problem is ``expandable`` connector definitions.
With this approach, our subsystem interface would be the same
regardless of whether the control strategy generates a ``Boolean`` or
``Real``.  What changes is the contents of the connector instances.

To understand how these ``expandable`` connectors work, we'll
reformulate our architecture to include ``expandable`` connectors and
then see how these can be used for both continuous and "bang-bang"
approaches.

Expandable Architecture
^^^^^^^^^^^^^^^^^^^^^^^

Expandable Implementations
^^^^^^^^^^^^^^^^^^^^^^^^^^

Results
^^^^^^^

Conclusion
^^^^^^^^^^


