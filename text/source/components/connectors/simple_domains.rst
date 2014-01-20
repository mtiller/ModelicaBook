.. _simple-domains:

Simple Domains
==============

In this section, we'll discuss relatively simple engineering domains.
These are ones where a ``connector`` deals with only one through and
one across variable.  Conceptually, these means that only one
conserved quantity is involved with that connector.

The following table covers four different engineering domains.  In
each domain, we see the choice of through and across variable that we
will be using along with the SI units for that quantity.

================  =======================  ============================
Domain            Through Variable         Across Variable
----------------  -----------------------  ----------------------------
Electrical        Current [A]              Voltage [V]
Thermal           Heat [W]                 Temperature [K]
Translational     Force [N]                Position [m]
Rotational        Torque [N.m]             Angle [rad]
================  =======================  ============================

You may have seen a similar table before with slightly different
choices.  For example, you will sometimes see velocity (in
:math:`m/s`) chose as the across variable for translational motion.
The choices above are guided by two constraints.

The first constraint is that the through variable should be the time
derivative of some conserved quantity.  The reasons for this
constraint is that the through variable will be used to formulate
generalized conservation equations in our system.  As such, it is
essential that the through variables be conserved quantities.

The second constraint is that the across variable should be the lowest
order derivative to appear in any of our constitutive or empirical
equations in the domain.  So, for example, we chose position for
translational motion because position is used in describing the
behavior of a spring (*i.e.,* Hooke's law).  If we had chosen velocity
(the derivative of position with respect to time), then we would have
been in the awkward situation of trying to describe the behavior of a
spring in terms of velocities, not positions.  An essential point here
is that **differentiation is lossy**.  If we know position, we can
easily express velocity.  But if we only know velocity, we cannot
compute position without knowing an additional integration constant.
This is why we want to work with across variables that have not been
overly differentiated.

Now let's look at each domain individually.

Electrical
----------

.. literalinclude:: /ModelicaByExample/Connectors/SimpleDomains.mo
   :language: modelica
   :lines: 3-6

Thermal
-------

.. literalinclude:: /ModelicaByExample/Connectors/SimpleDomains.mo
   :language: modelica
   :lines: 8-11

Translational
-------------

.. literalinclude:: /ModelicaByExample/Connectors/SimpleDomains.mo
   :language: modelica
   :lines: 13-16

Rotational
----------

.. literalinclude:: /ModelicaByExample/Connectors/SimpleDomains.mo
   :language: modelica
   :lines: 18-21

``SimpleDomains``
-----------------

.. literalinclude:: /ModelicaByExample/Connectors/SimpleDomains.mo
   :language: modelica

