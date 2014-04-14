.. _thermal-control:

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

.. image:: /ModelicaByExample/Architectures/ThermalControl/Architectures/BaseArchitecture.*
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

.. image:: /ModelicaByExample/Architectures/ThermalControl/Implementations/ThreeZonePlantModel.*
   :width: 100%
   :align: center
   :alt: Three zone plant model

Here we can see that the zone where furnace heat is added is separated
from the zone where the temperature is measured by a third zone.  Our
furnace model is a simple heat source:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Implementations/ConventionalActuator.*
   :width: 100%
   :align: center
   :alt: A conventional actuator

This actuator takes a commanded heat level as an input and then
injects that amount of heat into the system.

The sensor is similarly simple:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Implementations/ConventionalSensor.*
   :width: 100%
   :align: center
   :alt: A conventional sensor

This sensor doesn't introduce any artifact.  Instead, it provides the
exact temperature as a continuous signal.

We will use the following PI controller to control the temperature:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Implementations/ConventionalPIControl.*
   :width: 100%
   :align: center
   :alt: The control system

Initial Results
^^^^^^^^^^^^^^^

Populating our architecture with these implementations, our model now
looks like this:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Examples/BaseModel.*
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
   :class: interactive

As we can see, this approach works very well.  The furnace heat
required to achieve this degree of control looks like this:

.. plot:: ../plots/TCBh.py
   :class: interactive

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

.. image:: /ModelicaByExample/Architectures/ThermalControl/Implementations/ConventionalOnOffControl.*
   :width: 80%
   :align: center
   :alt: A control strategy with on/off control

Note that the output from our controller is ``Boolean`` value but the
commanded ``heat`` signal from our ``ControlSystem`` interface requires a
``Real`` value.  We have the same problem on the actuator side:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Implementations/ConventionOnOffActuator.*
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

Expandable Connectors
^^^^^^^^^^^^^^^^^^^^^

The key feature that allows us to make more flexible architectures is
the ``expandable connector``.  For example, previously we defined the
``Actuator`` interface as:

.. literalinclude:: /ModelicaByExample/Architectures/ThermalControl/Interfaces/Actuator.mo
   :language: modelica

This interface contains two connectors, the ``heat`` connector and the
``furnace`` connector.  The ``furnace`` connector is a thermal
connector that allows the furnace to interact thermally with the
plant.  The ``heat`` connector is a ``Real`` valued input signal that
comes from the controller and specifies the desired heat output level.
The fact that this is a ``Real`` valued signal was the problem when we
wanted to switch to a type of control that required a ``Boolean``
signal.  To address this, we'll use the following interface definition
for our actuators:

.. literalinclude:: /ModelicaByExample/Architectures/ThermalControl/Interfaces/Actuator_WithExpandableBus.mo
   :language: modelica

Here we see the ``furnace`` connector is still present.  But the
``heat`` connector is gone.  Instead, it has been replaced by a new
connector instance, ``bus``, of type ``ExpandableBus``.  The connector
definition for ``ExpandableBus`` is:

.. literalinclude:: /ModelicaByExample/Architectures/ThermalControl/Interfaces/ExpandableBus.mo
   :language: modelica
   :lines: 1-2,38

In other words, **it is empty**.  But what is significant is the
presence of the ``expandable`` qualifier.  If a given bus is required
to always have certain signals, they should be listed within the
connector definition.  But the fact that there are no variables or
sub-connectors listed in the ``ExpandableBus`` class means there is no
minimum requirement for information to be carried on the bus.  But the
bus can be **expanded** to include additional information.

Of course, we could use inheritance to add new signals.  But that
introduces a new type.  The types of connectors are fixed by the type
used in the interface definition.  So creating richer connectors via
inheritance doesn't really help.

.. index:: bus

Note that there is no formal definition of a "bus" in Modelica.  The
term is often used in such contexts to connote a connector that is
carrying multiple pieces of information.

