.. _fluid-connectors:

Fluid Connectors
================

One area that Modelica has been widely used in is the modeling of
various types of fluid systems.  We saw in the previous section how to
create connectors for various :ref:`simple-domains`.  But what makes
Modelica so compelling for fluid systems is the ability to create more
complex connectors involving multiple conserved quantities
simultaneously.  Such connectors are essential for modeling fluid
systems, where a single connector might involve the flow of mass,
momentum, energy and/or species.  Such cases require the definition of
rich connectors types.

We'll start this section with a discussion of basic connectors very
similar to the ones used for :ref:`simple-domains`.  But we will
conclude with a connector that is fundamentally different from the
previous examples because it describes a connector that involves the
conservation of both mass and energy.

.. _incompressible-fluids:

Incompressible Fluids
---------------------

Modeling of incompressible fluids is very useful in a number of
engineering applications, most notably hydraulically actuated systems.
We'll start by presenting a simple connector that can be used to model
incompressible systems, but with some important caveats.

Consider the following connector definition:

.. literalinclude:: /ModelicaByExample/Connectors/FluidConnectors.mo
   :language: modelica
   :lines: 3-6

As we saw in our discussion of :ref:`simple-domains`, we see the
familiar pattern of an across variable and a through variable.  In
this case the across variable is ``p`` (the pressure) and the through
variable is ``q`` (the volumetric flow rate).  But this connector is
different from all the previous examples because the ``flow`` variable
is **not** the time derivative of a conserved quantity, since volume
is not a conserved quantity.

This connector works **as long as the fluid being modeled is
incompressible**.  To understand why, consider the following equation:

.. math::

    q_1 + q_2 + q_3 + q_4 = 0

where :math:`q_1`, :math:`q_2`, :math:`q_3` and :math:`q_1` represent
volumetric flow terms (*i.e.,* each has units of :math:`m^3/s`).  In
general, this equation does not qualify as a conservation equation
because volume is (again, in general) not conserved.  However, if we
know that each of these flows is an incompressible fluid, then we can
multiply the entire equation by the density of that incompressible
fluid, *i.e.,*

.. math::

    \rho q_1 + \rho q_2 + \rho q_3 + \rho q_4 = 0

Now each of these terms has units of :math:`kg/s` which is a
conservation equation because mass is a conserved quantity.  However,
**if you use this connector definition with a fluid that has any
significant degree of compressibility, you will get the wrong
answer.**

Such a connector definition is useful for relatively simple
incompressible fluid flow networks because it can frequently describe
the behavior of the system without having to specify (or know) the
density of the working fluid.  However, this kind of approach is
inherently limiting so it should only be used in situations where it
solves more problems than it creates.

Compressible Fluids
-------------------

While the previous connector definition should be strictly used for
:ref:`incompressible-fluids`, the following connector is more general:

.. literalinclude:: /ModelicaByExample/Connectors/FluidConnectors.mo
   :language: modelica
   :lines: 8-11

This connector can be used for **both** incompressible or compressible
fluids.  This is because it doesn't make any inherent assumptions
about the compressibility of the fluid.  Note that the across
variable, ``p``, is still pressure, but the through variable, ``m_dot``,
is a mass flow rate.  As such, the through variable conforms to the
convention that a through variable should be the time derivative of
a conserved quantity (in this case, mass).  So there are no implicit
assumptions in this connector, which is why it can be used to model
fluid flow of both compressible and incompressible fluids.

This connector isn't really fundamentally different from the
connectors associated with :ref:`simple-domains`, but it appears in
this section because it is a stepping stone to the next example.

Thermo-Fluid Modeling
---------------------

So far in this section, we've presented a connector for incompressible
fluid systems, ``Incompressible``, and a more general connector,
``GenericFluid``.  But in both of these cases, the only conserved
quantity considered was mass.  Nowhere in these previous connectors is
there any reference to or allowance for modeling the **temperature**
of the fluid.

There are many applications where the temperature of the working fluid
is critical.  In some cases, the temperature changes the density of
the working fluid.  In other cases, the temperature may trigger a
phase change (*e.g.,* from liquid to gas).  Temperature can also
affect other critical properties of the fluid like viscosity, which
have a significant impact on the performance of, for example,
lubrication systems.  As a result, those previous connector
definitions would be inadequate for modeling systems where the
temperature of the working fluid had any significant impact on the
system behavior.

To predict the temperature of a working fluid, it is necessary to
track the energy that flows with the fluid as it flows through a
network.  To do this, the connector definition must be augmented to
include energy, alongside mass, as a conserved quantity that flows
through the connector.  The following connector definition does just
that:

.. literalinclude:: /ModelicaByExample/Connectors/FluidConnectors.mo
   :language: modelica
   :lines: 13-18

Note that this connector includes **two** variables that have the
``flow`` qualifier, ``m_dot`` and ``q``.  These represent the flow of
mass and energy, respectively.  Each of these is paired with an across
variable.  One of those across variables is the pressure, ``p``, just
as we saw in the previous connectors in this section.  The other
across variable, ``T``, is the temperature of the working fluid.
