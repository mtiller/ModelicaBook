.. _adv-rotational-components:

Advanced Rotational Components
------------------------------

In the previous section, we discussed :ref:`rotational-components` and
showed how to build a system model from basic components.  In this
section we will demonstrate how to incorporate event handling, which
we will use when modeling a backlash.  Furthermore, we'll also show
how to use parameter values to effect the interface of a component.

Modeling Backlash
^^^^^^^^^^^^^^^^^

Let's start our exploration of more advanced component models by
looking at a rotational backlash element.  The equation for a backlash
model is very simple:

.. math::

    \tau =
    \left\{
    \begin{array}{cc}
    c (\Delta \varphi - \frac{b}{2}) \ \  &\mathrm{if}\ \Delta \varphi>\frac{b}{2} \\
    c (\Delta \varphi + \frac{b}{2}) \ \  &\mathrm{if}\ \Delta \varphi<-\frac{b}{2} \\
    0 \ \ &\mathrm{otherwise}
    \end{array}
    \right.

.. todo::

   Include a torque-deflection diagram here.

In Modelica, this component can be described as follows:

.. literalinclude:: /ModelicaByExample/Components/Rotational/Components/Backlash.mo
   :language: modelica
   :lines: 1-13,37

We can add an instance of this backlash model into our previous model
by placing it in parallel with the spring and the damper, *i.e.,*

.. image:: /ModelicaByExample/Components/Rotational/Examples/SMD_WithBacklash.*
   :width: 100%
   :align: center
   :alt: 

If we use the inheritance mechanism in Modelica, the resulting
Modelica model is quite simple:

.. literalinclude:: /ModelicaByExample/Components/Rotational/Examples/SMD_WithBacklash.mo
   :language: modelica
   :emphasize-lines: 4

In this case, if the relative angle between ``inertia1`` and
``inertia2`` is more than 0.5 radians (*i.e.,* the value of ``b`` in
our backlash instance), then the torque from the backlash element will
be introduced.

If we simulate this model, we can see the impact that the backlash's
presence has on the response of the system:

.. plot:: ../plots/SMD_WB.py
   :class: interactive

.. index:: kinematic constraint

.. index:: reaction torque

Another thing worth looking at (which we will delve into much more in
the next topic) is the force felt by the mechanical ground element.
Looking at our schematic, it is clear that the role of the mechanical
ground element is to fix the angular position on one side of our
system.  An equation to constrains the motion (or lack of motion, in
this case) of a point in the system is called a *kinematic constraint*.

When a kinematic constraint is imposed on a system, the component
imposing the constraint must generate some kind of force or torque in
order to affect the motion of the system.  This is called a reaction
force or reaction torque.

The following plot shows the reaction torque that the mechanical
ground element must impose on the system in order to fix the angular
position:

.. plot:: ../plots/SMD_WB_RT.py
   :class: interactive

Grounding and Reaction Torques
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

As we saw in the previous example, the behavior of the
mechanical ground element is such that it must exert a reaction torque
on the system to constrain the motion of the system.  In this section,
we will examine this effect a bit closer.

To demonstrate some of the complexities of kinematic constraints, we
need to create a mechanical gear model.  In this model, we will ignore
the inertia of the gear elements, efficiency losses in the gear and
any backlash that might exist between the teeth in the gear.  Recall
our discussion about :ref:`digging-deeper` earlier in this chapter
where we mentioned that component models should focus on individual
physical effects.  That same principle applies here.  Inertia, friction and
backlash can all be modeled as individual effects (as we've already
seen in this chapter).  There is no need to lump them into our gear
model.  Instead, we will focus only on the relationship between gear
input speed and output speed.

In a typical system dynamics class, the equations that describe the
behavior of a gear are derived as follows.  First, we start with the
understanding that a gear introduces a relationship between the input
speed and the output speed, *i.e.*,

.. math::

    \omega_a = R \omega_b

where :math:`R` is the gear ratio.  Recall that we assume the gear to
be perfectly efficient.  This means that the power going into the gear must
equal the power going out which we can express mathematically as:

.. math::

    \tau_a \omega_a + \tau_b \omega_b = 0

Note we are using the Modelica sign conventions here where a positive
value for the flow of a conserved quantity means a flow into the
component.  In this case, :math:`\tau_a \omega_a` is the flow of
mechanical power into the gear from ``flange_a`` and :math:`\tau_b
\omega_b` is the flow of mechanical power into the gear from
``flange_b``.  Therefore, their sum must be zero, since our gear model
does not include the inertia of the gear elements and, therefore, no
way to store energy or momentum within the gear model.

Given these two facts, we can substitute the relationship between the
speeds into the relationship between the powers and get:

.. math::

    \tau_a R \omega_b + \tau_b \omega_b = 0

This allows us to cancel out :math:`\omega_b` from the equation and
rearranging terms gives us:

.. math::

    \tau_b = -R \tau_a

Such a derivation will probably look very familiar to most engineers.
But it is important to recognize that there is something missing
here.  More specifically, there is something implicitly assumed that
is not necessarily a reasonable assumption.

To understand the issue, let's first consider Euler's second law:

.. math::

  J \ddot{\varphi} = \sum_i \tau_i

In other words, the sum of the torques on a body should be equal to
the amount of angular momentum being accumulated by the body.  Recall
that our gear model doesn't include the inertia of the gear elements.
As such, it has no capacity to store energy or angular momentum.  If
that is the case the previous equation simplifies to:

.. math::

  \sum_i \tau_i = 0

Our gear has only two external torques, :math:`\tau_a` and
:math:`\tau_b`.  Using the relationships we derived earlier, we know
that their sum is:

.. math::

    \tau_a + \tau_b = \tau_a - R \tau_a = \tau_a (1-R) = 0

This equation implies that for any gear ratio, :math:`R`, not equal to
1.0, the torque at ``flange_a`` (and consequently, the torque at
``flange_b`` as well) must be zero.  But this cannot be correct if our
gear is to function as a gear.

What this mathematical relationship is showing us about the physical
behavior of the system is more clearly demonstrated in this
relationship:

.. math::

   \tau_a - R \tau_a = 0

The first term, :math:`\tau_a` is the torque entering the gear from
``flange_a``.  The second term, :math:`R \tau_a` is the torque
entering the gear from ``flange_b``.  This equation tells us that
these two torques will never sum to zero (for :math:`R \neq 1`).  It
appears that we have proven, mathematically, that :math:`\tau_a=0`.
But in fact, what we are really demonstrating is that there is **an
imbalance** in the equation.  This imbalance is the result of having
forgotten something in our formulation.  What is missing is the
**reaction torque**.

If you aren't already familiar with this issue, you might be puzzled
about where this reaction torque comes from.  After all, we have only
two mechanical connections to this gear and we have expressions for
the torque at both of these points.  But along the way, there was an
implicit assumption that the **housing of the gear is grounded**.  In
reality, a gear has three mechanical connections.  The third
connection is the one between the housing of the gear and whatever the
gear is mounted to.  If the housing is connected to a mechanical
ground, then our equations so far are correct as we can capture the
behavior of such a (grounded) gear as follows:

.. literalinclude:: /ModelicaByExample/Components/Rotational/Components/GroundedGear.mo
   :language: modelica

Note that instead of using the relationship :math:`\omega_a=R\omega_b`
in the ``GroundedGear`` model, we instead used the relationship
:math:`\varphi_a=R\varphi_b`.  This is actually more accurate since,
once assembled, the teeth of the gear really do constrain the angular
positions of the two shafts.  Furthermore, there may be some
applications (*e.g.* stepper motors) where preserving this
relationship between positions, and not just velocities, could be very
important.

Using the ``GroundedGear`` model, we can then build a system model
using this gear as follows:

.. image:: /ModelicaByExample/Components/Rotational/Examples/SMD_WithGroundedGear.*
   :width: 100%
   :align: center
   :alt: 

Note this system has two parallel mechanisms.  The first one uses the
gear model we just developed.  The second one replaces the assembly of
the gear and inertias with a single inertia.  This single inertia was
specifically chosen to have the *"effective inertia"* of the
assembly.  As a result, when we simulate this system, we see that
``inertia2`` and ``inertia3`` have the same response:

.. todo:: Fix this plot

.. plot:: ../plots/SMD_GG.py
   :class: interactive

Comparison
^^^^^^^^^^

As previously mentioned, the issue with the ``GroundedGear`` model is
that it is implicitly assumed to be grounded.  This assumption may not
always be a reasonable one (*e.g.*, in an automotive transmission
where gears are generally connected to compliant mounts).  To
understand how much different the response of a system can be between
grounded and ungrounded gears we will first create a more complete
gear model that is not implicitly grounded and then compare its
performance, side by side, with gears that are grounded.

Without the implicit assumption that the housing of the gear is
grounded, the kinematic relationship between the two shafts and the
housing is more completely expressed as:

.. math::

    (1-R)\varphi_h = \varphi_a - R \varphi_b

Although it is beyond the scope of this discussion, we can derive the
following two equations using conservation of energy and
conservation of momentum:

.. math::

    \tau_b = -R \tau_a
    \tau_h = -(1-R) \tau_a

Combining these relationships and adding an additional mechanical
connector to represent the housing, we get the following Modelica
model for an ideal gear:

.. literalinclude:: /ModelicaByExample/Components/Rotational/Components/UngroundedGear.mo
   :language: modelica
   :lines: 1-11,60

Now, let us build a system model with three different mechanisms.  In
each mechanism the parameters for the gear, inertia, spring and damper
are all identical.  The only difference is whether we use an implicit
grounded gear, an explicitly grounded gear or a gear that is not
directly connected to ground, but is instead connected through a very
stiff mounting system.  The schematic for our system looks like this
when rendered:

.. image:: /ModelicaByExample/Components/Rotational/Examples/SMD_GearComparison.*
   :width: 100%
   :align: center
   :alt: 

The first thing we would expect is that the response of the mechanism
with the implicitly grounded gear should be identical to the response
of the mechanism with the explicitly grounded gear.  This is verified
by the following plot:

.. plot:: ../plots/SMD_GC_g.py
   :class: interactive

But the question still remains, how much difference would it make if
we assumed that a gear was implicitly grounded when, in fact, it
wasn't?  This is clearly demonstrated in the following plot:

.. plot:: ../plots/SMD_GC_u.py
   :class: interactive

.. todo:: Tune system to demonstrate a more remarkable difference

.. _optional-ground-connector:

Optional Ground Connector
^^^^^^^^^^^^^^^^^^^^^^^^^

So far in our discussion of rotational systems, we've created two
different gear models, ``GroundedGear``, which is implicitly grounded,
and ``UngroundedGear``, which includes a mechanical connector for the
housing.  Ultimately, the equations used by these two components are
quite similar and there is a considerable amount of common code
between them.  As we've talked about before, redundancy like this
should be avoided.

.. index:: conditional declaration

One way that we can avoid redundancy in this case is to combine these
two models.  It might seem like this is impractical since they have
very different underlying assumptions and, more importantly,
**different interfaces** (*i.e.,* different connectors).
Nevertheless, it is possible to combine these models by making use of
something called a *conditional declaration*.

Consider the following ``ConfigurableGear`` model:

.. literalinclude:: /ModelicaByExample/Components/Rotational/Components/ConfigurableGear.mo
   :language: modelica
   :lines: 1-17,66

In particular, notice that the declaration of ``housing`` ends with
``if not grounded``.  When ``if`` appears at the end of a declaration,
it indicates that the variables only exists if the condition following
the ``if`` is true.  So when the ``grounded`` parameter is true, there
is no ``housing`` connector in this model.  Furthermore, the equations
included, as modifications, in the declaration of ``housing`` (*i.e.,*
``phi=housing_phi`` and ``tau=-flange_a.tau-flange_b.tau``) also
disappear with the declaration.

Meanwhile, in the ``equation`` section, we see that the ``if``
statement there provides an additional equation, ``housing_phi=0``, in
the case when the model is grounded.  This is necessary because the
variable ``housing_phi`` is always present (*i.e.,* there is no ``if``
at the end of its declaration) so there must be an equation for it.

To understand more completely what is going on here, recall that the
number of equations required by a component model is equal to the
number of flow variables across all the component's connectors + the
number of (non-parameter) variables declared in the model.

The following table summarizes how these things add up for the case
where ``grounded`` is true and the case where it isn't:

=================================  ======================  ======================
Quantity                           ``grounded==true``      ``grounded==false``
=================================  ======================  ======================
Number of ``flow`` variables       2                       3
---------------------------------  ----------------------  ----------------------
Number of variables                1 (``housing_phi``)     1 (``housing_phi``)
---------------------------------  ----------------------  ----------------------
**Equations required**             **3**                   **4**
---------------------------------  ----------------------  ----------------------
Equations in declarations          0                       2 (from ``housing``)
---------------------------------  ----------------------  ----------------------
Equations in ``equation`` section  3                       2
---------------------------------  ----------------------  ----------------------
**Equations provided**             **3**                   **4**
=================================  ======================  ======================

When using conditional declarations, it is very important to make sure
that the number of equations provided balances with the number of
equations required for all possible conditions.  In this case, we have
only two conditions to concern ourselves with and we can clearly see
from this table that we have met this requirement in both cases.

The following model demonstrates how we can now use the
``ConfigurableGear`` models as both an implicitly and explicitly
grounded gear:

.. figure:: /ModelicaByExample/Components/Rotational/Examples/SMD_ConfigurableGear.*
   :width: 100%
   :align: center
   :alt: Example using a configurable gear
   :figclass: align-center

And, as we would expect, the response for ``inertia1`` and
``inertia4`` are identical:

.. plot:: ../plots/SMD_CG.py
   :class: interactive
