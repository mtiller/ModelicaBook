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

The species we will be dealing with in this example are defined by the
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
various chemical species within a control volume.  As alluded to
earlier, since all reactions occur within the same volume, we don't
need to actually specify the size of the control volume.

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
vector variables ``consumed`` and ``produced`` play a role that is
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

.. code-block:: modelica

    model 'A+B->X' "A+B -> X"
      extends Interfaces.Reaction;
    protected
      Interfaces.ConcentrationRate R = k*C[Species.A]*C[Species.B];
    equation
      consumed[Species.A] = R;
      consumed[Species.B] = R;
      produced[Species.X] = R;
    end 'A+B->X';

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

.. code-block:: modelica

    model 'A+B<-X' "A+B <- X"
      extends Interfaces.Reaction;
    protected
      Interfaces.ConcentrationRate R = k*C[Species.X];
    equation
      produced[Species.A] = R;
      produced[Species.B] = R;
      consumed[Species.X] = R;
    end 'A+B<-X';

Again, the equations convey clearly which species are reactants
(*i.e.,* are consumed in the reaction) and which are the products
(*i.e.,* those species that are produced in the reaction).

``X+B->T+S``
~~~~~~~~~~~~

Finally, our last reaction converts molecules of ``X`` and ``B`` into
molecules of ``T`` and ``S``:

.. code-block:: modelica

    model 'X+B->T+S' "X+B->T+S"
      extends Interfaces.Reaction;
    protected
      Interfaces.ConcentrationRate R = k*C[Species.B]*C[Species.X];
    equation
      consumed[Species.A] = 0;
      consumed[Species.B] = R;
      consumed[Species.X] = R;
    end 'X+B->T+S';

We do not track the concentration of the ``T`` and ``S`` species since
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
component.  Also, the reaction coefficients are specified via
modifications to each of the reaction components.  Finally, each of
the reaction components is attached to the ``solution.mixture``
connector.


Simulating this system for 10 seconds yields the following
concentration trajectories:

.. plot:: ../plots/ABX.py
   :include-source: no

Conclusion
^^^^^^^^^^

From our earlier discussion of this chemical system, you may recall
that the resulting system of equations was:

.. math::

    \frac{\mathrm{d}[A]}{\mathrm{d}t} &= -k_1 [A] [B] + k_2 [X] \\
    \frac{\mathrm{d}[B]}{\mathrm{d}t} &= -k_1 [A] [B] + k_2 [X] -k_3 [B] [X] \\
    \frac{\mathrm{d}[X]}{\mathrm{d}t} &= \phantom{-}k_1 [A] [B] - k_2 [X] -k_3 [B] [X]

Each equation represents the accumulation of a particular species and
each term on the right hand side of those equations is computing the
net flow of that particular species into the control volume.
Constructing this system by hand for even a relatively small number of
participating species is rife with opportunities to introduce errors.
By using a component oriented approach instead, we never had to
assemble such a system of equations.  As a result, these equations
were generated automatically.  By automating this process, we can
avoid many potential errors and the time required to identify and fix
them.
