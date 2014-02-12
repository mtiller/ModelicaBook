Sensor Comparison
-----------------

Let us start our study of architectures with an examples that is
similar to one presented in my previous book [ItPMwM]_.  In it, we
will consider the performance of a control system using several
different sensor models.

.. _flat-sensor-system:

Flat System
^^^^^^^^^^^

Our system schematic is structured as follows:

.. image:: /ModelicaByExample/Architectures/SensorComparison/Examples/FlatSystem.svg
   :width: 100%
   :align: center
   :alt: Flat system model

All the components within the purple box represent the plant model.
In this case, it is a simple rotational system involving two rotating
inertias connected via a spring and a damper.  One of the inertias is
connected to a rotational ground by an additional damper.  The green
box identifies the sensor in the system.  The sensor is used to
measure the speed of one of the rotating shafts.  Similarly, the
purple box identifies the actuator.  The actuator applies a torque to
the other shaft (the one whose speed is not measured).  Finally, all
the components in the blue box represent the control system which
tries to keep the measured speed as close as possible to the setpoint
supplied by the signal generator at the top of the diagram.

We can represent this using the following Modelica code:

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Examples/FlatSystem.mo
   :language: modelica

Note that for this particular model, the ``sensor`` component is an
instance of the ``SpeedSensor`` model found in
``Modelica.Mechanics.Rotational.Sensors`` which is an "ideal" sensor
that reports the exact solution trajectory.  In other words, it does
not introduce any kind of measurement artifact.

In fact, simulating such a system we see that using accurate speed
measurements, the control system is still not quite able to follow
the speed trace:

.. plot:: ../plots/AFS.py
   :include-source: no

We'll discuss why in a moment.  But the problem clearly isn't
measurement artifact since the measured speed is exactly equal to the
actual shaft speed.

Now, imagine we wanted to use a more realistic sensor model, like the
:ref:`sample-hold-sensor` model developed previously, to see what
additional impact measurement artifact might have on our system
performance.  One way we could do that would be to replace the
following lines in the ``FlatSystem`` model:

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Examples/FlatSystem.mo
   :language: modelica
   :lines: 15-18

with these lines:

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Examples/FlatSystem_Variation1.mo
   :language: modelica
   :lines: 15-18

Note that **the only change being made here is the type** of the
``speedSensor`` component.  Simulating this system, we would see the
following performance for the control system:

.. plot:: ../plots/AFS_SH.py
   :include-source: no

In this case, we can see that things are going from bad to worse in
this case.  While we were initially unable to track the desired speed
closely, now (as a result of the measurement artifact) our system has
become unstable.

Hierarchical System
^^^^^^^^^^^^^^^^^^^

At this point, we'd like to explore this performance issue a bit more
to understand how characteristics of the sensor (*e.g.,*
``sample_rate``) impact performance and potentially what kinds of
improvements might ultimately be required for the control system
itself.

If we plan on substituting sensors, actuators and control strategies
our first step should be to organize our system in those subsystems.
Doing so, we end up with the following system model:

.. image:: /ModelicaByExample/Architectures/SensorComparison/Examples/HierarchicalSystem.svg
   :width: 100%
   :align: center
   :alt: Hierarchical system model

Here we see only four subsystems at the system level.  They correspond
to the subsystems we mentioned a moment ago.  Our Modelica model is
now much simpler because the only declarations we now have are:

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Examples/HierarchicalSystem.mo
   :language: modelica
   :lines: 3-12

Each subsystem (``plant``, ``actuator``, ``sensor`` and
``controller``) is implemented by a subsystem in the
``Implementations`` package.  This is an improvement because it means
that if we wanted to change controller models, we could simply change
the type associated with the ``controller`` subsystem and a different
implementation would be used.  This is definitely an improvement over
having to delete the existing controller components, drag in new ones
and then connect everything back up (correctly!).

But switching our sensor model to a sample and hold version still
involves editing the text of our model, *i.e.,*

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Examples/HierarchicalSystem_Variant1.mo
   :language: modelica
   :lines: 3-12
   :emphasize-lines: 5-6

