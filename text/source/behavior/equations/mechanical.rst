.. _mech-example:

A Mechanical Example
--------------------

If you are more familiar with mechanical systems, this example might
help reinforce some of the concepts we've covered so far.  The system
we wish to model is the one shown in the following figure:

.. todo::

   Add a figure here of the two inertia system

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
rotational position, :math:`\phi`, and a rotational speed,
:math:`\omega` where :math:`\omega = \dot{\phi}`.  For each inertia,
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

.. math:: \tau = k \Delta \phi

For each damper, we express the relationship between torque and
relative angular velocity as:

.. math:: \tau = d \Delta \dot{phi}

If we pull together all of these relations, we get the following
system of equations:

.. math::
   :nowrap:

    \begin{aligned}
    \omega_1 &amp; = \dot{\phi_1} \\
    J_1 \dot{\omega_1} &amp; = k_1 (\phi_2-\phi_1) + d_1 \frac{d (phi_2-phi_1)}{dt} \\
    \omega_2 &amp; = \dot{\phi_2} \\
    J_2 \dot{\omega_2} &amp; = k_1 (\phi_1-\phi_2) + d_1 \frac{d (phi_1-phi_2)}{dt} - k_2 \phi_2 - d_2 \dot{phi_2}
    \end{aligned}

Let's assume our system has the following initial conditions as well:

.. math::
   :nowrap:

    \begin{aligned}
    \phi_1 &amp; = 0 \\
    \omega_1 &amp; = 0 \\
    \phi_2 &amp; = 1 \\
    \omega_2 &amp; = 0
    \end{aligned}

These initial conditions essentially mean that the system starts in a
state where neither inertia is actually moving (*i.e.*,
:math:`\omega=0`) but there is a non-zero deflection across both
springs.

Pulling all of these variables and equations together, we can express
this problem in Modelica as follows:

.. literalinclude:: /ModelicaByExample/BasicEquations/RotationalSMD/SecondOrderSystem.mo
   :language: modelica
   :lines: 2-

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

.. todo::

   There should be a plot here

.. plot:: ../plots/SOSIP.py
   :include-source: no

However, if modify the ``phi1_init`` parameter to be *1* at the start
of our simulation, we get this solution instead:

.. todo::

   Here too

.. plot:: ../plots/SOSIP1.py
   :include-source: no

.. topic:: Expanding on this mechanical example

   If you would like to see this example further developed, you may
   wish to jump to the next set of examples involving rotational
   systems found in the section on :ref:`speed-measurement`.

   Otherwise, you can continue to the next set of examples which
   involve population dynamics.
