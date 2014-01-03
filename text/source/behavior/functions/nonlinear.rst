.. _nonlinearities:

Non-Linearities
===============

Our next example involving functions demonstrates how to address
issues that come up when solving non-linear systems of equations that
involve functions.

We'll start with a simple model that includes this simple mathematical
relationship:

.. math::

    y = 2 t^2 + 3 t + 1

where :math:`t` is time.  This model can be implemented in Modelica as follows:

.. literalinclude:: /ModelicaByExample/Functions/Nonlinearities/ExplicitEvaluation.mo
   :language: modelica
   :lines: 2-

where the ``Quadratic`` function, which we will discuss shortly,
evaluates a quadratic polynomial.

Simulating this model gives the following solution for ``y``:

.. plot:: ../plots/NLEE.py
   :include-source: no

So far, all of this appears quite reasonable and, based on our
previous discussion on :ref:`polynomial-evaluation`, the
implementation of ``Quadratic`` isn't likely to hold too many
surprises.  However, let's make things a little more complicated.
Consider the following model:

.. literalinclude:: /ModelicaByExample/Functions/Nonlinearities/ImplicitEvaluation.mo
   :language: modelica
   :lines: 2-

This model amounts to solving the following equation:

.. math::

    t+5 = 2 y^2 + 3 y + 1

The important difference here is that the left hand side is known and
we must compute the value of :math:`y` that satisfies this equation.
In other words, instead of evaluating a quadratic polynomial, like we
were doing in the previous example, now we have to solve a quadratic
equation.

A model that requires solving a non-linear system of equations is not
remarkable by itself.  Modelica compilers are certainly more than
capable of recognizing and solving non-linear systems of equations
(although these methods usually depend on having a reasonable initial
guess in order to converge).

However, it turns out that in this case, **the Modelica compiler
doesn't actually need to solve a non-linear system**.  Although we
couldn't know this until we saw how the ``Quadratic`` function is
implemented:

.. literalinclude:: /ModelicaByExample/Functions/Nonlinearities/ExplicitEvaluation.mo
   :language: modelica
   :emphasize-lines: 9
   :lines: 2-

In particular, note the line specifying the ``inverse`` annotation.
In this way, we not only tell the Modelica compiler how to evaluate
the ``Quadratic`` function but, through the ``inverse`` annotation, we
are also indicating what function to use if we need to compute ``x``
in terms of ``y``.  In the case of our ``ImplicitEvaluation`` model,
the Modelica compiler can then substitute this inverse function into
the equations.  So, where we initially had, ignoring the coefficient
arguments for the moment, the following equation to solve:

.. math::

    t+5 = f(y)

which must be solved as an implicit equation for :math:`y`, we can now
solve the following **explicit** equation:

.. math::

    y = f^{-1}(t+5)

by using the ``InverseQuadratic`` function as the inverse function.

Simulating the ``ImplicitEvaluation`` model we get the following
solution for ``y``:

.. todo:: Make this more consistent with the explicit so it is obvious
	  from the plot that this is the inverse.

.. plot:: ../plots/NLIE.py
   :include-source: no

