.. _arch-driven-approach:

Architecture Driven Approach
----------------------------

So far in this section, we started with a flat approach and gradually
adapted it to use the architectural features of Modelica.  Let's start to
build out our system from the top down using an architectural
approach where we define the structure of our system first and then
add specific subsystem implementations after that.

Interfaces
^^^^^^^^^^

We'd like to start by building our top level architecture model that
describes the subsystems we have and how they are connected.  However,
we need **something** to put into this architecture to represent our
subsystems.  We don't (yet) want to get down to the job of creating
implementations for all of our subsystem models.  So where do we
start?

The answer is that we start by describing the interfaces of our
subsystems.  Remember, from earlier in this section, that
redeclarations depend on a constraining type and that all
implementations must conform to that constraining type?  Well an
interface is essentially a formal definition of the constraining type
(*i.e.,* the expected public interface) but without any implementation
details.  Since it has no implementation details (*i.e.,* no equations
or sub-components), it will end up being a ``partial`` model.  But
that's fine for our purposes.

Let's start by considering the interface for our ``sensor``
subsystem.  We have already discussed the public interface in detail.
Here is a Modelica definition and icon for that interface:

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Interfaces/Sensor.mo
   :language: modelica

.. image:: /ModelicaByExample/Architectures/SensorComparison/Interfaces/Sensor.*
   :width: 25%
   :align: center
   :alt: Sensor interface

A few things to note about this ``model`` definition.  The first is,
as we mentioned a moment ago, that this model is ``partial``.  This is
because it has connectors but no equations to help solve for the
variables on those connectors.  Another thing worth noting is the fact
that it contains annotations.  The annotations associated with the
connector declarations specify how those connectors should be
rendered.  These annotations will be inherited by any model that
``extends`` from this one.  So it is important to choose locations
that will make sense across all implementations.  It also includes an
``Icon`` annotation.  This essentially defines a "backdrop" for the
final implementations icon.  In other words, any model that extends
from this model will be able to draw **additional** graphics on top of
what is defined by the ``Sensor`` model.

The interface definition for the actuator model is almost identical
except that it includes two rotational connectors, one to apply the
commanded torque to and the other that handles the reaction torque.
If, for example, our actuator model were an electric motor, the former
would be the connector for the rotor and the latter would be the
connector for the stator.  Otherwise, it is very similar to our
``Sensor`` definition:

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Interfaces/Actuator.mo
   :language: modelica

.. image:: /ModelicaByExample/Architectures/SensorComparison/Interfaces/Actuator.*
   :width: 25%
   :align: center
   :alt: Actuator interface

The ``Plant`` interface has three rotational connectors.  One for the
"input" side (where the actuator will be connected), one for the
"output" side (where the sensor will be connected) and the last one
for the "support" side (so it can be "mounted" to something):

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Interfaces/Plant.mo
   :language: modelica

.. image:: /ModelicaByExample/Architectures/SensorComparison/Interfaces/Plant.*
   :width: 25%
   :align: center
   :alt: Plant interface

Finally, we have the ``Controller`` interface definition:

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Interfaces/Controller.mo
   :language: modelica

.. image:: /ModelicaByExample/Architectures/SensorComparison/Interfaces/Controller.*
   :width: 25%
   :align: center
   :alt: Controller interface


Regardless of how it is implemented (*e.g.,* proportional control, PID
control), the ``Controller`` will require an input connector for the
desired setpoint, ``setpoint``, another input connector for the
measured speed, ``measured`` and an output connector to send the
commanded torque, ``command`` to the actuator.

Architecture
^^^^^^^^^^^^

With the interfaces specified, our architecture model can be written
as follows:

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Examples/SystemArchitecture.mo
   :language: modelica

We can see from the Modelica code that our architecture consists of
four ``replaceable`` subsystems: ``plant``, ``actuator``, ``sensor``
and ``setpoint``.  Each of these declarations includes only one type.
As we learned earlier in this section, that type will be used as both
the default type and the constraining type (which is what we want).
This model also includes all the connections between the subsystems.
In this way, it is a complete description of the subsystems and the
connections between them.  **All that is missing are the
implementation choices for each subsystem**.

Note that our ``SystemArchitecture`` model is, itself, ``partial``.
This is precisely because the default types for all the subsystems are
``partial`` and we have not yet specified implementations.  In other
words, this model has no implementation so it cannot (yet) be
simulated.  We indicate this by marking it as ``partial``.

Like our interface specifications, this model also contains graphical
annotations.  This is because, in addition to specifying the
subsystems, we are also specifying the locations of the subsystems and
the paths of the connections.  When rendered, our system architecture
looks like this:

