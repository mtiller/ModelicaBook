.. _array-construction:

Array Construction
------------------

Now that we know :ref:`how to declare that a variable is an array
<array-declarations>`, the next step is filling in all the elements of
those arrays.  There are many different ways to construct arrays in
Modelica.

Literals
^^^^^^^^

Vectors
~~~~~~~

The simplest method for constructing an array is to enumerate each of
the individual elements.  For example, given the following parameter
declaration for a variable named ``x`` meant to represent a vector:

.. code-block:: modelica

    parameter Real x[3];

When we use the term "vector" here, we are referring to an array that
has only one subscript dimension.  If we wanted to assign a value to
this vector, we could do so as follows:

.. code-block:: modelica

    parameter Real x[3] = {1.0, 0.0, -1.0};

Clearly, the variable ``x`` is (declared to be) a vector with three
real valued components.  For consistency, the right hand side must
also be a vector with three real valued components.  Fortunately, it
is.  The expression ``{1.0, 0.0, -1.0}`` is a special syntax in
Modelica for constructing vectors.  We can use this syntax of a pair
of ``{}`` containing a comma separated list of expressions to build
vectors of any size we wish, *e.g.,*

.. code-block:: modelica

    parameter Real x[5] = {1.0, 0.0, -1.0, 2.0, 0.0};

While it is possible to use the ``{}`` notation to construct arrays of
any dimension, *e.g.,*

.. code-block:: modelica

    parameter Real B[2,3] = {{1.0, 2.0, 3.0}, {5.0, 6.0, 7.0}};

.. _range-notation:

Range Notation
~~~~~~~~~~~~~~

Modelica includes a shorthand notation for constructing vectors of
sequential numbers or numbers that are evenly spaced.  For example, to
construct a vector of integers with elements having values from 1 to
5, the following syntax can be used:

.. code-block:: modelica

    1:5       // {1, 2, 3, 4, 5}

The same syntax can be used to construct arrays of floating point
numbers:

.. code-block:: modelica

    1.0:5.0   // {1.0, 2.0, 3.0, 4.0, 5.0}

Note, care should be taken when vectors of reals in this way since
issues with floating point representations may result in the vector not
including the final value.  The following alternatives are also
available (and probably more robust):

.. code-block:: modelica

    1.0*(1:5)             // {1.0, 2.0, 3.0, 4.0, 5.0}
    {1.0*i for i in 1:5}  // {1.0, 2.0, 3.0, 4.0, 5.0}

It is also possible to construct ranges where the interval between
values is not 1 by adding the "stride" between the first and last
values.  For example, all odd numbers between 3 and 9 can be
represented as:

.. code-block:: modelica

    3:2:9   // {3, 5, 7, 9}

It is also possible to insert a stride value when dealing with
floating point numbers as well.  This range notation can also be used
with an ``enumeration`` type (but a stride value is not permitted in
that case).

Matrix Construction
~~~~~~~~~~~~~~~~~~~

But it is important to note that there is also a special syntax used
for constructing matrices (arrays with exactly two subscript
dimensions).  Consider the following parameter declarations with
initializer:

.. code-block:: modelica

    parameter Real B[2,3] = [1.0, 2.0, 3.0; 5.0, 6.0, 7.0];

In this case, the parameter ``B`` is equivalent to the following in
mathematical notation:

.. math::

    B = \left[
    \begin{array}{ccc}
    1.0 & 2.0 & 3.0 \\
    5.0 & 6.0 & 7.0
    \end{array}
    \right]

As we can see in both the Modelica code and the more mathematical
representation, the matrix ``B`` has two rows and three columns.  The
syntax for building arrays in this way is a bit more complicated than
building vectors.  Superficially, we see that while a vector is
surrounded by ``{}``, a matrix is surrounded by ``[]``.  But more
importantly, a mixture of commas **and semicolons** are used as
delimiters.  The semicolons are used to separate rows and the commas
are used to separate the columns.

One nice feature about this matrix construction notation is that it is
possible to embed vectors or submatrices.

.. topic:: Vectors

    When embedding vectors, it is very important to note that
    **vectors are treated as column vectors**.  In other words, in the
    context of matrix construction, a vector of size :math:`n` is
    treated as a matrix with :math:`n` rows and 1 column.

