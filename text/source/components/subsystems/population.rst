Lotka-Volterra with Migration
-----------------------------

In this section, we will once again revisit the Lotka-Volterra models
to understand how we can build on the work we've already done of
creating reusable component models.  We will now take the next step
and create reusable models of individual geographical regions (each
with the usual population dynamics) and then connect those
geographical regions together with migration models.

Two Species Region
^^^^^^^^^^^^^^^^^^

The models in this section will all make use of the following model
that represents a region consisting of two populations, one of rabbits
and the other foxes, with the usual Lotka-Volterra population
dynamics.  The Modelica source code for the model is:

.. literalinclude:: /ModelicaByExample/Subsystems/LotkaVolterra/Components/TwoSpecies.mo
   :language: modelica
   :lines: 1-70,79

The diagram for this component is rendered as:

.. image:: /ModelicaByExample/Subsystems/LotkaVolterra/Components/TwoSpecies.*
   :width: 100%
   :align: center
   :alt: Region containing rabbits and foxes

This model will be used as the basis for the regional population
dynamics in subsequent models presented in this section.

Unconnected Regions
^^^^^^^^^^^^^^^^^^^

We'll start by building a model that consists of four unconnected
regions.  The Modelica source code for such a model is quite simple:

.. literalinclude:: /ModelicaByExample/Subsystems/LotkaVolterra/Examples/UnconnectedPopulations.mo
   :language: modelica

The diagram for this model is equally simple:

.. image:: /ModelicaByExample/Subsystems/LotkaVolterra/Examples/UnconnectedPopulations.*
   :width: 100%
   :align: center
   :alt: Four unconnected regional populations

If we simulate this model, each population should follow the same
trajectory since their initial conditions are identical.  The
following plot shows that this is, in fact, the case:

.. plot:: ../plots/Uncon.py
   :class: interactive

In a moment, we'll look at the effects of migration.  But in order to
fully appreciate the effect that migration has, we'll need to
introduce some differences in the evolution of the different regions.
So let's modify the initial conditions of the
``UnconnectedPopulations`` model to introduce some regional variation:

.. literalinclude:: /ModelicaByExample/Subsystems/LotkaVolterra/Examples/InitiallyDifferent.mo
   :language: modelica

Simulating this model, we see that each region has a slightly
different population dynamic:

.. plot:: ../plots/ID.py
   :class: interactive

Migration
^^^^^^^^^

Now that we have simulated the population dynamics in four
**unconnected** regions, it would be interesting to note the impact
that migration might have on these dynamics.

Consider the following Modelica model for migration:

.. literalinclude:: /ModelicaByExample/Subsystems/LotkaVolterra/Components/Migration.mo
   :language: modelica

This model looks at the population of both rabbits and foxes in the
connected regions and specifies a rate of migration that is
proportional to the difference in population between the regions.  In
other words, if there are more rabbits in one region than another, the
rabbits will move from the more populated region to the less
population region.  This is effectively a "diffusion" model of
migration and does not necessarily have a basis in ecology.  It is introduced simply as an
example of how we could add additional effects, on top of those
implemented in each region, to change the population dynamics between
regions.

If we connect our previously unconnected regions with migration paths,
*e.g.,*

.. literalinclude:: /ModelicaByExample/Subsystems/LotkaVolterra/Examples/WithMigration.mo
   :language: modelica

the resulting system diagram becomes:

.. image:: /ModelicaByExample/Subsystems/LotkaVolterra/Examples/WithMigration.*
   :width: 100%
   :align: center
   :alt: Four regional populations with migration paths

Simulating this system, we see that the population dynamics in the
different regions start off out of sync, but eventually stabilize into
repeating patterns:

.. plot:: ../plots/WM.py
   :class: interactive

Conclusion
^^^^^^^^^^

Earlier, we turned the Lotka-Volterra equations into components
representing predation, starvation and reproduction.  In this section,
we were able to use those component models to build up subsystem
models to represent the population dynamics in a particular region and
then link those subsystems together into a hierarchical system model
that also captured the effects of migration between these distinct
regions.
