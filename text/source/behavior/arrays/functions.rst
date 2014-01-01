.. _array-functions:

Array Functions
---------------

There are a great many functions in Modelica that are related to
arrays.  In this section, we'll go through different categories of
functions and describe how they are used.

.. _array-construction-functions:

Array Construction Functions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We already talked about :ref:`array-construction`.  We saw the
different syntactic constructs that can be used to build vectors and
matrices.  Furthermore, we saw how matrices can be built from other
matrices.  There are several functions in Modelica that can be used
for constructing vectors, matrices and higher-dimension arrays as both
an alternative or complement to those previous presented.


.. _fill-function:

``fill``
~~~~~~~~

.. index:: fill
.. index:: functions; fill

The ``fill`` function is used to create an array where each element in
the array has the same value.  The arguments for ``fill`` are:

.. code-block:: modelica

    fill(v, d1, d2, ..., dN)

where ``v`` is the value to be given to each element in the array and
the remaining arguments are the sizes of each dimension.  The elements
in the resulting array will have the same type as ``v``.  So, to fill
a 5x7 array of reals with the value ``1.7``, we could use the
following:

.. code-block:: modelica

    parameter Real x[5,7] = fill(1.7, 5, 7);

This would result in a matrix filled as follows:

.. math::

    \left[
    \begin{array}{ccccccc}
    1.7 & 1.7 & 1.7 & 1.7 & 1.7 & 1.7 & 1.7 \\
    1.7 & 1.7 & 1.7 & 1.7 & 1.7 & 1.7 & 1.7 \\
    1.7 & 1.7 & 1.7 & 1.7 & 1.7 & 1.7 & 1.7 \\
    1.7 & 1.7 & 1.7 & 1.7 & 1.7 & 1.7 & 1.7 \\
    1.7 & 1.7 & 1.7 & 1.7 & 1.7 & 1.7 & 1.7
    \end{array}
    \right]

.. _zeros-function:

``zeros``
~~~~~~~~~

.. index:: zeros
.. index:: functions; zeros

When working with arrays, a common use case is to create an array that
contains only zero elements.  This is essentially the same
functionality as the ``fill`` function, but since the value is known
it is only necessary to specify the sizes.  Using ``zeros`` we can
initialize an array as follows:

.. code-block:: modelica

    parameter Real y[2,3,5] = zeros(2, 3, 5);

``ones``
~~~~~~~~

.. index:: ones
.. index:: functions; ones

The ``ones`` function is identical to the ``zeros`` function except
that every element in the resulting array has the value :math:`1`.
So, for example:

.. code-block:: modelica

    parameter Real z[3,5] = ones(3, 5);

This would result in a matrix filled as follows:

.. math::

    \left[
    \begin{array}{ccccc}
    1 & 1 & 1 & 1 & 1 \\
    1 & 1 & 1 & 1 & 1 \\
    1 & 1 & 1 & 1 & 1
    \end{array}
    \right]

``identity``
~~~~~~~~~~~~

.. index:: identity
.. index:: functions; identity

Another common need is to easily build an identity matrix, one whose
diagonal elements are all :math:`1` while all other elements are
:math:`0`.  This can be done very easily with the ``identity``.  The
identity function takes a single integer argument.  This argument
determines the number of rows and columns in the resulting matrix.
So, invoking ``identity`` as:

.. code-block:: modelica

    identity(5);

would produce the following matrix:

.. math::

    \left[
    \begin{array}{ccccc}
    1 & 0 & 0 & 0 & 0 \\
    0 & 1 & 0 & 0 & 0 \\
    0 & 0 & 1 & 0 & 0 \\
    0 & 0 & 0 & 1 & 0 \\
    0 & 0 & 0 & 0 & 1 \\
    \end{array}
    \right]


``diagonal``
~~~~~~~~~~~~

.. index:: diagonal
.. index:: functions; diagonal