There are still a couple of issues with this solution.  First, recall
that we changed the implementation to be used by changing the name of
the type.  This raises the question "What types *can* be used here?"
What if I change the type of ``sensor`` to ``BasicPlant``?  That
wouldn't make any sense.  But we don't really know that by looking at
the model.  But the **bigger** problem is that to create a model that
we end up with two models that are almost identical.  As we learned
:ref:`earlier in the book <dry-components>`, it is always useful to
keep in mind the DRY (Don't Repeat Yourself) principle.  In these
models, we see a lot of redundancy.

Dealing with Redundancy
^^^^^^^^^^^^^^^^^^^^^^^

Imagine we start with our hierarchical model using the ``IdealSensor``
model:

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Examples/HierarchicalSystem.mo
   :language: modelica

Now, we want to create a variation of this model where the ``sensor``
component 

Previously, we dealt with redundancy by using inheritance.  We can
certainly use inheritance to pull the subsystems from
``HierarchicalSystem`` into another model and then change
*parameters*, *e.g.,*

.. code-block:: modelica

    model Variation1
      extends HierarchicalSystem(setpoint(startTime=1.0));
    end Variation1;

But we don't want to change parameters, we want to change **types**.
If we could somehow "overwrite" previous choices, we could do
something like this:

.. code-block:: modelica

    model Variation2 "What we'd like to do (but cannot)"
      extends HierarchicalSystem(setpoint(startTime=1.0));
      Implementation.SampleHoldSensor sensor
        annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
    end Variation2;

This is essentially what we want to do.  But this isn't legal in
Modelica.  There are a couple of problems with this approach.  The
first is that the original model developer might not want to allow
such changes.  The second problem is that we end up with two
``sensor`` components (of different types, no less).  Even if it truly
"overwrites" any previous declaration of the ``sensor`` component,
another problem is that we might type the name wrong for the variable
name and end up with two sensors.  Finally, we still don't have a way
to know if it even makes sense to change ``sensor`` into a
``SampleHoldSensor``.  In this case it does, but how do we ensure that
in general.

Fortunately, there **is** a way to do almost exactly what we are
attempting here.  But in order to address these other complications,
we need to be a bit more rigorous about it.

We need to start by indicating that that component is allowed to be
replaced.  We can do this by declaring the ``sensor`` as follows:

.. index:: replaceable

.. code-block:: modelica

  replaceable Implementation.IdealSensor sensor
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

The use of the `replaceable` keyword indicates that when we inherit
from the model, that variable's type can be changed (or,
"redeclared").  But remember that this model also has a statement like
this one:

.. code-block:: modelica

   connect(plant.flange_b, sensor.shaft);
   connect(sensor.w, controller.measured);

This introduces a complication.  What happens if we replace the
``sensor`` component with something that **does not have** a ``w``
connector on it?  In that case, this ``connect`` statement will
generate an error.  In this case, we say that the two sensor models
are not **plug-compatible**.  A model ``X`` is plug-compatible with a
model ``Y`` if for every **public** variable in ``Y``, there is a
corresponding public variable in ``X`` with the same name.
Furthermore, every such variable in ``X`` must itself be
plug-compatible with its counterpart in ``Y``.  This ensures that if
you change a component of type ``Y`` into a component of type ``X``
and everything you need (parameters, connectors, etc) will still be
there and will still be compatible.  **However, please note** that if
``X`` is plug-compatible with ``Y``, this **does not** imply that
``Y`` is plug-compatible with ``X`` (as we will see in a moment).

Plug compatibility is important because, in general, we want to ensure
that any redeclaration that we make is "safe".  The way we do that is
to require that whatever type we decide to change our ``sensor``
component to, is plug compatible with the original type.  In this
case, that means that it has to have a ``w`` connector (and that
connector, in turn, must be plug compatible with the ``w`` that was
there before) and it has to have a ``shaft`` connector (which, again,
must be plug compatible with the previous ``shaft``).

So the question then is, does our ``SampleAndHold`` implementation
satisfy this requirement plug compatibility requirement?  Is it
plug-compatible with the ``IdealSensor`` model?  First, let's look at
the ``IdealSensor`` model:

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Implementation/IdealSensor.mo
   :language: modelica
   :lines: 1-12

The public interface of this component consists only of the two
connectors ``w`` and ``shaft``.  Looking at the ``SampleAndHold``
model:

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Implementation/SampleAndHold.mo
   :language: modelica
   :lines: 1-12
   :emphasize-lines: 4-8

we see that its public interface also contains the connectors ``w``
and ``shaft``.  Furthermore, they are exactly the same type as the
connectors on the ``IdealSensor`` model.  For this reason, the
``SampleAndHold`` model is plug-compatible with the ``IdealSensor``
model so we should be able to replace an ``IdealSensor`` instance with
a ``SampleAndHold`` instance and our ``connect`` statements will still
be valid.

So, if our ``HierarchicalSystem`` model were declared as follows:

.. code-block:: modelica

    within ModelicaByExample.Architectures.SensorComparison.Examples;
    model HierarchicalSystem "Organzing components into subsystems"
      replaceable Implementation.BasicPlant plant
        annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
      replaceable Implementation.IdealActuator actuator
        annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
      replaceable Implementation.IdealSensor sensor
        annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
      replaceable Implementation.ProportionalController controller
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      replaceable Modelica.Blocks.Sources.Trapezoid setpoint
        annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
      // ...
    end HierarchicalSystem;

Then we can achieve our original goal of creating a variation of this
model without repeating ourselves as follows:

.. index:: redeclare

