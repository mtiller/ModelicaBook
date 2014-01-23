.. _simple-domains:

Simple Domains
==============

In this section, we'll discuss relatively simple engineering domains.
These are ones where a ``connector`` deals with only one through and
one across variable.  Conceptually, this means that only one
conserved quantity is involved with that connector.

The following table covers four different engineering domains.  In
each domain, we see the choice of through and across variables that we
will be using along with the SI units for those quantities.

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
:math:`m/s`) chosen as the across variable for translational motion.
The choices above are guided by two constraints.

The first constraint is that the through variable should be the time
derivative of some conserved quantity.  The reason for this
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

We can define a ``connector`` for the electrical domain as follows:

.. literalinclude:: /ModelicaByExample/Connectors/SimpleDomains.mo
   :language: modelica
   :lines: 3-6

Here we see that the variable ``v`` in this connector represents the
voltage and the variable ``i`` represents the current.

.. index:: flow

Note the presence of the ``flow`` qualifier in the declaration of
``i``, the current.  The ``flow`` qualifier is what tells the Modelica
compiler that ``i`` is the through variable.  Recall from our
discussion on :ref:`acausal-connections` that the ``flow`` variable
should be the time derivative of a conserved quantity.  We can see
that this connector follows that convention, since ``Current`` is the
time derivative of charge (and charge is a conserved quantity).

Note the absence of any qualifier in the declaration of ``v``, the
voltage.  A variable without any qualifier is assumed to be the
``across`` variable.  You will find a more complete discussion about
:ref:`connector-vars` (including the various qualifiers that can
applied to them) later in this chapter.

The interested reader may wish to jump ahead to our discussion of
:ref:`electrical-components`
to see how we build on the connector definition to create electrical circuit components.

Thermal
-------

A connector for modeling lumped heat transfer isn't much different
from an electrical connector:

.. literalinclude:: /ModelicaByExample/Connectors/SimpleDomains.mo
   :language: modelica
   :lines: 8-11

Instead of ``Voltage`` and ``Current``, this connector includes
``Temperature`` and ``HeatFlowRate``.  While the names are different,
the overall structure is essentially the same.  The ``connector``
includes one through variable (``q``, indicated by the presence of the
``flow`` qualifier) and one across variable (``T``, indicated by the
lack of any qualifier).  Again, we see that the type of the variable
with the ``flow`` qualifier, ``HeatFlowRate``, is the time derivative
of a conserved quantity, energy.

An example of how such a connector can be used to build components for
lumped thermal network modeling can be found in the upcoming
discussion on :ref:`heat-transfer-components`.  If you feel
comfortable with this ``connector`` definition, feel free to jump
ahead.  It would still be a good idea to read the
:ref:`connector-review` section of the :ref:`connectors` chapter at
some point.

Translational
-------------

To model translational motion, we would define a connector as follows:

.. literalinclude:: /ModelicaByExample/Connectors/SimpleDomains.mo
   :language: modelica
   :lines: 13-16

Again, we see the same basic structure as before.  The connector
contains one through variable, ``f``, and one across variable ``x``.
Note that, although this is a one-dimensional mechanical connector,
the physical types are specific to translational motion and distinct
from the physical types used from the :ref:`rotational-connector`
case to be presented next.

An important fact about mechanical connectors that is often overlooked
is that the ``flow`` variable **is** the time derivative of a
conserved quantity.  For example, in the case of translational motion
the ``flow`` variable, ``f``, is a force and force is the time
derivative of (linear) momentum and momentum is a conserved quantity.

.. _rotational-connector:

Rotational
----------

For systems whose motion is constrained to be rotational, the
following Modelica ``connector`` definition should be used:

.. literalinclude:: /ModelicaByExample/Connectors/SimpleDomains.mo
   :language: modelica
   :lines: 18-21

Here we see that the across variable is ``phi`` (representing the
angular displacement) and the through variable is ``torque``.  As with
all previous examples, the ``flow`` variable is the time derivative of
a conserved quantity.  In this case, that conserved quantity is
angular momentum.

``SimpleDomains``
-----------------

All the connectors defined in this section are grouped, for future
reference, into a single package:

.. literalinclude:: /ModelicaByExample/Connectors/SimpleDomains.mo
   :language: modelica
