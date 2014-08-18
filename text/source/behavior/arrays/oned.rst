.. _one-dimensional-heat-transfer:

One-Dimensional Heat Transfer
-----------------------------

Our previous discussion on :ref:`state-space` introduced matrices and
vectors.  The focus was primarily on mathematical aspects of arrays.
In this section, we will consider how arrays can be used to represent
something a bit more physical, the one-dimensional spatial
distribution of variables.  We'll look at several features in Modelica
that are related to arrays and how they allow us to compactly express
behavior involving arrays.

Our problems will center around the a simple heat transfer problem.
Consider a one-dimensional rod like the one shown below:

.. image:: /_static/img/bar.*
   :width: 50%
   :align: center
   :alt: Discretization of a one-dimensional bar

Deriving Equations
^^^^^^^^^^^^^^^^^^

Let us consider the heat balance for each discrete section of this
rod.  First, we have the thermal capacitance of the :math:`i^{th}`
section.  This can expressed as:

.. math::

    m_i C T_i

where :math:`m` is the mass of the :math:`i^{th}` section, :math:`C`
is the capacitance (a material property) and :math:`T_i` is the
temperature of the :math:`i^{th}` section.  We can further describe
the mass as:

.. math::

    m_i = \rho V_i

where :math:`\rho` is the material density and :math:`V_i` is the
volume of the :math:`i^{th}` section.  Finally, we can express the
volume of the :math:`i^{th}` section as:

.. math::

    V_i = A_i L_i

where :math:`A_i` is the cross-sectional area of the :math:`i^{th}`
section, which is assumed to be uniform, and :math:`L_i` is the length
of the :math:`i^{th}` section.  For this example, we will assume the
rod is composed of equal size pieces.  In this case, we can define the
segment length, :math:`L_i`, to be:

.. math::

    L_i = \frac{L}{n}

We will also assume that the cross-sectional area is uniform along the
length of the rod.  As such, the mass of each segment can be given as:

.. math::

    m = \rho A L_i

In this case, the thermal capacitance of each section would be:

.. math::

    \rho A L_i C T_i

This, in turn, means that the net heat gained in that section at any
time will be:

.. math::

    \rho A L_i C \frac{\mathrm{d} T_i}{\mathrm{d}t}

where we assume that :math:`A`, :math:`L_i` and :math:`C`
don't change with respect to time.

That covers the thermal capacitance.  In addition, we will consider
two different forms of heat transfer.  The first form of heat transfer
we will consider is convection from each section to some ambient
temperature, :math:`T_{amb}`.  We can express the amount of heat lost
from each section as:

.. math::

    q_h = -h A (T_i-T_{amb})

where :math:`h` is the convection coefficient.  The other form of heat
transfer is conduction to neighboring sections.  Here there will be
two contributions, one lost to the :math:`{i-1}^{th}` section, if it
exists, and the other lost to the :math:`{i+1}^{th}` section, if it
exists.  These can be represented, respectively, as:

.. math::

   q_{k_{i \rightarrow {i-1}}} = -k A \frac{T_i-T_{i-1}}{L_i}

.. math::

   q_{k_{i \rightarrow {i+1}}} = -k A \frac{T_i-T_{i+1}}{L_i}

Using these relations, we know that the heat balance for the first
element would be:

.. math::

   \rho A L_i C \frac{\mathrm{d} T_1}{\mathrm{d}t} &=
   -k A \frac{T_1-T_2}{L_i} - h A (T_1-T_{amb})

Similarly, the heat balance for the last element would be:

.. math::

   \rho A L_i C \frac{\mathrm{d} T_n}{\mathrm{d}t} &= -k
   A\frac{T_n-T_{n-1}}{L_i} -h A (T_n-T_{amb})

Finally, the heat balance for all other elements would be:

.. math::

   \rho A L_i C \frac{\mathrm{d} T_i}{\mathrm{d}t} &= -k
   A\frac{T_i-T_{i-1}}{L_i} -k A\frac{T_i-T_{i+1}}{L_i} -h A (T_i-T_{amb})

Implementation
^^^^^^^^^^^^^^

We start by defining types for the various physical quantities.  This
will give us the proper units and, depending on the tool, allows us to
do unit checking on our equations.  Our type definitions are as
follows:

.. literalinclude:: /ModelicaByExample/ArrayEquations/HeatTransfer/Rod_ForLoop.mo
   :language: modelica
   :lines: 3-12

We will also define several parameters to describe the rod we are
simulating:

.. literalinclude:: /ModelicaByExample/ArrayEquations/HeatTransfer/Rod_ForLoop.mo
   :language: modelica
   :lines: 16-23

Given these parameters, we can compute the area and volume for each
section in terms of the parameters we have already defined using the
following declarations:

.. literalinclude:: /ModelicaByExample/ArrayEquations/HeatTransfer/Rod_ForLoop.mo
   :language: modelica
   :lines: 25-26

Finally, the only array in this problem is the temperature of each
section (since this is the only quantity that actually varies along the length of
the rod):

.. literalinclude:: /ModelicaByExample/ArrayEquations/HeatTransfer/Rod_ForLoop.mo
   :language: modelica
   :lines: 28-28

This concludes all the declarations we need to make.  Now let's
consider the various equations required.  First, we need to specify
the initial conditions for the rod.  We will assume that
:math:`T_1(0)=200`, :math:`T_n(0)=300` and the initial temperatures of
all other sections can be linearly interpolated between these two end
conditions.  This is captured by the following equation:

.. literalinclude:: /ModelicaByExample/ArrayEquations/HeatTransfer/Rod_ForLoop.mo
   :language: modelica
   :lines: 29-30

