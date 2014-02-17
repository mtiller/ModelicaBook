.. _array-indexing:

Array Indexing
--------------

We've seen many examples in this chapter showing how arrays are
indexed.  So it might not seem necessary to have a section devoted to
discussing how to index arrays.  It is true that normally you would
simply reference elements in an array using integer values for each
subscript.  But there are enough other ways to index arrays that it is
worth spending some time to talk about them.

Indices
^^^^^^^

Integers
~~~~~~~~

.. topic:: 1-index

    For array dimensions specified using integers, Modelica uses
    indices starting with **1**.  Some languages choose to use zero as
    the starting index, but it is important to point out from the start
    that Modelica follows the 1-index convention.

Obviously, the most directly way to index an array is to use an
integer.  For an array declared as:

.. code-block:: modelica

    Real x[5,4];

we can index elements of the array by providing an integer between 1
and 5 for the first subscript and 1 and 4 for the second subscript.

But it is worth pointing out that Modelica allows the subscripts to be
vectors.  To understand how vector indices work, first consider the
following matrix:

.. math::

    B = \left[
    \begin{array}{ccc}
    1 & 2 & 3 \\
    4 & 5 & 6 \\
    7 & 8 & 9
    \end{array}
    \right]

In Modelica, such an array would be declared as follows:

.. code-block:: modelica

    parameter Real B[3,3] = [1, 2, 3; 4, 5, 6; 7, 8, 9];

Imagine we wish to extract a submatrix of ``B`` as follows:

.. code-block:: modelica

    parameter Real C[2,2] = [B[1,1], B[1,2]; B[2,1], B[2,2]]; // [1, 2; 4, 5];

We could extract the same submatrix more easily using vector
subscripts as follows:

.. code-block:: modelica

    parameter Real C[2,2] = B[{1,2},{1,2}]; // [1, 2; 4, 5];

By using vector subscripts we can extract or construct arbitrary
sub-arrays.  This is where :ref:`range-notation` can be very useful.
The same submatrix extraction could also be represented as:

.. code-block:: modelica

    parameter Real C[2,2] = B[1:2,1:2]; // [1, 2; 4, 5];

Enumerations
~~~~~~~~~~~~

In our :ref:`chemical-system` examples, we saw how enumerations can be
used to specify array dimensions.  Furthermore, we saw how the values
specified by an ``enumeration`` type can be used to index the array.
In general, for an ``enumeration`` like the following:

.. code-block:: modelica

    type Species = enumeration(A, B, X);

and then declare an array where that ``enumeration`` is used to
specify a dimension, *e.g.,*

.. code-block:: modelica

    Real C[Species];

then we can use the enumeration values, ``Species.A``, ``Species.B``
and ``Species.X`` as indices.  For example,

.. code-block:: modelica

    equation
      der(C[Species.A]) = ...;


Booleans
~~~~~~~~

We can use the ``Boolean`` type in much the same way as an
``enumeration``.  Given an array declared with ``Boolean`` for a
dimension:

.. code-block:: modelica

    Real C[5,Boolean];

We can then use boolean values to index that dimension, *e.g.,*

.. code-block:: modelica

    equation
      der(C[1,true]) = ...;
      der(C[1,false]) = ...;

``end``
~~~~~~~

When specifying a subscript for an array, it is legal to use ``end``
in the subscript expression.  In this context, ``end`` will take on
the value of the highest possible value for the corresponding array
dimension.  The use of ``end`` within expressions allows easy
reference to array elements with respect to the last element rather
than the first.  For example, to reference the second from the last
element in a vector, the expression ``end-1`` can be used a subscript.

Remember that ``end`` takes on the value of the highest possible index
for the **corresponding array dimension**.  So for the following
array:

.. code-block:: modelica

    Integer B[2,4] = [1, 2, 3, 4; 5, 6, 7, 8];

The following expressions would evaluate as follows:

.. code-block:: modelica

    B[1,end]     // 4
    B[end,1]     // 5
    B[end,end]   // 8
    B[2,end-1]   // 7

Slicing
^^^^^^^

There is another sophisticated way of indexing arrays in Modelica.
But it doesn't make sense to talk about it just yet.  We will see it
later when we start our discussion of :ref:`arrays-of-components`.
