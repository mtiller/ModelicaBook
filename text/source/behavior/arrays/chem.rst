.. _chemical-system:

Chemical System
---------------

In this section, we'll consider a few different ways to describe the
behavior of a chemical system.  We'll start by building a model
without using the array functionality.  Then, we'll implement the same
behavior using vectors.  Finally, we'll implement the same model
again using enumerations.

In all of our examples, we'll be building a model for `the following
system of reactions <http://library.wolfram.com/examples/chemicalkinetics/>`_:

.. math::

      A + B &\underset{1}{\rightarrow} X \\
      A + B &\underset{2}{\leftarrow} X \\
      X + B &\underset{3}{\rightarrow} R + S

It should be noted that :math:`X` is simply an intermediate result of
this reaction.  The overall reaction can be expressed as:

.. math::

    A + 2B \rightarrow R + S

Using the law of mass action we can transform these chemical equations
into the following mathematical ones:

.. math::

    \frac{\mathrm{d}[A]}{\mathrm{d}t} &= -k_1 [A] [B] + k_2 [X] \\
    \frac{\mathrm{d}[B]}{\mathrm{d}t} &= -k_1 [A] [B] + k_2 [X] -k_3 [B] [X] \\
    \frac{\mathrm{d}[X]}{\mathrm{d}t} &= k_1 [A] [B] - k_2 [X] -k_3 [B] [X]

where :math:`k_1`, :math:`k_2` and :math:`k_3` are the reaction coefficients for the first, second and third reactions, respectively.
These
equations are derived by considering the change in each species due to
each reaction involving that species.  So, for example, since the
first reaction :math:`A + B \rightarrow X` transforms
molecules of :math:`A` and :math:`B` into molecules of :math:`X`, we
see the term :math:`-k_1 [A] [B]` in the balance equation for
:math:`A`, which represents the reduction in the amount of :math:`A` as
a result of that reaction.  Each term in these balance equations is
derived in a similar fashion.


Without Arrays
^^^^^^^^^^^^^^

Let us start with an approach that doesn't utilize arrays at all.  In
this case, we simply represent the concentrations :math:`[A]`,
:math:`[B]` and :math:`[X]` by the variables ``cA``, ``cB`` and
``cX`` as follows:

.. literalinclude:: /ModelicaByExample/ArrayEquations/ChemicalReactions/Reactions_NoArrays.mo
   :language: modelica
   :lines: 2-

With this approach, we create an equation for the balance of each
species.  If we simulate this model, we get the following results:

.. plot:: ../plots/RNA.py
   :class: interactive

Using Arrays
^^^^^^^^^^^^

Another way to approach modeling of the chemical system is to use
vectors.  With this approach, we associated the species :math:`A`,
:math:`B` and :math:`X` with the indices :math:`1`, :math:`2` and
:math:`3`, respectively.  The concentrations are mapped to the vector
variable ``C``.  We can also cast the reaction coefficients into a
vector of reaction coefficients, ``k``.

With this transformation, all the equations are then transformed into
vector equations:

.. literalinclude:: /ModelicaByExample/ArrayEquations/ChemicalReactions/Reactions_Array.mo
   :language: modelica
   :lines: 2-

The reaction equations are non-linear, so they cannot be transformed
into a completely linear form.  But we could simplify them further by
using a matrix-vector product.  In other words, the equations:

.. math::

    \frac{\mathrm{d}[A]}{\mathrm{d}t} &= -k_1 [A] [B] + k_2 [X] \\
    \frac{\mathrm{d}[B]}{\mathrm{d}t} &= -k_1 [A] [B] + k_2 [X] -k_3 [B] [X] \\
    \frac{\mathrm{d}[X]}{\mathrm{d}t} &= k_1 [A] [B] - k_2 [X] -k_3 [B] [X]

can be transformed into the following form:

.. math::

   \frac{\mathrm{d}}{\mathrm{d}t}
   \left\{
   \begin{array}{c}
   [A] \\[0pt] [B] \\[0pt] [X]
   \end{array}
   \right\} =
   \left[
   \begin{array}{rrr}
   -k_1 [B] & 0 & k_2 \\
   -k_1 [B] & -k_3 [X] & k_2 \\
   k_1 [B] & -k_3 [X] & -k_2
   \end{array}
   \right]
   \left\{
   \begin{array}{c}
   [A] \\[0pt] [B] \\[0pt] [X]
   \end{array}
   \right\}

which can then be represented in Modelica as:

.. code-block:: modelica

    der(C) = [-k[1]*C[2], 0,          k[2];
              -k[1]*C[2], -k[3]*C[3], k[2];
              k[1]*C[2],  -k[3]*C[3], -k[2]]*C;

The drawback of this approach is that we have to constantly keep track
of which index (*e.g.,* ``1``, ``2``, or ``3``) corresponds to which
species (*e.g.,* :math:`A`, :math:`B`, or :math:`X`).

Using Enumerations
^^^^^^^^^^^^^^^^^^

To address this issue of having to map back and forth from numbers to
names, our third approach will utilize the ``enumeration`` type in
Modelica.  An enumeration allows us to define a set of names which we
can then use to define the subscripts associated with an array.  We'll
define our enumeration as follows:

.. code-block:: modelica

    type Species = enumeration(A, B, X);

This defines a special type named ``Species`` that has exactly three
possible values, ``A``, ``B`` and ``X``.  We can then use this
enumeration **as a dimension in an array** as follows:

.. code-block:: modelica

    Real C[Species];

Since the ``Species`` type has only three possible values, this means
that the vector ``C`` has exactly three components.  We can then refer
to the individual components of ``C`` as ``C[Species.A]``,
``C[Species.B]`` and ``C[Species.X]``.

Because it is awkward to constantly prefix each species name with
``Species``, we can define a few convenient constants as follows:

.. code-block:: modelica

    constant Species A = Species.A;
    constant Species B = Species.B;
    constant Species X = Species.X;

In this way, we can now refer to the concentration of species
:math:`A` as ``C[A]``.  Pulling all of this together we can represent
our chemical system using enumerations as:

.. literalinclude:: /ModelicaByExample/ArrayEquations/ChemicalReactions/Reactions_Enum.mo
   :language: modelica
   :lines: 2-

.. plot:: ../plots/RE.py
   :class: interactive

Conclusion
^^^^^^^^^^

In this chapter, we showed how a set of chemical equations could be
represented with and without arrays. We also  
demonstrated how the ``enumeration`` type can
be used in conjunction with arrays to make the resulting equations
more readable by replacing numeric indices with names.
Furthermore, this section also demonstrated how the ``enumeration``
type can be used not only to index the array, but also to define one or
more dimensions in the declaration.