Expandable connectors work in a special way.  The signals on an
expandable bus **are determined by the connections themselves**.  By
connecting something to the expandable bus, a signal is implicitly
added to that connector.  Then the Modelica compiler looks at all the
connectors in a connection set and expands each one so that they
match.  We'll go into more details about this process once we get to
the point where we have some implementation models to discuss.

The interface for the plant model is unaffected by the use of
``expandable`` connectors, but the interfaces for the sensor and
controller are as follows:

.. literalinclude:: /ModelicaByExample/Architectures/ThermalControl/Interfaces/Sensor_WithExpandableBus.mo
   :language: modelica

.. literalinclude:: /ModelicaByExample/Architectures/ThermalControl/Interfaces/ControlSystem_WithExpandableBus.mo
   :language: modelica

Note how simple the controller interface has become.  This is because
with an ``expandable`` connector, we can put the temperature
measurement received from the sensor and the heat command sent to the
actuator **on the same bus**.  As such, we only need one connector.  A
developer may still choose to use multiple buses simply to organize
signals, to make them more representative of the physical partitioning
or to avoid confusion.  Here we will use a single connector simply to
demonstrate that this is now possible.

Using expandable connectors, we can create the following revised
architecture:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Architectures/ExpandableArchitecture.*
   :width: 80%
   :align: center
   :alt: Expandable architecture

Expandable Implementations
^^^^^^^^^^^^^^^^^^^^^^^^^^

With this more flexible architecture, let's first recreate our
original configuration with the continuous control system:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Examples/ExpandableModel.*
   :width: 80%
   :align: center
   :alt: Continuous control using the expandable architecture

If we plot the results from this system, we get the following
response:

.. plot:: ../plots/TCE.py
   :class: interactive

Note that the measured temperature corresponds to the signal
``controller.bus.temp`` where ``bus`` is an instance of the expandable
connector.  Further recall that the ``ExpandableBus`` definition
**didn't contain a signal called** ``temperature``.  So the question
is, how did it get on the connector.  The answer lies in the
implementation of the sensor model.  The diagram for the sensor model
looks like this:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Implementations/TemperatureSensor.*
   :width: 100%
   :align: center
   :alt: Temperature sensor model using expandable bus

The corresponding Modelica code is:

.. literalinclude:: /ModelicaByExample/Architectures/ThermalControl/Implementations/TemperatureSensor.mo
   :language: modelica
   :lines: 1-15,48
   :emphasize-lines: 8

Of particular importance is the highlighted line.

In the diagram, we can see that the output signal from the temperature
sensor component is connected to the bus.  But when we look at the
``connect`` statement, it is more than just connected to the bus.  It
is connected to something named ``temperature`` inside the bus.  This
``temperature`` connector doesn't exist in the definition of
``ExpandableBus``. Instead, **it is created by the** ``connect``
**statement itself**!  This is precisely what the ``expandable``
qualifier allows.

.. index:: expandable; caveats

In general, we don't want all connectors to be ``expandable``.  In
cases where we know *a priori* the names and types of all signals, it
is better to list them explicitly.  This allows the Modelica compiler
to make several important checks to ensure the correctness of the
model.  It is worth noting that by adding the ``expandable`` qualifier
on a connector, the risk of accidentally creating an unintended signal
(*e.g.,* as a result of a typing error) becomes a possibility that
would otherwise be caught by the compiler.

Reconfiguration
^^^^^^^^^^^^^^^

Now that we've shown that we can use the expandable approach to model
the continuous control version of our system, let's return our
attention to the "bang-bang" version.

We've already seen the temperature sensor subsystem configured to work
with the expandable connector.  What remains is the controller and
actuator models.  The actuator model diagram looks like this:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Implementations/OnOffActuator.*
   :width: 80%
   :align: center
   :alt: Actuator attached via expandable connector

Again, looking at the Modelica code is important to see how the
signals on the ``bus`` connector are referenced:

