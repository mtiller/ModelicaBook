.. _population-components:

Lotka-Volterra Equations Revisited
----------------------------------

In this section, we will revisit the :ref:`lotka-volterra-systems`
discussed in the first chapter.  However, this time we will create
system models from individual components.  After recreating the
behavior shown in the first chapter, we'll expand the set of effects we
consider and reconfigure these component models into other system
models that demonstrate different dynamics.

Classic Lotka-Volterra
^^^^^^^^^^^^^^^^^^^^^^

We'll start by looking at the classic Lotka-Volterra system.  In order
to create such a system using component models, we will require models
to represent the population of both rabbits and foxes as well as
models for reproduction, starvation and predation.

Connectors
~~~~~~~~~~

However, as we learned during our discussion of :ref:`connectors`,
before we can start building component models we first need to
formally define the information that will be exchanged by interacting
components by defining connectors.  The ``connector`` we will use in
this section is the ``Species`` connector and it is defined as follows:

.. literalinclude:: /ModelicaByExample/Components/LotkaVolterra/Interfaces/Species.mo
   :language: modelica
   :lines: 1-4,22

This connector definition is interesting because these definitions do
not come from engineering.  Instead, they really arise from
ecology.  In this case, our across variable is ``population`` which
represents the actual number of animals of a particular species.  Our
through variable, indicated by the presence of the ``flow`` qualifier,
is ``rate`` which represents the rate at which new animals "enter" the
component that this connector is attached to.

Regional Population
~~~~~~~~~~~~~~~~~~~

To track the population of a given species in one region, we'll use
the ``RegionalPopulation`` model.  The model has several noteworthy
aspects so we'll present the model piece by piece starting with:

.. literalinclude:: /ModelicaByExample/Components/LotkaVolterra/Components/RegionalPopulation.mo
   :language: modelica
   :lines: 1-6

.. todo:: Confirm this must be encapsulated

.. index:: encapsulated
.. index:: enumeration

The first two lines are as expected.  But after that we see that this
model defines a type called ``InitializationOptions``.  The type
definition is qualified with the ``encapsulated`` keyword.  This is
necessary because the type is being defined within a model and not a
package.  Modelica has a rule that if we wish to refer to this type
from outside the ``model`` definition, the type definition must be
prefixed by ``encapsulated``.  We can see from the definition of this
``enumeration`` that it defines three distinct values: ``Free``,
``FixedPopulation`` and ``SteadyState``.  We'll see how these values
will be used shortly.

The first declarations in our ``RegionalPopulation`` model is:

.. literalinclude:: /ModelicaByExample/Components/LotkaVolterra/Components/RegionalPopulation.mo
   :language: modelica
   :lines: 7-8

Note that the first ``parameter``, ``init``, utilizes the
``InitializationOptions`` enumeration both to specify its type (the
enumeration itself) and its initial value, ``Free``.  Also note the
presence of the ``choicesAllMatching`` annotation.  We'll talk more
about this ``annotation`` later in this chapter, when we are
reviewing the concepts introduced here, and in subsequent chapters.

The next declaration is:

.. literalinclude:: /ModelicaByExample/Components/LotkaVolterra/Components/RegionalPopulation.mo
   :language: modelica
   :lines: 9-11

The ``initial_population`` parameter is used to represent the initial
value for the population in this region at the start of the
simulation.  However, as we will see shortly in the equation section,
this value is only used if the value of ``init`` is set to
``FixedPopulation``.  For this reason, the ``enable`` annotation on
this ``parameter`` is set to
``init==InitializationOptions.FixedPopulation``.  This annotation is
used to inform Modelica tools of this relationship.  This information
can then be taken into account when building graphical user interfaces
(*e.g.,* a parameter dialog) associated with this model.


It is also worth noting the presence of the ``Dialog`` annotation in
the definition of ``initial_population``.  This annotation allows the
model developer to organize parameters into categories, in this case
"Initialization".  Tools generally use such information to help
structure parameter dialogs.

The last public declaration in the model is for the ``connector``
instance that allows interactions with other components:

.. literalinclude:: /ModelicaByExample/Components/LotkaVolterra/Components/RegionalPopulation.mo
   :language: modelica
   :lines: 12-14

Here we again see the :ref:`placement` annotation which we will again
defer talking about for the moment.  This leaves the last declaration,
which happens to be ``protected``:

.. literalinclude:: /ModelicaByExample/Components/LotkaVolterra/Components/RegionalPopulation.mo
   :language: modelica
   :lines: 15-16

This variable represents the number of animals in this region.  It is
given a non-zero ``start`` value to avoid the trivial solutions we saw
in our earlier discussion of :ref:`steady-state` of Lotka-Volterra
systems.  We can also see, from this declaration, that this
declaration equates the local variable, ``population``, with the value
of the across variable on the ``species`` connector,
``species.population``.  In effect, the ``population`` variable is an
alias for the expression ``species.population``.

Now that we have the declarations out of the way, let's look at the
equations associated with the ``RegionalPopulation`` model:

