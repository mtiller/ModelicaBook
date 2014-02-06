.. _chem-components:

Chemical Components
-------------------

For our last example of component oriented modeling, we'll return to
the :ref:`chemical-system` we discussed in the chapter on
:ref:`vectors-and-arrays`.  However, this time we will create
component models for the various effects and show how connections in
Modelica automatically ensure conservation of species.

Species
^^^^^^^

.. index:: enumeration

The species we will be dealing with in this example or defined by the
following ``enumeration``:

.. literalinclude:: /ModelicaByExample/Components/ChemicalReactions/ABX/Species.mo
   :language: modelica

Note that this definition exists within a package called ``ABX``.
This indicates that the component models are designed to work with
this three species system involving ``A``, ``B`` and ``X``.

``Mixture``
^^^^^^^^^^^

Also contained in the ``ABX`` package is the following ``connector``
definition (which can be found in the ``Interfaces`` sub-package):

.. literalinclude:: /ModelicaByExample/Components/ChemicalReactions/ABX/Interfaces/Mixture.mo
   :language: modelica

Here we see that our ``Mixture`` connector uses concentrations as the
across variables and a concentration rate as the flow variable.
Although the ``flow`` variable in this case is not strictly the flow
of a conserved quantity, it will suffice in this example since all
reactions are contained within the same volume.

Note that both ``C`` and ``R`` in this connector are arrays where the
subscript is given by an ``enumeration`` type.  We saw earlier how
:ref:`array-enum-dim` can be used in this way.

``Solution``
^^^^^^^^^^^^

Our first component model is used to track the concentration of the
various chemical species within a control volume.  As eluded to
earlier, since all reactions occur within the same volume, we don't
need to actually specify the volume of the control volume.

The ``Solution`` model is quite simple.  Like the
``RegionalPopulation`` model discussed :ref:`earlier in this chapter
<population-components>`, the rate of change of the across variable
associated with its sole connector is equal to the ``flow`` variable
on that same connector:

.. literalinclude:: /ModelicaByExample/Components/ChemicalReactions/ABX/Components/Solution.mo
   :language: modelica

Reactions
^^^^^^^^^

``Reaction``
~~~~~~~~~~~~

As we saw previously, this system has three reactions.  Each of the
specific reactions we'll examine extend from the following ``partial``
model:

.. literalinclude:: /ModelicaByExample/Components/ChemicalReactions/ABX/Interfaces/Reaction.mo
   :language: modelica

We see that each reaction has a reaction coefficient, ``k``, and a
``Mixture`` connector, ``mixture``, that ultimately connects it to the
``Solution`` where the reaction is to take place.  The internal
variables ``consumed`` and ``produced`` vectors play a role that is
similar to the ``decline`` and ``growth`` variables in the
``SinkOrSource`` :ref:`discussed earlier in this chapter
<reproduction-component>` (*i.e.,* they allow us to write
contributions from individual reactions using an intuitive
terminology).

``A+B->X``
~~~~~~~~~~

The first complete reaction model we will consider is the one that
turns one molecule of ``A`` and one molecule of ``B`` into one
molecule of ``X``.  Using the ``Reaction`` model, we can model this
reaction as follows:

.. literalinclude:: /ModelicaByExample/Components/ChemicalReactions/ABX/package.mo
   :language: modelica
   :lines: 3-11

The first thing to note about this model is that it is composed of
non-alphanumeric characters.  Specifically, the name of this model
contains ``+``, ``-`` and ``>``.  This is permitted in Modelica **as
long as the name is quoted using single quote characters**.  The rate
of the reaction, ``R``, is used in conjunction with the ``consumed``
and ``produced`` variables inherited from the ``Reaction`` model to
create equations that clearly describe both the reactants and the
products in this reaction.

``A+B<-X``
~~~~~~~~~~

The next reaction we will consider is one that takes one molecule of
``X`` and transforms it (back) into one molecule of ``A`` and one
molecule of ``B``.  This is the reverse of the previous reaction.  The
Modelica code for this reaction would be:

.. literalinclude:: /ModelicaByExample/Components/ChemicalReactions/ABX/package.mo
   :language: modelica
   :lines: 13-21

Again, the equations convey clearly which species are reactants
(*i.e.,* are consumed in the reaction) and which are the products
(*i.e.,* those species that are produced in the reaction).

``X+B->R+S``
~~~~~~~~~~~~

Finally, our last reaction converts molecules of ``X`` and ``B`` into
molecules of ``R`` and ``S``:

.. literalinclude:: /ModelicaByExample/Components/ChemicalReactions/ABX/package.mo
   :language: modelica
   :lines: 23-31

We do not track the concentration of the ``R`` and ``S`` species since
they are simply byproducts and do not participate in any other
reactions.  This model follows the same familiar pattern as before
with the exception that the ``A`` species is not involved.

System
^^^^^^

We can combine the ``Solution`` model along with the various reaction
models as follows:

.. literalinclude:: /ModelicaByExample/Components/ChemicalReactions/Examples/ABX_System.mo
   :language: modelica

Note how modifications to the ``solution`` component are used to set
the initial concentration of species within the ``solution``
component.  Also, the reaction coefficients are also specified via
modifications to each of the reaction components.  Finally, each of
the reaction components is attached to the ``solution.mixture``
connector.

Simulating this system for 10 seconds yields the following
concentration trajectories:

.. plot:: ../plots/ABX.py
   :include-source: no