.. code-block:: modelica

    model Variation3 "DRY redeclaration"
      extends HierarchicalSystem(
        redeclare Implementation.SampleHoldSensor sensor
      );
    end Variation3;
    
There are several things worth noting about this model.  The first is
that the syntax of a redeclaration is just like a normal declaration
except it are preceded by the ``redeclare`` keyword.  Also note that
the redeclaration is part of the ``extends`` clause.  Specifically, it
is a modification, like any other modification, in the extends
clause.  If we wanted to both redeclare the ``sensor`` component and
change the ``startTime`` parameter of our setpoint, they would both be
modifications of the ``extends`` clause, *e.g.,*

.. code-block:: modelica

    model Variation3 "DRY redeclaration"
      extends HierarchicalSystem(
        setpoint(startTime=1.0),
        redeclare Implementation.SampleHoldSensor sensor
      );
    end Variation3;

.. _constraining-types:

Constraining Types
^^^^^^^^^^^^^^^^^^

Recall, from earlier in this section, that the public interface for
the ``SampleAndHold`` model included:

.. code-block:: modelica

    parameter Modelica.SIunits.Time sample_rate=0.01;
    Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft;
    Modelica.Blocks.Interfaces.RealOutput w;

and that the ``IdealSensor`` public interface contained only:

.. code-block:: modelica

    Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft;
    Modelica.Blocks.Interfaces.RealOutput w;

If redeclarations are restricted in such a way that the redeclared
type has to be plug-compatible with the original type, then we could
run into the following problem.  What if our initial model for our
system used the ``SampleAndHold`` sensor, *i.e.,*

.. code-block:: modelica

    within ModelicaByExample.Architectures.SensorComparison.Examples;
    model InitialSystem "Organzing components into subsystems"
      replaceable Implementation.BasicPlant plant;
      replaceable Implementation.IdealActuator actuator;
      replaceable Implementation.SampleAndHold sensor;
      replaceable Implementation.ProportionalController controller;
      replaceable Modelica.Blocks.Sources.Trapezoid setpoint;
    equation
      // ...
      connect(plant.flange_b, sensor.shaft);
      connect(sensor.w, controller.measured);
      // ...
    end InitialSystem;

Imagine further that we then wanted to redeclare the ``sensor``
component to be an ``IdealSensor``, *e.g.,*

.. code-block:: modelica

    model Variation4
      extends InitialSystem(
        setpoint(startTime=1.0),
        redeclare Implementation.IdealSensor sensor // illlegal
      );
    end Variation4;

Now we have a problem.  The problem is that our original ``sensor``
component has a parameter called ``sample_rate``.  But, we are trying
to replace it with something that does not have that parameter.  In
other words, the ``IdealSensor`` model is **not** plug-compatible with
the ``SampleAndHold`` model because it is missing something,
``sample_rate``, that the original model, ``SampleAndHold``, had.

.. index:: constraining types

But when we look at source code of the ``InitialSystem`` model, we see
that the ``sample_rate`` parameter was never used.  So there is no
real reason why we couldn't switch the type.  For this reason,
Modelica includes the notion of a *constraining type*.

The important thing to understand about redeclarations is that there
are really two important types associated with the original
declaration.  The first type is what the type of the original
declaration was.  The second type is what the type *could be* and
still work.  This second type is called the constraining type because
as long as any redeclaration is plug-compatible with the constraining
type, the model should still work.  So in our ``InitialSystem`` model
above, the type of the original declaration was ``SampleAndHold``.
But the model will still work as long as any new type is
plug-compatible with ``IdealSensor``.

When we indicate that a component is ``replaceable``, we can indicate
the constraining type by adding a ``constrainedby`` clause at the end,
*e.g.*,

.. code-block:: modelica

    replaceable Implementation.SampleAndHold sensor
      constrainedby Implementation.IdealSensor;

.. index:: default type

This declaration says that the ``sensor`` component can be redeclared
by anything that is plug-compatible with the ``IdealSensor`` model
**but** if it isn't redeclared then **by default** it should be
declared as a ``SampleAndHold`` sensor.  For this reason, the original
type used in the declaration, ``SampleAndHold``, is called the
**default type**.

Recall that our original definition of the ``InitialSystem`` model
didn't specify a constraining type.  It only specified the initial
type.  In that case, the default type and the constraining type are
assumed to be the initial type.

Architecture Driven Approach
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

So far in this section, we started with a flat approach and gradually
adapted it to use the architectural features of Modelica.  Let's start
build out our system from the top down using an architectural
approach where we define the structure of our system first and then
add specific subsystem implementations after that.

Interfaces
~~~~~~~~~~

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
subsystem.  We have already discussed the public interface in detail
already.  Here is a Modelica definition for that interface:

.. code-block:: modelica

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Interfaces/Sensor.mo
   :language: modelica