.. literalinclude:: /ModelicaByExample/Architectures/ThermalControl/Implementations/OnOffActuator.mo
   :language: modelica
   :lines: 1-20,68
   :emphasize-lines: 18

Again, note the emphasized line.  It references something called
``heat_command`` on the ``bus`` connector.  Again, that signal doesn't
exist in the definition of ``ExpandableBus``, but it is implicitly
created simply because it is referenced in the highlighted ``connect``
statement.

From the sensor model, we see that the measured temperature is added
to the ``bus`` connector as a ``Real`` signal named ``temperature``.
From the actuator model, we see that the command expected by the
actuator from the controller is a ``Boolean`` signal named
``heat_command``.  As such, we should expect to see both of these
signals used by the controller model.  The diagram for the controller
looks like this:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Implementations/ExpandablePIControl.*
   :width: 80%
   :align: center
   :alt: PI controller connected to expandable bus

But the diagram doesn't include sufficient detail to know the precise
names of the signals being referenced on the ``bus`` connector.  For
that, we need to look at the actual source code:

.. literalinclude:: /ModelicaByExample/Architectures/ThermalControl/Implementations/ExpandablePIControl.mo
   :language: modelica
   :lines: 1-29,39
   :emphasize-lines: 24,27

Again, note the highlighted lines.  Not only do these ``connect``
statements implicitly add the ``heat_command`` and ``temperature``
signals to the ``bus`` connector, **those names match** the names that
the sensor and actuator models expect.

Pulling all of these subsystems together, we get the following diagram
for our system:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Examples/OnOffVariant.*
   :width: 80%
   :align: center
   :alt: System using bang-bang control

The source code for our system model is quite simple:

.. literalinclude:: /ModelicaByExample/Architectures/ThermalControl/Examples/OnOffVariant.mo
   :language: modelica

.. plot:: ../plots/TCE_BB.py
   :class: interactive

However, there is still one remaining issue with these models and it
can be seen more clearly if we look at the duty cycle of the furnace:

.. plot:: ../plots/TCE_BBh.py
   :class: interactive

This is exactly the same issue we demonstrated in the previous section
on :ref:`hysteresis`.  It is precisely the fact that our control
strategy lacks any hysteresis that we see the furnace constantly
turning on and off.  If we add hysteresis, our controller model
becomes:

.. image:: /ModelicaByExample/Architectures/ThermalControl/Implementations/OnOffControl_WithHysteresis.*
   :width: 80%
   :align: center
   :alt: Bang-bang controller with hysteresis

Nothing else has changed.  We will use the same sensor and actuator
models and we still use the same bus signals since this is still a
bang-bang controller.  So the only change to our system level model
(compared to the ``OnOffVariant`` model) is the use of a different
controller model.  As we can see, these configuration management
features in Modelica do a nice job of conveying that in our system
level model:

.. literalinclude:: /ModelicaByExample/Architectures/ThermalControl/Examples/HysteresisVariant.mo
   :language: modelica

Using hysteresis control, our simulation results look like this:

.. plot:: ../plots/TCE_Hy.py
   :class: interactive

But the most important difference is the fact that the hysteresis
doesn't lead to the kind of chattering we saw in our previous
bang-bang controller:

.. plot:: ../plots/TCE_Hyh.py
   :class: interactive

Conclusion
^^^^^^^^^^

This is the second example of how we can use the configuration
management features in Modelica to take an architecturally based
approach to building system models.  This architectural approach is
very useful when there are many variations of the same architecture
that require analysis.  Using the ``redeclare`` feature, it is
possible to easily substitute alternative designs for each subsystem
or to consider more or less detail in any given subsystem as necessary
for any given engineering analysis.

In this particular example, we saw how an ``expandable`` connector can
provide greater flexibility than a standard connector.  However, it
also comes with some risk because the type checking normally done by
the Modelica compiler is less rigorous.
