.. _sub-modifications:

Modifications
-------------

Previously, we've seen examples of modifications applied to
variables.  In some cases, these modifications are applied to
:ref:`attributes` of built-in types, *e.g.,*

.. code-block:: modelica

    Real x(start=2, min=1);

In other cases, they have been applied to ``model`` instances to
change the values of parameters for that particular instance, *e.g.,*

.. code-block:: modelica

    StepVoltage Vs(V0=0, Vf=24, stepTime=0.5);

But it is also worth pointing out that such modifications can reach
down deeper into the hierarchy than simply one level.  For example,
consider the previous example involving a ``StepVoltage`` component.
We could also have made a modification to the ``min`` attribute
associated with the ``Vf`` parameter in the ``Vs`` instance of the
``StepVoltage`` model as follows:

.. code-block:: modelica

    StepVoltage Vs(V0=0, Vf(min=0), stepTime=0.5);

But what if we wanted to change an attribute of the ``Vf`` parameter
**and** give it a value?  The syntax for such a modification is:

.. code-block:: modelica

    StepVoltage Vs(V0=0, Vf(min=0)=24, stepTime=0.5);

An important case worth discussion, with regards to modifications, is
how modifications are performed on **arrays** of components.  Imagine
we had an array of ``StepVoltage`` components declared as follows:

.. code-block:: modelica

    StepVoltage Vs[5];

As we saw in our discussion of :ref:`arrays-of-components`, this is
not only legal Modelica, but it can be useful to represent a
collection of components within a subsystem.  If we want to give the
parameter ``Vf`` a value, we have two choices.  The first is to
specify an array of values, *e.g.,*

.. code-block:: modelica

    StepVoltage Vs[5](Vf={24,26,28,30,32});

This assigns the values in the vector ``{24,26,28,30,32}`` to
``Vs[1].Vf``, ``Vs[2].Vf``, ``Vs[3].Vf``, ``Vs[4].Vf`` and
``Vs[5].Vf``, respectively.  The other choice we have is to give the
same value to every element in the array.  We could use this same
array initialization syntax, *e.g.,*

.. code-block:: modelica

    StepVoltage Vs[5](Vf={24,24,24,24,24});

The problem comes when the number of elements in an array is defined
by a ``parameter``, *e.g.,*

.. code-block:: modelica

    parameter Integer n;
    StepVoltage Vs[n](Vf=/* ??? */);

If we tried to initialize ``Vf`` with a literal array (*e.g.,*
``{24,24,24}``, then it won't adapt to changes in ``n``.  To address
this situation, we could use the :ref:`fill-function` function:

.. code-block:: modelica

    parameter Integer n;
    StepVoltage Vs[n](Vf=fill(24, n));

This is an acceptable solution.  But imagine if we wanted to modify
both the value of ``Vf`` and the ``min`` attribute inside ``Vf``?
We'd end up with something like this:

.. code-block:: modelica

    parameter Integer n;
    StepVoltage Vs[n](Vf(min=fill(0,n))=fill(24, n));

With nested modifications, this kind of thing can get complicated
quickly.  Fortunately, Modelica includes a feature to deal with such
situations.  By placing the ``each`` keyword in front of a
modification, that modification is applied to every instance, *e.g.,*

.. code-block:: modelica

    parameter Integer n;
    StepVoltage Vs[n](each Vf(min=0)=24);

Modifications are an essential part of modeling because they allow us
to modify the parameter values down through the hierarchy.  As you can
see from the examples in this section, Modelica provides many features
to make applying modifications to hierarchies simple and powerful.
