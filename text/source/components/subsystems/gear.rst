Gear Assembly
-------------

In this section, we'll take a close look at how to model a simple
gear.  We'll consider things like the inertia of each gear element,
the backlash that exists between the teeth and, of course, the
kinematic relationship between the two rotating shafts.  We'll first
show an example how a "flat" model of such an assembly would be created and
then we'll look at how this flat model can be refactored into a
reusable subsystem model that can be used across a wide ranging of
applications.

We've mentioned several times up until now that it is usually a good
idea to create component models that model just one physical effect,
*e.g.,* inertia, compliance, resistance, convection, *etc.* This is
true when we are modeling at the component level.  But many real world
subsystems are a mixture of all of these effects.  The way we address
this in Modelica is to build reusable subsystem models.  Of course, we
don't "reinvent the wheel" by adding the equations for all these
effects into our subsystem model.  Instead, we reuse the component
models we've already developed.  In the end, the subsystem model ends
up being nothing more than an assembly of pre-existing component
models arranged in a specific configuration.  Furthermore, we will
show how parameters used to describe the components can be "wired up"
to parameters of the subsystem.

Flat Version
^^^^^^^^^^^^

If we were unfamiliar with the ability to create reusable subsystem
models in Modelica, we might start by building a Modelica model that
looked like this one:

.. image:: /ModelicaByExample/Subsystems/GearSubsystemModel/Examples/FlatSystemWithBacklash.*
   :width: 100%
   :align: center
   :alt: Flat system model including backlash

This model includes two essential components.  Part of the model,
inside the dashed line, represents how the gear itself is being
modeled.  It includes the inertia for each gear element, the backlash
between the gear teeth and the kinematic relationship between the two
shafts.  Each of these is represented by an individual component
model.  The other part of the model, outside the dashed line,
represents the specific scenario/experiment we are performing.  This
includes a torque profile to be applied to the gear and the downstream
load that is being driven by the gear.

If we simulate this system, we get the following response:

.. plot:: ../plots/FSWB_comp.py
   :class: interactive

The important thing to understand about this system is that the
particular assembly of components inside the dashed line are likely to
repeated in any gear related application.  In fact, they may be
repeated multiple times in a model of something like an automotive
transmission model.


Hierarchical Version
^^^^^^^^^^^^^^^^^^^^
So, in order to avoid redundancy (the reasons for which have already
been discussed), we should create a reusable subsystem model of the
components within the dashed line.  In such a case, our schematic
diagram would then look something like this:

.. image:: /ModelicaByExample/Subsystems/GearSubsystemModel/Examples/BacklashExample.*
   :width: 100%
   :align: center
   :alt: System model including gear subsystem

In this case, the collection of components used to represent the gear
are replaced by a single instance in the diagram layer.  This is
possible because all the component models that make up the gear model
have been assembled into the following subsystem model:

.. literalinclude:: /ModelicaByExample/Subsystems/GearSubsystemModel/Components/GearWithBacklash.mo
   :language: modelica
   :lines: 1-53,81

When rendered, we see the diagram for the ``GearWithBacklash`` model
looks like this:

.. image:: /ModelicaByExample/Subsystems/GearSubsystemModel/Components/GearWithBacklash.*
   :width: 100%
   :align: center
   :alt: Gear with backlash subsystem model

There is quite a bit going on in this model.  First, note the presence
of the ``useSupport`` parameter.  This is used to determine whether to
include the :ref:`optional-ground-connector` we discussed in the
previous chapter.

Also note that all the subcomponents (``inertia_a``, ``inertia_b``,
``backlash`` and ``idealGear``) are ``protected``.  Only the
connectors (``flange_a``, ``flange_b`` and ``support``) and the
parameters (``J_a``, ``J_b``, ``c``, ``d``, ``b``, ``ratio``) are
``public``.  The idea here is that the only thing that the user needs
to be aware of (or should even be able to access) are the connectors
and the parameters.  Everything else is an implementation detail.  The
``protected`` elements of a model cannot be referenced from outside.
This prevents models from breaking if the internal details (which the
user should not require any knowledge of anyway) were to change.

Also note how many of the parameters, *e.g.,* ``c``, are specified at
the subsystem level and then assigned to parameters lower down in the
hierarchy (often in conjunction with the ``final`` qualifier).  In
this way, parameters of the components can be collected at the
subsystem level so users of this model will see all relevant
parameters in one place (at the subsystem level).  This is called
:ref:`propagation` and we will be discussing it in greater detail
later in the chapter.

As we can see in the following plot, the results are identical when
compared to the "flat" version presented previously:

.. plot:: ../plots/SWB.py
   :class: interactive

Conclusion
^^^^^^^^^^

We've already seen how component models can be used to turn equations
into reusable components.  This avoids the tedious, time-consuming and
error prone process of manually entering equations over and over
again.  This same principle applies when we find ourselves constantly
building the same assembly of component models into similar
assemblies.  We can use this subsystem model approach to create
reusable assemblies of components and parameterize them such that the
assembly can be used over and over again where the only changes
required are parametric.