.. image:: /ModelicaByExample/Architectures/SensorComparison/Examples/SystemArchitecture.*
   :width: 100%
   :align: center
   :alt: Top down architecture

Implementations
^^^^^^^^^^^^^^^

Now that we have the interfaces and the architecture, we need to
create some implementations that we can then "inject" into the
architecture.  These implementations can choose to either inherit from
the existing interfaces (thus avoiding redundant code) or simply
ensure that the declarations in the implementation make it
plug-compatible with the interface.  Obviously, inheriting from the
interface is, in general, a much better approach.  But we have
included examples of both simply to demonstrate that it isn't strictly
required to inherit from the interface.

Here are some of the implementations we'll be using over the remainder
of this section.  It is important to keep in mind that although these
models include many lines of Modelica source code, they can be very
quickly implemented in a graphical Modelica environment (*i.e.,* one
does not normally type in such models by hand).

Plant Models
~~~~~~~~~~~~

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Implementation/BasicPlant.mo
   :language: modelica
   :lines: 1-62,81

Actuator Models
~~~~~~~~~~~~~~~

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Implementation/IdealActuator.mo
   :language: modelica
   :lines: 1-28,47

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Implementation/LimitedActuator.mo
   :language: modelica
   :lines: 1-39,58

Controller Models
~~~~~~~~~~~~~~~~~

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Implementation/ProportionalController.mo
   :language: modelica
   :lines: 1-38,54

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Implementation/PID_Controller.mo
   :language: modelica
   :lines: 1-27,46

Sensor Models
~~~~~~~~~~~~~

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Implementation/IdealSensor.mo
   :language: modelica
   :lines: 1-22,41

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Implementation/SampleHoldSensor.mo
   :language: modelica
   :lines: 1-23,42

Variations
^^^^^^^^^^

Baseline Configuration
~~~~~~~~~~~~~~~~~~~~~~

With these implementations at hand, we can create a number of
different implementations of our complete system.  For example, to
implement the behavior of our original ``FlatSystem`` model, we simply
extend from the ``SystemArchitecture`` model and redeclare each of the
subsystems so that the implementations match the subsystem
implementations in ``FlatSystem``, *i.e.,*

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Examples/BaseSystem.mo
   :language: modelica

Here we see the real power of Modelica for specifying configurations.
Note how each redeclaration includes the ``replaceable`` qualifier.
By doing so, we ensure that subsequent redeclarations are possible.


If we had wanted our ``SystemArchitecture`` model to specify these
implementations as the default but still use the interfaces as the
constraining types, we could have declared the subsystems in
``SystemArchitecture`` as follows:

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Examples/SystemArchitecture_WithDefaults.mo
   :language: modelica
   :lines: 5-22

``Variation1``
~~~~~~~~~~~~~~

If we wish to create a variation of the ``BaseSystem`` model, we can
use inheritance and modifiers to create them, *e.g.,*

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Examples/Variant1.mo
   :language: modelica

Note how this model extends from ``BaseSystem`` configuration but then
changes **only** the ``sensor`` model.  If we simulate this system, we
see that the performance matches that of our original
:ref:`flat-sensor-system`.

.. plot:: ../plots/SV1.py
   :class: interactive

However, if we instead create a configuration with the longer hold
time, we find that the system becomes unstable (exactly as it did in
the :ref:`flat-sensor-system` as well):

.. plot:: ../plots/SV1U.py
   :class: interactive

``Variation2``
~~~~~~~~~~~~~~

Note how, even with an adequate sensor, the controller in our
``Variant1`` configuration seems to be converging to the wrong
steady state speed.  This is because we are only using a proportional
gain controller.  However, if we extend from the ``Variant1`` model
and add a PID controller and a more realistic actuator with
limitations on the amount of torque it can supply, *i.e.*,

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Examples/Variant2.mo
   :language: modelica

we will get the following simulation results:

.. plot:: ../plots/SV2.py
   :class: interactive

Furthermore, if take some time to tune the gains in the PID
controller, *i.e.,*

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Examples/Variant2_tuned.mo
   :language: modelica

Then, we will get even better simulation results:

.. plot:: ../plots/SV2T.py
   :class: interactive

Conclusion
^^^^^^^^^^

This concludes our discussion of this particular architecture.  The
key point in this example is that by using architectures, we make it
very easy to explore alternative configurations for our system.  But
in addition to being easier (in the sense that we are able to do these
things very quickly), we are also able to ensure a degree of
correctness as well because no additional connecting is required for
each configuration.  Instead, the user simply needs to specify which
implementation they would like to use for each subsystem and, even
then, the Modelica compiler can check to make sure that their choices
are plug-compatible with the constraining types used to specify the
architecture.