A few things to note about this ``model`` definition.  The first is,
as we mentioned a moment ago, that this model is ``partial``.  It
should be clear why since it has connectors but not equations to help
solve for the variables on those connectors.  Another thing worth
noting is the fact that it contains annotations.  The annotations
associated with the connector declarations specify how those
connectors should be rendered.  These annotations will be inherited by
any model that ``extends`` from this one.  So it is important to
choose locations that will make sense across all implementations.  It
also includes an ``Icon`` annotation.  This essentially defines a
"backdrop" for the final implementations icon.  In other words, any
model that extends from this model will be able to draw **additional**
graphics on top of what is defined by the ``Sensor`` model.

The interface definition for the actuator model is almost identical
except that it includes two rotational connector, one to apply the
commanded torque to and the other that handles the reaction torque.
If, for example, our actuator model were an electric motor, the former
would be the connector for the rotor and the latter would be the
connector for the stator.  Otherwise, it is very similar to our
``Sensor`` definition:

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Interfaces/Actuator.mo
   :language: modelica

The ``Plant`` interface has three rotational connectors.  One for the
"input" side (where the actuator will be connected), one for the
"output" side (where the sensor will be connected) and the last one
for the "support" side (so it can be "mounted" to something):

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Interfaces/Plant.mo
   :language: modelica

Finally, we have the ``Controller`` interface definition:

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Interfaces/Controller.mo
   :language: modelica

Regardless of how it is implemented (*e.g.,* proportional control, PID
control), the ``Controller`` will require an input connector for the
desired setpoint, ``setpoint``, another input connector for the
measured speed, ``measured`` and an output connector to send the
commanded torque, ``command`` to the actuator.

Architecture
~~~~~~~~~~~~

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

.. image:: /ModelicaByExample/Architectures/SensorComparison/Examples/SystemArchitecture.svg
   :width: 100%
   :align: center
   :alt: Top down architecture

Implementations
~~~~~~~~~~~~~~~

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
++++++++++++

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Implementation/BasicPlant.mo
   :language: modelica
   :lines: 1-62,81

Actuator Models
+++++++++++++++

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Implementation/IdealActuator.mo
   :language: modelica
   :lines: 1-28,47

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Implementation/LimitedActuator.mo
   :language: modelica
   :lines: 1-39,58

Controller Models
+++++++++++++++++

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Implementation/ProportionalController.mo
   :language: modelica
   :lines: 1-39,55

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Implementation/PID_Controller.mo
   :language: modelica
   :lines: 1-27,46

Sensor Models
+++++++++++++

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Implementation/IdealSensor.mo
   :language: modelica
   :lines: 1-23,42

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Implementation/SampleHoldSensor.mo
   :language: modelica
   :lines: 1-23,42

Variations
~~~~~~~~~~

Baseline Configuration
++++++++++++++++++++++

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
implementations as the default but still used the interfaces as the
constraining types, we could have declared the subsystems in
``SystemArchitecture`` as follows:

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Examples/SystemArchitecture_WithDefaults.mo
   :language: modelica
   :lines: 5-22

``Variation1``
++++++++++++++

If we wish to create a variation of the ``BaseSystem`` model, we can
use inheritance and modifiers to create them, *e.g.,*

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Examples/Variant1.mo
   :language: modelica

Note how this model extends from ``BaseSystem`` configuration but then
changes **only** the ``sensor`` model.  If we simulate this system, we
see that the performance matches that of our original
:ref:`flat-sensor-system`.

.. plot:: ../plots/SV1.py
   :include-source: no

However, if we instead create a configuration with the longer hold
time, we find that the system becomes unstable (exactly as it did in
the :ref:`flat-sensor-system` as well):

.. plot:: ../plots/SV1U.py
   :include-source: no

``Variation2``
++++++++++++++

Note how, even with an adequate sensor, the controller in our
``Variant1`` configuration seems to be converging to the wrong
steady-state speed.  This is because we are only using a proportional
gain controller.  However, if we extend from the ``Variant1`` model
and add a PID controller and a more realistic actuator with
limitations on the amount of torque it can supply, *i.e.*,

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Examples/Variant2.mo
   :language: modelica

we will get the following simulation results:

.. plot:: ../plots/SV2.py
   :include-source: no

Furthermore, if take some time to tune the gains in the PID
controller, *i.e.,*

.. literalinclude:: /ModelicaByExample/Architectures/SensorComparison/Examples/Variant2_tuned.mo
   :language: modelica

Then, we will get even better simulation results:

.. plot:: ../plots/SV2T.py
   :include-source: no

Conclusion
^^^^^^^^^^

.. [ItPMwM] Michael M. Tiller, "Introduction to Physical Modeling with
	    Modelica"
	    http://www.amazon.com/Introduction-Physical-Modeling-International-Engineering/dp/0792373677