The ``diagonal`` function is used to create a matrix where all
non-diagonal elements are :math:`0`.  The only argument to diagonal is
an array containing the values of the diagonal elements.   So, to
create the following diagonal matrix:

.. math::

    \left[
    \begin{array}{cccc}
    2.0 & 0 & 0 & 0 \\
    0 & 3.0 & 0 & 0 \\
    0 & 0 & 4.0 & 0 \\
    0 & 0 & 0 & 5.0
    \end{array}
    \right]

one could use the following Modelica code:

.. code-block:: modelica

    diagonal({2.0, 3.0, 4.0, 5.0});

``linspace``
~~~~~~~~~~~~

.. index:: linspace
.. index:: functions; linspace

The ``linspace`` function builds a vector where the values of the
elements are all linearly distributed over an interval.  The
``linspace`` function is invoked as follows:

.. code-block:: modelica

    linspace(v0, v1, n);

where ``v0`` is the value of the first elements in the vector, ``v1``
is the last element in the vector and ``n`` is the total number of
values in the vector.  So, for example, invoking ``linspace`` as:

.. code-block:: modelica

    linspace(1.0, 5.0, 9);

would yield the vector:

.. code-block:: modelica

    {1.0, 1.5, 2.0, 3.5, 3.0, 3.5, 4.0, 4.5, 5.0}

.. todo:: Document these functions

Conversion Functions
^^^^^^^^^^^^^^^^^^^^

The following functions provide a means to transform arrays into other
arrays.

``scalar``
~~~~~~~~~~

.. index:: scalar
.. index:: functions; scalar

The ``scalar`` function is invoked as follows:

.. code-block:: modelica

    scalar(A)

where ``A`` is an array with an arbitrary number of dimensions as long
as each dimension is of size :math:`1`.  The ``scalar`` function
returns the (only) scalar value contained in the array.

``vector``
~~~~~~~~~~

.. index:: vector
.. index:: functions; vector

The ``vector`` function is invoked as follows:

.. code-block:: modelica

    vector(A)

where ``A`` is an array with an arbitrary number of dimensions as long
as only one dimension has a size greater than :math:`1`.  The
``vector`` function returns the contents of the array as a vector
(*i.e.,* an array with only a single dimension).

``matrix``
~~~~~~~~~~

.. index:: matrix
.. index:: functions; matrix

The ``matrix`` function is invoked as follows:

.. code-block:: modelica

    matrix(A)

where ``A`` is an array with an arbitrary number of dimensions as long
as only two dimension have a size greater than :math:`1`.  The
``matrix`` function returns the contents of the array as a matrix
(*i.e.,* an array with only two dimensions).

Mathematical Operations
^^^^^^^^^^^^^^^^^^^^^^^

In linear algebra, there are many different types of mathematical
operations that are commonly performed on vectors and matrices.
Modelica provides functions to perform most of these operations.  In
this way, Modelica equations can be made to look very much like their
mathematical counterparts in linear algebra.

Let's start with operations like addition, subtraction,
multiplication, division and exponentiation.  For the most part, these
operations work just as they do in mathematics when applied to the
various combinations of scalars, vectors and matrices.  However, for
completeness and reference, the following tables summarize how these
operations are defined.

.. topic:: Explanation of Notation

    Each of the operations described below involves two arguments,
    :math:`a` and :math:`b`, and a result, :math:`c`.  If an argument
    represents a scalar, it will have no subscripts.  If it is a
    vector, it will have one subscript.  If it is a matrix, it will
    have two subscripts.  If the operation is defined for arbitrary
    arrays, a case will be included with three subscripts.  If a given
    combination is not shown, then it is not allowed.

Addition (``+``)
~~~~~~~~~~~~~~~~