To demonstrate how this embedding is done, consider the case where we
wished to construct the following matrix:

.. math::

    C = \left[
    \begin{array}{ccc}
    \left|
    \begin{array}{cc}
    2 & 1 \\
    1 & 2
    \end{array}
    \right| &
    \left|
    \begin{array}{cc}
    0 & 0 \\
    0 & 0
    \end{array}
    \right| &
    \left|
    \begin{array}{cc}
    0 & 0 \\
    0 & 0
    \end{array}
    \right| \\
    \left|
    \begin{array}{cc}
    0 & 0 \\
    0 & 0
    \end{array}
    \right| &
    \left|
    \begin{array}{cc}
    2 & 1 \\
    1 & 2
    \end{array}
    \right| &
    \left|
    \begin{array}{cc}
    0 & 0 \\
    0 & 0
    \end{array}
    \right| \\
    \left|
    \begin{array}{cc}
    0 & 0 \\
    0 & 0
    \end{array}
    \right| &
    \left|
    \begin{array}{cc}
    0 & 0 \\
    0 & 0
    \end{array}
    \right| &
    \left|
    \begin{array}{cc}
    2 & 1 \\
    1 & 2
    \end{array}
    \right|
    \end{array}
    \right]

We can do this concisely in Modelica by first creating each of the
submatrices and then filling in :math:`C` using these submatrices as
follows:

.. code-block:: modelica

    parameter D[2,2] = [2, 1; 1, 2];
    parameter Z[2,2] = [0, 0; 0, 0];
    parameter C[6,6] = [D, Z, Z;
                        Z, D, Z;
                        Z, Z, D];

In other words, the ``,`` and ``;`` delimiters work with either
scalars or submatrices.

As we will see shortly, there are several different
:ref:`array-construction-functions` that can be extremely useful when
building matrices in this way.

Arrays of Any Size
~~~~~~~~~~~~~~~~~~

So far, we've discussed vectors and matrices.  But you can construct
arbitrary arrays with any number of dimensions (including vectors and
matrices) using by constructing them as a series of nested vectors.
For example, to construct an array with three dimensions, we could
simply nested a collection of vectors as follows:

.. code-block:: modelica

    parameter Real A[2,3,4] = { { {1, 2, 3, 4},
                                  {5, 6, 7, 8},
                                  {9, 8, 7, 6} },
				{ {4, 3, 2, 1},
                                  {8, 7, 6, 5},
                                  {4, 3, 2, 1} } };

As can be seen in this example, the inner most elements in this nested
construction correspond to the right most dimension in the
declaration.  In other words, the array here is a vector containing
two elements where each of those two elements is a vector containing
three elements and each of those three elements is a vector of 4
scalars.

.. _array-comprehensions:

Array Comprehensions
^^^^^^^^^^^^^^^^^^^^

So far, we've shown how to construct vectors, matrices and higher
dimensional arrays by enumerating the elements contained in the array.
As we can see in the case of higher dimensional arrays, these
constructions can get very complicated.  Fortunately, Modelica
includes array comprehensions which provide a convenient syntax for
programmatically constructing arrays.

The use of array comprehensions has several benefits.  The first is that it is a
much more compact notation.  The second is that it allows us to easily express
how the values in the array are tied to the various indices.  The third is that
it can be done in a context where an expression is required (typically providing
values for variables in variable declarations).  Finally, some tools may find it
easier to optimize array comprehensions.

To demonstrate array comprehensions, consider the following
relationship between elements in an array and the indices of the
array:

.. math::

    a_{ijk} = i\ x_j\ y_k

where :math:`x` and :math:`y` are vectors.  We've already seen how we
could recursively define such an array using a series of nested
vectors.  But we have also seen how long such an expression could
potentially be and how tedious it is to read and write.  Using array
comprehensions, we can construct the :math:`a` array quite easily as:

.. code-block:: modelica

    parameter Real a[10,12,15] = {i*x[j]*y[k] for k in 1:15,
                                                  j in 1:12,
                                                  i in 1:10};

This code builds an array with 1800 elements with only a few lines of
Modelica code.

