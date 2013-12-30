.. _array-construction:

Array Construction
------------------

Now that we know :ref:`how to declare that a variable is an array
<array-declarations>`, the next step is filling in all the elements of
those arrays.  There are many different ways to construct arrays in
Modelica.

Literals
^^^^^^^^

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

It is important to point out that this syntax is **only** good for
vectors.  One might be tempted to think you could initialize a matrix as
follows (*i.e.,* as a set of nested vectors):

.. code-block:: modelica

    parameter Real B[2,3] = {{1.0, 2.0, 3.0}, {5.0, 6.0, 7.0}};

.. todo:: This may not be true actually, I need to confirm.

**But this is not legal**.

Fortunately, there is a very similar syntax that can be used
to create matrices (arrays with two subscript dimensions).  Consider
the following parameter declarations with initializer:

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
possible to embed submatrices.  For example, consider we wished
construct the following matrix:

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

Array Comprehensions
^^^^^^^^^^^^^^^^^^^^

The syntax we've talked about so far works well for vectors and
matrices, *i.e.,* arrays with one or two subscript dimensions,
respectively.  But how to construct an array with a higher number of
subscripts.

.. todo:: I still need to research a few things here

* Building higher dimension arrays

* Array comprehensions

* Add a ref to future section on array-construction-functions

