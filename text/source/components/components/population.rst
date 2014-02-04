.. _population-components:

Lotka-Volterra Equations Revisited
----------------------------------

In this section, we will revisit the :ref:`lotka-volterra-systems`
discussed in the first chapter.  However, this time we will create
system models from individual components.  After recreating the
behavior shown the first chapter, we'll expand the set of effects we
consider and reconfigure these component models into other system
models that demonstrate different dynamics.

Classic Lotka-Volterra
^^^^^^^^^^^^^^^^^^^^^^

We'll start by looking at the class Lotka-Volterra system.  In order
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
not come from engineering principles.  Instead, they really arise from
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

.. index:: encapsulated
.. index:: enumeration

.. todo:: Confirm this must be encapsulated

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
about this ``annotation`` both later in this chapter, when we are
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

.. image:: ../../../docs-dir/Icons/ModelicaByExample.Components.LotkaVolterra.Components.RegionalPopulation.svg
   :height: 200px
   :align: center


Reproduction
~~~~~~~~~~~~

Starvation
~~~~~~~~~~

Predation
~~~~~~~~~

.. figure:: /ModelicaByExample/Components/LotkaVolterra/Examples/ClassicLotkaVolterra.svg
   :width: 100%
   :align: center
   :alt: Component-oriented version of the classic Lotka-Volterra model
   :figclass: align-center

Introducing a Third Species
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Adding Wolves
~~~~~~~~~~~~~

Resulting Dynamics
~~~~~~~~~~~~~~~~~~

.. figure:: /ModelicaByExample/Components/LotkaVolterra/Examples/ThirdSpecies.svg
   :width: 100%
   :align: center
   :alt: Adding additional components to represent wolves and their interactions
   :figclass: align-center


Equilibrium
~~~~~~~~~~~

.. literalinclude:: /ModelicaByExample/Components/LotkaVolterra/Examples/ThreeSpecies_Quiescent.mo
   :language: modelica
