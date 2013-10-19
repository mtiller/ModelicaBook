Basic Equations
***************

As mentioned in the the :ref:`preface`, our exploration of Modelica
starts with understanding how to represent basic behavior.  In this
chapter, our focus will be on demonstrating how to write basic
equations.

Examples
========

.. _first-order:

Simple First Order System
-------------------------

Let us consider an extremely simple differential equation:

.. math:: \dot{x} = (1-x)

Looking at this equation, we see there is only one variable,
:math:`x`.  This equation can be represented in Modelica as follows:

.. _ex_SimpleExample_FirstOrder:

.. literalinclude:: /ModelicaByExample/BasicEquations/SimpleExample/FirstOrder.mo
   :language: modelica
   :lines: 2-

.. index:: model
.. index:: der

This code starts with the keyword :keyword:`model` which is used to
indicate the start of the model definition.  The :keyword:`model` is
followed by the model name, ``FirstOrder``.  This is, in turn, followed
by a declaration of all the variables we are interested.  Since the
variable :math:`x` in our equation is clearly mean to be a continuous
real valued variable, it's declaration in Modelica takes the form
``Real x;``.  After all the variables have been declared, we can begin
including the equations that describe the behavior of our model.  In
our case, we can use the :keyword:`der` operator to represent the time
derivative of ``x``.

Unlike most programming languages, we don't approach code like this as
a "program" that can be interpreted as a set of instructions to be
executed one after the other.  Instead, we use Modelica tools to
transform this model into something that we can simulate.  This
simulation step essentially amounts to solving (usually numerically)
the equation and providing a solution trajectory.

.. simulate::
   :model: BasicEquations.SimpleExample.FirstOrder
   :start_time: 0.0

.. plot:: plots/SimpleExample_FirstOrder.py
   :include-source: no


Review
======

.. index:: ! der
.. index:: ! model
