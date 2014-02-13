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

.. image:: /ModelicaByExample/Architectures/ThermalControl/ArchitecturesBaseArchitecture.svg
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

Initial Results
^^^^^^^^^^^^^^^

.. _expandable-approach:

Expandable Approach
^^^^^^^^^^^^^^^^^^^

Expandable Architecture
^^^^^^^^^^^^^^^^^^^^^^^

Expandable Implementations
^^^^^^^^^^^^^^^^^^^^^^^^^^

Results
^^^^^^^

Conclusion
^^^^^^^^^^