where the ``linspace`` operator is used to create an array of ``n``
values that vary linearly between ``200`` and ``300``.  Recall from
our :ref:`state-space` examples that we can include equations where
the left hand side and right hand side expressions are vectors.  This
is another example of such an equation.

Finally, we come to the equations that describe how the temperature in
each section changes over time:

.. literalinclude:: /ModelicaByExample/ArrayEquations/HeatTransfer/Rod_ForLoop.mo
   :language: modelica
   :lines: 31-36

The first equation corresponds to the heat balance for section
:math:`1`, the last equation corresponds to the heat balance for
section :math:`n` and the middle equation covers all other sections.
Note the use of ``end`` as a subscript.  When an expression is used to
evaluate a subscript for a given dimension, ``end`` represents the
size of that dimension.  In our case, we use ``end`` to represent the
last section.  Of course, we could use ``n`` in this case, but in
general, ``end`` can be very useful when the size of a dimension is not
already associated with a variable.

Also note the use of a ``for`` loop in this model.  A ``for`` loop
allows the loop index variable to loop over a range of values.  In our
case, the loop index variable is ``i`` and the range of values is
:math:`2` through :math:`n-1`.  The general syntax for a ``for`` loop
is:

.. code-block:: modelica

    for <var> in <range> loop
      // statements
    end for;

where ``<range>`` is a vector of values.  A convenient way to generate
a sequence of values is to use the range operator, ``:``.  The value
before the range operator is the initial value in the sequence and the
value after the range operator is the final value in the sequence.
So, for example, the expression ``5:10`` would generate a vector with
the values ``5``, ``6``, ``7``, ``8``, ``9`` and ``10``.  Note that
this **includes** the values used to specify the range.

When a ``for`` loop is used in an equation section, each iteration of
the for loop generates a new equation for each equation inside the
``for`` loop.  So in our case, we will generate :math:`n-2` equations
corresponding to values of ``i`` between ``2`` and ``n-1``.

Putting all this together, the complete model would be:

.. literalinclude:: /ModelicaByExample/ArrayEquations/HeatTransfer/Rod_ForLoop.mo
   :language: modelica
   :lines: 2-

.. note::

    Note that we've included ``pi`` as a literal constant in this
    model.  Later in the book, we'll discuss how to properly import
    common :ref:`constants`.

Simulating this model yields the following solution for each of the
nodal temperatures:

.. plot:: ../plots/RFL.py
   :class: interactive

Note how the temperatures are initially distributed linearly (as we
specified in our ``initial equation`` section).

Alternatives
^^^^^^^^^^^^

It turns out that there are several ways we can generate the equations
we need.  Each has its own advantages and disadvantages depending on
the context.  We'll present them here just to demonstrate the
possibilities.  The choice of which one they
feel leads to the most understandable equations is up to the model developer.

.. index:: array comprehensions

One array feature we can use to make these equations slightly simpler
is called an array comprehension.  An array comprehension flips the
``for`` loop around so that we take a single equation and add some
information at the end indicating that the equation should be
evaluated for different values of the loop index variable.  In our
case, we can represent our equation section using array comprehensions
as follows:

.. literalinclude:: /ModelicaByExample/ArrayEquations/HeatTransfer/Rod_ArrayComprehensions.mo
   :language: modelica
   :lines: 32-35

We could also combine the array comprehension with some ``if``
expressions to nullify contributions to the heat balance that don't
necessarily apply.  In that case, we can simplify the ``equation``
section to the point where it contains one (admittedly multi-line)
equation:

.. literalinclude:: /ModelicaByExample/ArrayEquations/HeatTransfer/Rod_ArrayComprehensionsOneEquation.mo
   :language: modelica
   :lines: 32-35

Recall, from several previous examples, that Modelica supports vector
equations.  In these cases, when the left hand and right hand side are
vectors of the same size, we can use a single (vector) equation to
represent many scalar equations.  We can use this feature to simplify
our equations as follows:

.. literalinclude:: /ModelicaByExample/ArrayEquations/HeatTransfer/Rod_VectorNotation.mo
   :language: modelica
   :lines: 32-35

Note that when a vector variable like ``T`` has a range of subscripts
applied to it, the result is a vector containing the components
indicated by the values in the subscript.  For example, the expression
``T[2:4]`` is equivalent to ``{T[2], T[3], T[4}``.  The subscript
expression doesn't need to be a range.  For example, ``T[{2,5,9}]`` is
equivalent to ``{T[2], T[5], T[9]}``.

Finally, let us consider one last way of refactoring these equations.
Imagine we introduced two additional vector variables:

.. literalinclude:: /ModelicaByExample/ArrayEquations/HeatTransfer/Rod_VectorNotationNoSubscripts.mo
   :language: modelica
   :lines: 31-32

Then we can write these two equations (again using vector equations)
to define the heat lost to the previous and next section in the rod:

.. literalinclude:: /ModelicaByExample/ArrayEquations/HeatTransfer/Rod_VectorNotationNoSubscripts.mo
   :language: modelica
   :lines: 36-37

This allows us to express the heat balance for each section using a
vector equation that doesn't include any subscripts:

.. literalinclude:: /ModelicaByExample/ArrayEquations/HeatTransfer/Rod_VectorNotationNoSubscripts.mo
   :language: modelica
   :lines: 38-38

Conclusion
^^^^^^^^^^

In this section, we've seen various ways that we can use vector
variables and vector equations to represent one-dimensional heat
transfer.  Of course, this vector related functionality can be used
for a wide range of different problem types.  The goal of this section
was to introduce several features to demonstrate the various options
that are available to the developer when working with vectors.
