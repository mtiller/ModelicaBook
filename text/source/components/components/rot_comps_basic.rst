.. _rotational-components:

Basic Rotational Components
---------------------------

In this section, we'll show how to create basic components for
modeling one-dimensional rotational systems.  We'll build on our
discussion of rotational connectors and show how they can be used to
define the interfaces for basic rotational components.  Finally, we'll
show how those rotational components can then be assembled into a
system model that replicates the behavior of the equation-based
version of the same system presented in the first chapter.

Component Models
^^^^^^^^^^^^^^^^

In the first chapter, we considered :ref:`mech-example` modeled
strictly in terms of equations (*i.e.,* without component models).  In
this section, we will start by recreating that system model using
components.  To do this, we first have to define models for the
fundamental components we require.  These will consist of
models for an inertia, a spring, a damper and a mechanical ground.

As in :ref:`the previous section<electrical-components>`, we will
first define the component models using verbose formulations and then
we will revisit these definitions and attempt to factor out common
code to avoid repetition across component models.

Coordinate Systems
~~~~~~~~~~~~~~~~~~

The method for creating these models will be very similar to how we
previously created component models in the heat transfer and
electrical domains.  But before we start building component models, we
should first discuss one of the complexities associated with
mechanical systems, coordinate systems.

In the mechanical domain, the conserved quantity we will be tracking
is momentum.  What makes momentum different from the conserved
quantities we've already covered, heat and charge, is that it is
directional.  Since we are only concerning ourselves with the one
dimensional case here, the consequence of this directionality is that
momentum is a signed quantity (*i.e.,* it can be positive or
negative).

.. todo::

   Add a figure here

Consider a rotating mass with a moment of inertia, :math:`J`.  If
the angular position of the inertia is represented by :math:`\varphi`,
then the angular velocity of the inertia, :math:`\omega`, is defined
as:

.. math::

    \omega = \dot{\varphi}

Obviously, a positive value of :math:`\omega` will result in an
increase in :math:`\varphi` over time.  Furthermore, the angular
acceleration of the inertia, :math:`\alpha`, is defined as:

.. math::

    \alpha = \dot{\omega}

As with the angular velocity, we can see that a positive value for
:math:`\alpha` will result in an increase in the angular velocity.
Finally, the angular momentum of this rotating inertia is defined as
:math:`J \omega` and we know from Euler's laws of motion that
(assuming J is a constant):

.. math::

    J \frac{\mathrm{d}\omega}{\mathrm{d}t} = \tau

From this relationship, it is clear that a positive value for the
torque, :math:`\tau`, will increase the amount of momentum stored in
the mass.

The point of presenting all these relationships is to underscore the
sign conventions associated with :math:`\varphi`, :math:`\omega`,
:math:`\alpha` and :math:`\tau`.  They are all tied to the fundamental
definition of what a positive angular position is.  **Whatever
direction causes** :math:`\varphi` **to increase is the same direction
that corresponds to a positive velocity, a positive acceleration and a
positive torque**.

Rotational Inertia
~~~~~~~~~~~~~~~~~~

With this discussion about sign conventions and coordinate systems out
of the way, we can start creating our component models.  We'll start
with the inertia model:

.. literalinclude:: /ModelicaByExample/Components/Rotational/VerboseApproach/Inertia.mo
   :language: modelica
   :lines: 1-23,46

The ``Inertia`` model includes two "flanges", one on either end.  The
significance of these flanges is made clearer from the icon of the
``Inertia`` model:

.. image:: ../../../docs-dir/Icons/ModelicaByExample.Components.Rotational.VerboseApproach.Inertia.*
   :height: 200px
   :align: center

In other words, the ``Inertia`` model includes a flange on either end.
You can think of this model as a shaft with connectors on either end.

Now, the fundamental equation we wish to capture in the ``Inertia`` model
is:

.. literalinclude:: /ModelicaByExample/Components/Rotational/VerboseApproach/Inertia.mo
   :language: modelica
   :lines: 19-20

This is basically expressing the fact that the increase in momentum
stored within the inertia is equal to the sum of the torques applied
to the inertia. Recall, from our previous discussions on
:ref:`acausal-connections`, that the sign convention for flow
variables on connectors (``flange_a.tau`` and ``flange_b.tau`` in this
case) is that a positive value represents a flow of the conserved
quantity into the component model.  The fact that ``flange_a`` and
``flange_b`` have the same sign convention means that the ``Inertia``
model is symmetric (*i.e.,* it can be flipped over and it doesn't
change the behavior).

However, this equation refers to the internal variables ``w`` (which
represents :math:`\omega`) and ``tau`` so we need to include
declarations and definitions for those variables as well.

Spring Model
~~~~~~~~~~~~

Next, let us consider the definition of a spring model:

.. literalinclude:: /ModelicaByExample/Components/Rotational/VerboseApproach/Spring.mo
   :language: modelica
   :lines: 1-20,41

The icon for our spring model is rendered as:

.. image:: ../../../docs-dir/Icons/ModelicaByExample.Components.Rotational.VerboseApproach.Spring.*
   :height: 200px
   :align: center

Like the ``Inertia`` model, the ``Spring`` model has two connectors,
one on each end.  It also defines many of the same internal
variables.  Ultimately, the behavior of the spring comes down to this
equation:

