.. _array-declarations:

Array Declarations
------------------

Syntax
^^^^^^

Array declaration syntax is very simple.  The syntax is the same as
for a normal variable declaration except the variable name should be
followed by subscripts to specify the size of each dimension of the
array.  The general form for an array declaration would be:

.. code-block:: modelica

    VariableType varName[dim1, dim2, ..., dimN];

where ``VariableType`` is a Modelica type like ``Real`` or
``Integer``, ``varName`` is the name of the variable.

Integer Sizes
^^^^^^^^^^^^^

Normally, the dimension specifications are simply integers that
indicate the size of that dimension.  For example:

.. code-block:: modelica

    Real x[5];

In this case, ``x`` is an array of real valued numbers with only one
dimension of size 5.  It is possible to use parameters or constants
specify the size of an array, *e.g.,*

.. code-block:: modelica

    parameter Integer d1=5;
    constant Integer d2=2;
    Real x[d1, d2];

Linked Dimensions
^^^^^^^^^^^^^^^^^

As we will see shortly when we discuss the various
:ref:`array-functions` in Modelica, we can even use the ``size``
function to specify the size of one array in terms of another array.
Consider the following:

.. code-block:: modelica

    Real x[5];
    Real y[size(x,1)];

In this case, ``y`` will have one dimension of size 5.  The use of the
function ``size(x,1)`` will return the size of dimension 1 of the
array ``x``.  There are many applications where it is useful to
express that the dimensions of different arrays are related in this
way (*e.g.*, ensuring that arrays are sized such that operations like
matrix multiplication are possible).

.. _unspecd-dim:

Unspecified Dimensions
^^^^^^^^^^^^^^^^^^^^^^

There are some circumstances where we can leave the size of an array
unspecified so that it can be specified by some later context.  For
example, we will see examples of this later when we discuss
:ref:`functions` that have arguments which are arrays.

To indicate that the size of a given array dimension is not (yet)
known, we can use the `:` symbol as the dimension.  So in a
declaration like this:

.. code-block:: modelica

    Real A[:,2];

we are declaring an array with two dimensions.  The size of the first
dimension is not specified.  However, the size of the second dimension
is definitively specified as 2.  In effect, we have declared that
``A`` is a matrix with an unspecified number of rows and two columns.

Non-Integer Dimensions
^^^^^^^^^^^^^^^^^^^^^^

.. _array-enum-dim:

Enumerations
~~~~~~~~~~~~

As we saw in our :ref:`chemical-system` examples, another way to
specify the dimension for an array is with an enumeration.  If an
enumeration is used to specify a dimension, then the size of that
dimension will be equal to the number of possible values for that
enumeration.  In our forthcoming discussion on :ref:`array-indexing`,
we'll see how to properly index an array that uses enumerations as
dimensions.

Booleans
~~~~~~~~

It is also possible to declare an array where a dimension is specified
as ``Boolean``, *e.g.,*

.. code-block:: modelica

    Real x[Boolean];
