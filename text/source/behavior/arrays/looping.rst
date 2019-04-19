.. _looping:

Looping
-------

``for``
^^^^^^^

One of the main uses of arrays is to allow code to be simplified
through the use of loops.  So we will conclude this chapter on arrays
by introducing some basic looping constructs and showing how they are
used in conjunction with array features.

In general, the ``for`` keyword is used to represent looping.  But
there are many different contexts in which ``for`` can be used.
Several of the examples in this chapter used ``for`` to generate a
collection of equations.  When ``for`` is used within an equation
section, any equations contained within the ``for`` loop are generated
**for each value of the loop index variables**.  In this way, we can
easily generate many equations that have the same overall structure
and only vary by the value of the loop index variable.  The general
syntax for a ``for`` loop in an equation section is:

.. code-block:: modelica

    equation
      for i in 1:n loop
        // equations
      end for;

Note that the loop index variable (*e.g.,* ``i`` in this case) **does
not have to be declared**.  It is also worth noting that these
variables only exists within the scope of the ``for`` loop (not before
or after the loop).

For loops can, of course, be nested.  For example:

.. code-block:: modelica

    equation
      for i in 1:n loop
        for j in 1:n loop
          // equation
        end for;
      end for;

They can also appear in other contexts.  For example, they can appear
in ``initial equation`` sections or in :ref:`algorithm-sections`.

Another case where the ``for`` keyword can be seen is in our
discussion of :ref:`array-comprehensions`.  In that case, the ``for``
construct is not used to generate equations or statements, but to
populate the various elements in an array.  Array comprehensions have the
advantage that they may be more easily for tools to optimize.


``while``
^^^^^^^^^

There is another type of loop in Modelica and that is the ``while``
loop.  The ``while`` loop is not used very often in Modelica.  The
reason is that Modelica, unlike a general purpose language, is an
equation oriented language.  Furthermore, it imposes a requirement
that a model should include an equal number of equations and
unknowns.  Such a model is considered a "balanced model".

The reason that the ``while`` construct is not widely used is because
a balanced model requires that the number of equations is predictable
(by the compiler).  Because a ``for`` loop is bounded and the number
of values of the index variable is always known (because it is always
derived from a vector of possible values), the number of equations it
will generate is always known.  The same cannot be said of a ``while``
loop.  As such, ``while`` loops are only practical in the context of
:ref:`algorithm-sections` (typically in the definition of
:ref:`functions`).