.. literalinclude:: /ModelicaByExample/Components/Rotational/VerboseApproach/Spring.mo
   :language: modelica
   :lines: 19-20,41

In fact, apart from this equation and the parameter ``c``, much of the
content in the ``Spring`` model is the same as the content in the
``Inertia`` model.

Damper Model
~~~~~~~~~~~~

The ``Damper`` model is also very similar to the ``Spring`` model.
Again, the main differences are the parameter (``d`` in this case) and
one equation:

.. literalinclude:: /ModelicaByExample/Components/Rotational/VerboseApproach/Damper.mo
   :language: modelica
   :emphasize-lines: 19-20
   :lines: 1-20,43

The icon for the ``Damper`` model is rendered as:

.. image:: ../../../docs-dir/Icons/ModelicaByExample.Components.Rotational.VerboseApproach.Damper.*
   :height: 200px
   :align: center

.. _dry-components:

DRY Component Models
^^^^^^^^^^^^^^^^^^^^

We already have models for an inertia, a spring and a damper.  The
only model we are missing in order to complete our :ref:`dual spring
mass damper system<mech-example>` is a model of mechanical ground.
But before we complete that model, let's take a moment to revisit the
models we've already created with the goal of factoring out the large
amount of code shared between these models.  As in :ref:`the previous
section<electrical-components>`, let's take the time to apply the DRY
(Don't Repeat Yourself) principle.

Common Code
~~~~~~~~~~~

It is worth noting that because the Modelica Standard Library has an
extensive collection of rotational components, it was forced to deal
with this issue of redundant code almost from the start.  However, we
will not be using the ``partial`` models from the Modelica Standard
Library here simply because they are designed to deal with many other
cases that are not relevant in this context.  As a result, it's
complexity (although necessary) makes it unsuitable pedagogically.

But one thing we will preserve from the Modelica Standard Library is
the need for multiple ``partial`` models.  This need arises from the
fact that, unlike in our previous discussion of
:ref:`electrical-components`, our rotational component models share
different amounts of code with each other.

What is common to all of our models is the existence of two flange
connectors, ``flange_a`` and ``flange_b``.  However, while the
``Inertia`` model has the capacity to store angular momentum, the
``Spring`` and ``Damper`` models do not.  As a result, the
conservation equations are different among these components.

Let's start with the elements that are common to all three models.
These are represented by the following ``TwoFlange`` model:

.. literalinclude:: /ModelicaByExample/Components/Rotational/Interfaces/TwoFlange.mo
   :language: modelica

In addition to defining the two flanges, ``flange_a`` and
``flange_b``, this model also defines the relative angle between these
flanges, *i.e.,* ``phi_rel``.  Of course, this model is also marked as
``partial`` since it is missing any description of the component's
behavior.

We could have all three models inherit from this model.  But then we
would still have some redundant equations between our ``Spring`` and
``Damper`` model.  So we will instead create a slightly more
specialized version of the ``TwoFlange`` model to represent compliant
models that do not store momentum:

.. literalinclude:: /ModelicaByExample/Components/Rotational/Interfaces/Compliant.mo
   :language: modelica

The ``Compliant`` model adds on additional internal variable (to
represent the torque that passes through the component from
``flange_a`` to ``flange_b``) and an equation indicating that no
angular momentum is stored by the component.

With these base classes defined, let us quickly revisit the various
component model definitions to see how much more succinct they can be
made by using inheritance.

Rotational Inertia
~~~~~~~~~~~~~~~~~~

Leveraging the ``TwoFlanges`` model, our ``Inertia`` model can be
simplified to:

.. literalinclude:: /ModelicaByExample/Components/Rotational/Components/Inertia.mo
   :language: modelica
   :lines: 1-14,43

Spring Model
~~~~~~~~~~~~

In the same way, inheriting from the ``Compliant`` model our
``Spring`` model can be much more compactly represented as:

.. literalinclude:: /ModelicaByExample/Components/Rotational/Components/Spring.mo
   :language: modelica
   :lines: 1-6,27

Damper Model
~~~~~~~~~~~~

Likewise, the ``Damper`` model is similarly simplified:

.. literalinclude:: /ModelicaByExample/Components/Rotational/Components/Damper.mo
   :language: modelica
   :lines: 1-6,29

Mechanical Ground
~~~~~~~~~~~~~~~~~

Finally, we can complete the one model remaining in order to complete
our :ref:`dual spring mass damper system<mech-example>`.  The
mechanical ground model is defined as follows:

.. literalinclude:: /ModelicaByExample/Components/Rotational/Components/Damper.mo
   :language: modelica
   :lines: 1-7,61

Dual Spring Mass Damper System
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Finally, we have all the parts we need in order to reconstruct the
example we saw in the first chapter.  Using the various components
already defined in this section, the Modelica code for our component
based system model looks like this:

.. literalinclude:: /ModelicaByExample/Components/Rotational/Examples/SMD.mo
   :language: modelica

The diagram for this model, when rendered, looks like this:

.. image:: /ModelicaByExample/Components/Rotational/Examples/SMD.*
   :width: 100%
   :align: center
   :alt: 

.. plot:: ../plots/SMD.py
   :class: interactive

This completes our discussion of basic rotational components.  But
there is quite a bit more to say about rotational components in the
next section on :ref:`adv-rotational-components`.