========================== ==========================================
Expression                 Result
-------------------------- ------------------------------------------
:math:`a + b`              :math:`c = a + b`
:math:`a_{i} + b_{i}`      :math:`c_{i} = a_{i} + b_{i}`
:math:`a_{ij} + b_{ij}`    :math:`c_{ij} = a_{ij} + b_{ij}`
:math:`a_{ijk} + b_{ijk}`  :math:`c_{ijk} = a_{ijk} + b_{ijk}`
========================== ==========================================

Subtraction (``-``)
~~~~~~~~~~~~~~~~~~~

========================== ==========================================
Expression                 Result
-------------------------- ------------------------------------------
:math:`a - b`              :math:`c = a - b`
:math:`a_{i} - b_{i}`      :math:`c_{i} = a_{i} - b_{i}`
:math:`a_{ij} - b_{ij}`    :math:`c_{ij} = a_{ij} - b_{ij}`
:math:`a_{ijk} - b_{ijk}`  :math:`c_{ijk} = a_{ijk} - b_{ijk}`
========================== ==========================================

.. _array-multiplication:

Multiplication (``*`` and ``.*``)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are two types of multiplication operators.  The first is the
normal multiplication operator, ``*``, that follows the usual
mathematical conventions of linear algebra that matrix-vector
products, *etc.*.  The behavior of the ``*`` operator is summarized in
the following table:

============================ ==========================================
Expression                   Result
---------------------------- ------------------------------------------
:math:`a * b`                :math:`c = a * b`
:math:`a * b_i`              :math:`c_i = a * b_i`
:math:`a * b_{ij}`           :math:`c_{ij} = a * b_{ij}`
:math:`a * b_{ijk}`          :math:`c_{ijk} = a * b_{ijk}`
:math:`a_i * b`              :math:`c_i = a_i * b`
:math:`a_{ij} * b`           :math:`c_{ij} = a_{ij} * b`
:math:`a_{ijk} * b`          :math:`c_{ijk} = a_{ijk} * b`
:math:`a_{i} * b_{i}`        :math:`c = \sum_i a_{i} * b_{i}`
:math:`a_{i} * b_{ij}`       :math:`c_j = \sum_i a_{i} * b_{ij}`
:math:`a_{ij} * b_{j}`       :math:`c_i = \sum_j a_{ij} * b_{j}`
:math:`a_{ik} * b_{kj}`      :math:`c_{ij} = \sum_k a_{ik} * b_{kj}`
============================ ==========================================

The second type of multiplication operator is a special element-wise
version, ``.*``, which doesn't perform any summations and simply
applies the operator element-wise to all array elements.

======================================= ==========================================
Expression                               Result
--------------------------------------- ------------------------------------------
:math:`a` ``.*`` :math:`b`               :math:`c = a * b`
:math:`a_{i}` ``.*`` :math:`b_{i}`       :math:`c_{i} = a_{i} * b_{i}`
:math:`a_{ij}` ``.*`` :math:`b_{ij}`     :math:`c_{ij} = a_{ij} * b_{ij}`
:math:`a_{ijk}` ``.*`` :math:`b_{ijk}`   :math:`c_{ijk} = a_{ijk} * b_{ijk}`
======================================= ==========================================

.. _array-division:

Division (``/`` and ``./``)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

As with :ref:`array-multiplication`, there are two division
operators.  The first is the normal division operator, ``/``, which
can be used to divide arrays by a scalar value.  The following table
summarizes its behavior:

============================ ==========================================
Expression                   Result
---------------------------- ------------------------------------------
:math:`a / b`                :math:`c = a / b`
:math:`a_i / b`              :math:`c_i = a_i / b`
:math:`a_{ij} / b`           :math:`c_{ij} = a_{ij} / b`
:math:`a_{ijk} / b`          :math:`c_{ijk} = a_{ijk} / b`
============================ ==========================================

In addition, there is also an element-wise version of the division
operator, ``./``, whose behavior is summarized in the following table:

======================================= ==========================================
Expression                               Result
--------------------------------------- ------------------------------------------
:math:`a` ``./`` :math:`b`               :math:`c = a / b`
:math:`a_{i}` ``./`` :math:`b_{i}`       :math:`c_{i} = a_{i} / b_{i}`
:math:`a_{ij}` ``./`` :math:`b_{ij}`     :math:`c_{ij} = a_{ij} / b_{ij}`
:math:`a_{ijk}` ``./`` :math:`b_{ijk}`   :math:`c_{ijk} = a_{ijk} / b_{ijk}`
======================================= ==========================================

Exponentiation (``^`` and ``.^``)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As with :ref:`array-multiplication` and :ref:`array-division`, the
exponentiation operator comes in two forms.  The first is the standard
exponentiation operator, ``^``.  The standard version can be used in
two different ways.  The first is to raise one scalar to the power of
another (*i.e.,* :math:`a` ``^`` :math:`b`).  The other is to raise a
square matrix to a scalar power (*i.e.,* :math:`a_{ij}` ``^``
:math:`b`).

The other form of exponentiation is the element-wise form indicated
with the ``.^`` operator.  Its behavior is summarized in the following
table:

======================================= ==========================================
Expression                               Result
--------------------------------------- ------------------------------------------
:math:`a` ``.^`` :math:`b`               :math:`c = a^b`
:math:`a_{i}` ``.^`` :math:`b_{i}`       :math:`c_{i} = a_{i}^{b_{i}}`
:math:`a_{ij}` ``.^`` :math:`b_{ij}`     :math:`c_{ij} = a_{ij}^{b_{ij}}`
:math:`a_{ijk}` ``.^`` :math:`b_{ijk}`   :math:`c_{ijk} = a_{ijk}^{b_{ijk}}`
======================================= ==========================================

.. _array-equality:

Equality (``=``)
~~~~~~~~~~~~~~~~

The equality operator, ``=`` used to construct equations can be used
with scalars as well as arrays **as long as the left hand side and
right hand side have the same number of dimensions and the sizes of
each dimension are the same**.  Assuming this requirement is met, then
the operator is simply applied element-wise.  This means that the
operator is applied between each element on the left hand side and its
counterpart on the right hand side.


Assignment (``:=``)
~~~~~~~~~~~~~~~~~~~

The ``:=`` (assignment) operator is applied in the same element-wise
way as the :ref:`array-equality` operator.

Relational Operators
~~~~~~~~~~~~~~~~~~~~

All relational operators (``and``, ``or``, ``not``, ``>``, ``>=``,
``<=``, ``<``) are applied in the same element-wise way as the
:ref:`array-equality` operator.

``transpose``
~~~~~~~~~~~~~

.. index:: transpose
.. index:: functions; transpose

``outerProduct``
~~~~~~~~~~~~~~~~

.. index:: outerProduct
.. index:: functions; outerProduct

``symmetric``
~~~~~~~~~~~~~

.. index:: symmetric
.. index:: functions; symmetric

``skew``
~~~~~~~~

.. index:: skew
.. index:: functions; skew

``cross``
~~~~~~~~~

.. index:: cross
.. index:: functions; cross

Reduction Operators
^^^^^^^^^^^^^^^^^^^

``min``
~~~~~~~

.. index:: min (vector)
.. index:: functions; min (vector)

``max``
~~~~~~~

.. index:: max (vector)
.. index:: functions; max (vector)

``sum``
~~~~~~~

.. index:: sum
.. index:: functions; sum

``product``
~~~~~~~~~~~

.. index:: product
.. index:: functions; product

Miscellaneous Functions
^^^^^^^^^^^^^^^^^^^^^^^

``ndims``
~~~~~~~~~

.. index:: ndims
.. index:: functions; ndims

``size``
~~~~~~~~

.. index:: size
.. index:: functions; size

.. _vectorization:

Vectorization
^^^^^^^^^^^^^

.. index:: vectorization
.. index:: functions; vectorization
.. index:: equations; of vectors

* Vectorization

* Discuss arithmetic operators and how they are applied to vectors

* Equations?

