.. _mech-example:

A Mechanical Example
--------------------

If you are more familiar with mechanical systems, this example might
help reinforce some of the concepts we've covered so far.  The system
we wish to model is the one shown in the following figure:

.. figure:: /ModelicaByExample/Components/SpeedMeasurement/Examples/PlantWithPulseCounter.*
   :width: 100%
   :align: center
   :alt: Plant with pulse counter sensor
   :figclass: align-center

It is worth pointing out how much easier it is to convey the intention
of a model by presenting it in schematic form.  Assuming appropriate
graphical representations are used, experts can very quickly
understand the composition of the system and develop an intuition
about how it is likely to behave.  While we are currently focusing on
equations and variables, we will eventually work our way up to an
approach (in the upcoming section of the book on :ref:`components`)
where **models will be built in this schematic form from the
beginning**.

For now, however, we will focus on how to express the equations
associated with this simple mechanical system.  Each inertia has a
rotational position, :math:`\varphi`, and a rotational speed,
:math:`\omega` where :math:`\omega = \dot{\varphi}`.  For each inertia,
the balance of angular momentum for the inertia can be expressed as:

.. math:: J \dot{\omega} = \sum_i \tau_i

In other words, the sum of the torques, :math:`\tau`, applied to the
inertia should be equal to the product of the moment of inertia,
:math:`J`, and the angular acceleration, :math:`\dot{\omega}`.

.. index:: Hooke's law

At this point, all we are missing are the torque values,
:math:`\tau_i`.  From the previous figure, we can see that there are
two springs and two dampers.  For the springs, we can use Hooke's law
to express the relationship between torque and angular displacement as
follows:

.. math:: \tau = k \Delta \varphi

For each damper, we express the relationship between torque and
relative angular velocity as:

.. math:: \tau = d \Delta \dot{\varphi}

If we pull together all of these relations, we get the following
system of equations:

.. math::

    \omega_1 &= \dot{\varphi}_1 \\
    J_1 \dot{\omega}_1 &= k_1 (\varphi_2-\varphi_1) + d_1 \frac{\mathrm{d} (\varphi_2-\varphi_1)}{\mathrm{d}t} \\
    \omega_2 &= \dot{\varphi}_2 \\
    J_2 \dot{\omega}_2 &= k_1 (\varphi_1-\varphi_2) + d_1 \frac{\mathrm{d} (\varphi_1-\varphi_2)}{\mathrm{d}t} - k_2 \varphi_2 - d_2 \dot{\varphi}_2

Let's assume our system has the following initial conditions as well:

.. math::

    \varphi_1 &= 0 \\
    \omega_1 &= 0 \\
    \varphi_2 &= 1 \\
    \omega_2 &= 0


These initial conditions essentially mean that the system starts in a
state where neither inertia is actually moving (*i.e.*,
:math:`\omega=0`), but there is a non-zero deflection across both
springs.

Pulling all of these variables and equations together, we can express
this problem in Modelica as follows:

.. literalinclude:: /ModelicaByExample/BasicEquations/RotationalSMD/SecondOrderSystem.mo
   :language: modelica
   :lines: 2-

As we did with the low-pass filter example, ``RLC1``, let's walk
through this line by line.

As usual, we start with the name of the model:

.. literalinclude:: /ModelicaByExample/BasicEquations/RotationalSMD/SecondOrderSystem.mo
   :language: modelica
   :lines: 2-2

Next, we introduce physical types for a rotational mechanical system, namely:

.. literalinclude:: /ModelicaByExample/BasicEquations/RotationalSMD/SecondOrderSystem.mo
   :language: modelica
   :lines: 3-7

Then we define the various parameters used to represent the different
physical characteristics of our system:

.. literalinclude:: /ModelicaByExample/BasicEquations/RotationalSMD/SecondOrderSystem.mo
   :language: modelica
   :lines: 8-13

For this system, there are four non-``parameter`` variables.  These are defined as follows:

.. literalinclude:: /ModelicaByExample/BasicEquations/RotationalSMD/SecondOrderSystem.mo
   :language: modelica
   :lines: 14-17

The initial conditions (which we will revisit shortly) are then defined with:

.. literalinclude:: /ModelicaByExample/BasicEquations/RotationalSMD/SecondOrderSystem.mo
   :language: modelica
   :lines: 18-22

Then come the equations describing the dynamic response of our system:

.. literalinclude:: /ModelicaByExample/BasicEquations/RotationalSMD/SecondOrderSystem.mo
   :language: modelica
   :lines: 23-29

And finally, we have the closing of our model definition.

.. literalinclude:: /ModelicaByExample/BasicEquations/RotationalSMD/SecondOrderSystem.mo
   :language: modelica
   :lines: 30-30

.. index:: modifications

The only drawback of this model is that all of our initial conditions
have been "hard-coded" into the model.  This means that we will be
unable to specify any alternative set of initial conditions for this
model.  We can overcome this issue, as we did with our
:ref:`Newton cooling examples <getting-physical>`, by defining
``parameter`` variables to represent the initial conditions as
follows:

.. literalinclude:: /ModelicaByExample/BasicEquations/RotationalSMD/SecondOrderSystemInitParams.mo
   :language: modelica
   :emphasize-lines: 8-11,23-26
   :lines: 2-

In this way, the parameter values can be changed either in the
simulation environment (where parameters are typically editable by the
user) or, as we will see shortly, via so-called "modifications".

You will see in this latest version of the model that the values for
the newly introduced parameters are the same as the hard-coded values
used earlier.  As a result, the default initial conditions will be
exactly the same as they were before.  But now, we have the freedom to
explore other initial conditions as well.  For example, if we simulate
the ``SecondOrderSystemInitParams`` model as is, we get the following
solution for the angular positions and velocities:

.. plot:: ../plots/SOSIP.py
   :class: interactive

However, if modify the ``phi1_init`` parameter to be *1* at the start
of our simulation, we get this solution instead:

.. plot:: ../plots/SOSIP1.py

.. topic:: Expanding on this mechanical example

   If you would like to see this example further developed, you may
   wish to jump to the set of examples involving rotational
   systems found in the section on :ref:`speed-measurement`.

   Otherwise, you can continue to the next set of examples which
   involve population dynamics.
