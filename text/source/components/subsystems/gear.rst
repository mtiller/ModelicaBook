Gear Assembly
-------------

In this section, we'll take a close look at how to model an simple
gear.  We'll consider things like the inertia of each gear element,
the backlash that exists between the teeth and, of course, the
kinematic relationship between the two rotating shafts.  We'll first
example how a "flat" model of such an assembly would be created and
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

.. image:: /ModelicaByExample/Subsystems/GearSubsystemModel/Examples/FlatSystemWithBacklash.svg
   :width: 100%
   :align: center
   :alt: Flat system model including backlash

This model includes to essential components.  Part of the model,
inside the dashed line, represents how the gear itself is being
modeled.  It includes the inertia for each gear element, the backlash
between the gear teeth and the kinematic relationship between the two
shafts.  Each of this is represented by an individual component
model.  The other part of the model, outside the dashed line,
represents the specific scenario/experiment we are performing.  This
includes a torque profile to be applied to the gear and the downstream
load that is being driven by the gear.

If we simulate this system, we get the following response:

.. plot:: ../plots/FSWB.py
   :include-source: no

The important thing to understand about this system is that the
particular assembly of components inside the dashed line are likely to
repeated in any gear related application.  In fact, they may be
repeated multiple times in a model of something like an automotive
transmission model.

So, in order to avoid redundancy (the reasons for which have already
been discussed), we should create a reusable subsystem model of the
components within the dashed line.  In such a case, our schematic
diagram would then look something like this:

.. image:: /ModelicaByExample/Subsystems/GearSubsystemModel/Examples/BacklashExample.svg
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


Hierarchical Version
^^^^^^^^^^^^^^^^^^^^
