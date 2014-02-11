Sensor Comparison
-----------------

Let us start our study of architectures with an examples that is
similar to one presented in my previous book [ItPMwM]_.  In it, we
will consider the performance of a control system using several
different sensor models.

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
generate an error.  In general, we want to ensure that and
redeclaration that we make is "safe".  The way we do that is to
require that whatever type we decide to change our ``sensor``
component to, it has to have **the same public interface** as the
original type.  In other words, it has to have a ``w`` connector (and
that connector, in turn, has to have the same public interface as what
*it* is replacing) and it has to have a ``shaft`` connector (again,
with the same public interface as what it is replacing).

So the question then is, does our ``SampleAndHold`` implementation
satisfy this requirement?  Does it have the same public interface as
the ``IdealSensor`` model?  First, let's look at the ``IdealSensor``
model:

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
connectors on the ``IdealSensor`` model.  For this reason, we should
be able to replace an ``IdealSensor`` instance with a
``SampleAndHold`` instance and our ``connect`` statements will still
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

.. code-block:: modelica

    model Variation3 "DRY redeclaration"
      extends HierarchicalSystem();
      Implementation.SampleHoldSensor sensor
        annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
    end Variation3;
    

.. [ItPMwM] Michael M. Tiller, "Introduction to Physical Modeling with
	    Modelica"
	    http://www.amazon.com/Introduction-Physical-Modeling-International-Engineering/dp/0792373677

