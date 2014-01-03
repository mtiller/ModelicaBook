.. _interpolation:

Interpolation
=============

In this chapter, we will example different ways of implementing a
simple one dimension interpolation scheme.  We'll start with an
approach that is written completely in Modelica and then show an
alternative implementation that combines Modelica with C.  The
advantages and disadvantages of each approach will then be discussed.

Modelica Implementation
-----------------------

Function Definition
~~~~~~~~~~~~~~~~~~~

For this example, we assume that we interpolation data in the
following form:

===============================  ===============================
Independent Variable, :math:`x`   Dependent Variable, :math:`y`
-------------------------------  -------------------------------
:math:`x_1`                      :math:`y_1`
:math:`x_2`                      :math:`y_2`
:math:`x_3`                      :math:`y_3`
...                              ...
:math:`x_n`                      :math:`y_n`
===============================  ===============================

where we assume that :math:`x_i<x_{i+1}`.

Given this data and the value for the independent variable :math:`x`
that we are interested in, our function should return an interpolated
value for :math:`y`.  Such a function could be implemented in Modelica
as follows:

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/InterpolateVector.mo
   :language: modelica
   :lines: 2-

Let's go through this function piece by piece to understand what is
going on.  We'll start with the argument declarations:

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/InterpolateVector.mo
   :language: modelica
   :lines: 3-5

The ``input`` argument ``x`` represents the value of the independent
variable we wish to use for interpolating our function, the ``input``
argument ``ybar`` represents the interpolation data and the ``output``
argument ``y`` represents the interpolated value.  The next part of
the function contains:

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/InterpolateVector.mo
   :language: modelica
   :lines: 6-9

The part of our function includes the declaration of various
``protected`` variables.  As we saw in our
:ref:`polynomial-evaluation` example, these are effectively
intermediate variables used internally by the function.  In this case,
``i`` is going to be used as an index variable, ``n`` is the number of
data points in our interpolation data and ``p`` represents a weight
used in our interpolation scheme.

With all the variable declarations out of the way, we can now
implement the ``algorithm`` section of our function:

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/InterpolateVector.mo
   :language: modelica
   :lines: 10-18

The first two statements are ``assert`` statements that verify that
the value of ``x`` is within the interval :math:`[x_1, x_n]`.  If not,
an error message will be generated explaining why the interpolation
failed.

The rest of the function searches for the value of ``i`` such that
:math:`x_i<=x<x_{i+1}`.  Once that value of ``i`` has been identified,
the interpolated value is computed as simply:

.. math::

    y = p\ \bar{y}_{i+1,2}+(1-p)\ \bar{y}_{i,2}

where

.. math::

    p = \frac{x-\bar{y}_{i,1}}{\bar{y}_{i+1,1}-\bar{y}_{i,1}]}

Test Case
~~~~~~~~~

Now, let's test this function by using it from within a model.  As a
simple test case, let's integrate the value returned by the
interpolation function.  We'll use the following data as the basis for
our function:

========== ============
:math:`x`   :math:`y`
---------- ------------
0          0
2          0
4          2
6          0
8          0
========== ============

If we plot this data, we see that our interpolated function looks like
this:

.. plot::

   import matplotlib.pyplot as plt
   import numpy as np
   x = [0, 2, 4, 6, 8]
   y = [0, 0, 2, 0, 0]
   plt.plot(x,y)
   plt.axis([0, 8, -1, 3])
   plt.title("Interpolated Function")
   plt.show()

In the following model, the independent variable ``x`` is set equal to
``time``.  The sample data is then used to interpolate a value for the
variable ``y``.  The value of ``y`` is then integrated to compute
``z``.

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/IntegrateInterpolatedVector.mo
   :language: modelica
   :lines: 2-

We can see the simulated results from this model in the following plot:

.. plot:: ../plots/IIV.py
   :include-source: no

There are a couple of drawbacks to this approach.  The first is that
the data needs to be passed around anywhere the function is used.
Also, for higher dimensional interpolation schemes, the data required
can be both complex (for irregular grids) and large.  So it is not
necessarily convenient to store the data in the Modelica source code.
For example, it might be preferable to store the data in an external
file.  However, to populate the interpolation data from a source other
than the Modelica source code, we will need to use an
``ExternalObject``.

Using an ``ExternalObject``
---------------------------

.. index:: ExternalObject

The ``ExternalObject`` type is a special type used to refer to
information that is not (necessarily) represented in the Modelica
source code.  The main use of the ``ExternalObject`` type is to
represent data or state that is maintained outside the Modelica source
code.  This might be interpolation data, as we will see in a moment,
or it might represent some other software system that maintains its
own state (like the :ref:`sil-controller` example in the next
section).