.. literalinclude:: /ModelicaByExample/Components/LotkaVolterra/Components/RegionalPopulation.mo
   :language: modelica
   :lines: 17-26,87

The ``initial equation`` demonstrates the significance that the value
of the ``init`` parameter has on the behavior of this component.  In
the case that the ``init`` value is equal to the ``FixedPopulation``
value in the ``InitializationOptions`` enumeration, an equation is
introduced specifying that the value of the ``population`` variable at
the start of the simulation is equal to the ``initial_population``
parameter.  If, on the other hand, the value of ``init`` is equal to
the ``SteadyState`` value of the enumeration, then an equation is
introduced specifying that the rate of population change at the start
of the simulation must be zero.  Obviously, if ``init`` is equal to
``Free`` (the last remaining possibility), no initial equation is
introduced.

Within the ``equation`` section, we see that the rate at which the
``population`` changes is equal to the value of the ``flow`` variable
on the ``species`` connector, ``species.rate``.  Again, recall the
sign convention that a positive value for a ``flow`` variable means a
flow into the component and the fact that this equation is consistent
with that sign convention (*i.e.,* a positive value for
``species.rate`` will have the effect of increasing the ``population``
within the region).

.. index:: assert

The last thing worth noting about the model is the presence of the
``assert`` call in the ``equation`` section.  This is used to define a
model boundary (*i.e.,* a point beyond which the equations in the
model are not valid).  It is used to enforce the constraint that the
population within a region cannot be less than zero.  If a solution is
ever found where the constraint is violated, the resulting error
message will be "Population must be greater than zero".

This model also has an ``Icon`` annotation associated with the model
definition.  As usual, the ``Icon`` annotation is not included in the
source listing.  But when this component model is rendered within a
system model, its icon will look like this:

.. image:: ../../../docs-dir/Icons/ModelicaByExample.Components.LotkaVolterra.Components.RegionalPopulation.*
   :height: 200px
   :align: center

.. _reproduction-component:

Reproduction
~~~~~~~~~~~~

The first real effect we will examine is reproduction.  As we know
from our previous discussion, the growth in a given population due to
reproduction is proportional to the number of animals of
that species in a given region.  As a result, we can describe
reproduction very succinctly as:

.. literalinclude:: /ModelicaByExample/Components/LotkaVolterra/Components/Reproduction.mo
   :language: modelica
   :lines: 1-6,49

where ``alpha`` is the proportionality constant.  However, the
simplicity and clarity of this model is due mostly to the inheritance
of the ``SinkOrSource`` model in much the same way that our "DRY"
:ref:`electrical-components` benefited from inheriting the ``TwoPin``
model.

The ``SinkOrSource`` model is a starting point for any model that
either creates or destroys animals in a population.  It is defined as
follows:

.. literalinclude:: /ModelicaByExample/Components/LotkaVolterra/Interfaces/SinkOrSource.mo
   :language: modelica
   :lines: 1-11,18

To understand these equations it is first necessary to understand that
any model that ``extends`` from ``SinkOrSource`` will generally be
connected to a ``RegionalPopulation`` instance (but will not, itself,
**be** a ``RegionalPopulation`` model).  This means that if the
``flow`` variable ``species.rate`` in such an instance is positive, it
will have the effect of pulling animals **out** of the
``RegionalPopulation`` model.  Looking at the ``SinkOrSource`` model
in this way, we can see that the variable ``decline`` is simply an
alias for ``species.rate``.  In other words, when ``decline`` has a
positive value, ``species.rate`` will have a positive value and,
therefore, any ``RegionalPopulation`` that this ``SinkOrSource``
instance is connected to will suffer a drain on its population.
Conversely, the ``growth`` variable is positive when ``species.rate``
is negative.  In that case, the connected ``RegionalPopulation`` model
will see an increase in species population.

By defining the ``SinkOrSource`` model and inheriting from it, much of
this complexity is hidden.  As a result, models like ``Reproduction``
can have equations written in a way that make their behavior more intuitive,
*e.g.,* ``growth = alpha*species.population``.

Although not shown, the ``Icon`` for the ``Reproduction`` model is
rendered as:

.. image:: ../../../docs-dir/Icons/ModelicaByExample.Components.LotkaVolterra.Components.Reproduction.*
   :height: 200px
   :align: center

Starvation
~~~~~~~~~~

Just like the ``Reproduction`` model just described, the
``Starvation`` model also inherits from the ``SinkOrSource`` model.
However, its behavior with respect to the
``decline`` variable, is described as follows:

.. code-block:: modelica

    within ModelicaByExample.Components.LotkaVolterra.Components;
    model Starvation "Model of starvation"
      extends Interfaces.SinkOrSource;
      parameter Real gamma "Starvation coefficient";
    equation
      decline = gamma*species.population
        "Decline is proporational to population (competition)";
    end Starvation;

Predation
~~~~~~~~~

The last effect we need to consider before building a system model to
represent the classic Lotka-Volterra behavior is a model for
predation.

Recall our previous discussion of the ``SinkOrSource`` model and the
potential confusion associated with sign conventions.  The
``SinkOrSource`` model was designed to work with effects that only
interacted with a single ``RegionalPopulation`` (since it had only one
``Species`` connector).  In order to address the same potential sign
convention confusion for effects that involve interactions between two
different regional populations, the following ``partial`` model,
``Interaction`` was defined:

.. literalinclude:: /ModelicaByExample/Components/LotkaVolterra/Interfaces/Interaction.mo
   :language: modelica
   :lines: 1-16,23

Again, we have the concepts of growth and decline variables.  However
this time we have two version of each.  One is associated with the
``a`` connector and the other is associated with the ``b`` connector.

Using these definitions, we can define ``Predation`` very simply as:

.. literalinclude:: /ModelicaByExample/Components/LotkaVolterra/Components/Predation.mo
   :language: modelica
   :lines: 1-8,43

This model captures the effect that the growth in the "B" (predator)
population is proportional to the product of the predator and prey
populations.  Similarly, the decline in the "A" (prey) population is
also proportional the product of the predator and prey populations
(although with a different proportionality constant).

Although not shown, the ``Icon`` for the ``Predation`` model is
rendered as:

.. image:: ../../../docs-dir/Icons/ModelicaByExample.Components.LotkaVolterra.Components.Predation.*
   :height: 200px
   :align: center

Note that the ``Predation`` model is asymmetric.  The ``b`` connector
should be connected to the predator population and the ``a`` connector
should be connected to the prey population.  This is reinforced by the
image and asymmetry of the icon itself.

Classic System Model
~~~~~~~~~~~~~~~~~~~~

With all of these components in hand, we can very easily construct a
component-oriented version of the classic Lotka-Volterra behavior by
dragging and dropping the components into the following system
configuration:

.. figure:: /ModelicaByExample/Components/LotkaVolterra/Examples/ClassicLotkaVolterra.*
   :width: 100%
   :align: center
   :alt: Component-oriented version of the classic Lotka-Volterra model
   :figclass: align-center

Here we see that the ``Starvation`` model is attached to the ``foxes``
population while the ``Reproduction`` model is attached to the
``rabbits`` population.  The ``Predation`` model is connected to both
populations with the ``a`` (prey) connector attached to the
``rabbits`` and the ``b`` (predator) connector attached to the ``foxes``.

As we can see from the following plot, the behavior of this system is
identical to the one presented in our earlier discussion of :ref:`lotka-volterra-systems`:

.. plot:: ../plots/CLV.py
   :class: interactive

Introducing a Third Species
^^^^^^^^^^^^^^^^^^^^^^^^^^^

As we will see over and over again, there is an initial investment in
building component models over simply typing the equations that they
encapsulate.  But there is also a significant "payoff" to this process
because of the schematic based system composition that is then
possible as a result.  In the context of the Lotka-Volterra example,
this is exemplified by the addition of a third species, wolves, to the
classic Lotka-Volterra system.

Adding Wolves
~~~~~~~~~~~~~

The creation of a model with a third species does not require any
additional component models to be defined.  Instead, we can reuse not
only our existing models for ``Predation``, ``Starvation`` and
``RegionalPopulation``, but we can also reuse the
``ClassicLotkaVolterra`` model itself:

.. literalinclude:: /ModelicaByExample/Components/LotkaVolterra/Examples/ThirdSpecies.mo
   :language: modelica

Such a model would not typically be created by typing in the source
code you see above.  Instead, within a graphical development
environment it would take less than a minute to assemble such a system
by augmenting the existing ``ClassicLotkaVolterra`` model.  When
visualized, the schematic for the resulting system is rendered as:

.. figure:: /ModelicaByExample/Components/LotkaVolterra/Examples/ThirdSpecies.*
   :width: 100%
   :align: center
   :alt: The Classic Lotka-Volterra model augmented with an additional
	 predatory species
   :figclass: align-center


Resulting Dynamics
~~~~~~~~~~~~~~~~~~

By creating such a model, we can quickly explore the differences in
system dynamics between the classic model and this three species
model.  The following plot shows how these three species interact:

.. plot:: ../plots/ThirdS.py
   :class: interactive

By using the ``init`` parameter in the various ``RegionalPopulation``
instances, we can also quickly create a model to solve for the
equilibrium population levels for all three species:

.. literalinclude:: /ModelicaByExample/Components/LotkaVolterra/Examples/ThreeSpecies_Quiescent.mo
   :language: modelica

All that is required in this model is to extend from the
``ThirdSpecies`` model and modify the ``init`` parameter for each of
the underlying species populations.  Simulating this model gives us
the equilibrium population level for each species:

.. plot:: ../plots/ThreeS.py
   :class: interactive

From an ecological standpoint, we can already make an interesting
observation about this system.  If we start it from a non-equilibrium
condition the system quickly goes unstable.  In other words, the
introduction of wolves into the otherwise stable eco-system involving
only rabbits and foxes has a significant impact on the population
dynamics.
