.. _func-flow:

Control Flow
============

In some cases, a function is simply a fixed set of step by step
calculations.  But in other cases, some kind of looping or iteration
is required.  In this section, we'll cover the different control
structures that are allowed within a function definition.

Branching
---------

We've already seen use cases involving ``if`` statements and
expressions.  These are, of course, allowed inside functions as well.
In fact, in an ``equation`` section there is a restriction on ``if``
statements that each branch of the ``if`` statement (*i.e.,* under all
conditions) generate the same number of equations.  But that
restriction does not apply in an ``algorithm`` section (*e.g.,* in a
function definition).

Looping
-------

.. index:: for
.. index:: functions; for

In an ``equation`` section, looping is (just like with branching)
restricted to ensure that the number of equations generated is the
same regardless of the state of the system.  For this reason, the only
looping construct allowed in an ``equation`` section (and, therefore,
the only one we have discussed up until now) is the ``for`` loop.

The syntax of a ``for`` loop is the same in a function as it is in any
other context.  It identifies an iteration variable and then assigns
that iteration variable a set of values contained in a vector, *e.g.,*

.. code-block:: modelica

    algorithm
      for i in 1:10 loop
        // Statements
      end for;

There two main differences between an ``equation`` section and an
``algorithm`` section is that an ``algorithm`` section uses explicit
assignment statements instead of equations and, since there are no
equations, there are no concerns about generating a specified number
of equations when using ``if`` or ``for``.

.. index:: while
.. index:: functions; while

In addition, an ``algorithm`` section allows us the opportunity to be
more flexible by permitting the use of ``while`` loops as well.  A
``while`` loop is not permitted in an ``equation`` section because, by
its very nature, the number of iterations (and, therefore, the number
of equations created in an ``equation`` section) is unpredictable.
But this unpredictability is not an issue in an ``algorithm`` section.

As we already saw in the ``InterpolateVector`` function from our
previous discussion of :ref:`Interpolation`, the syntax for a
``while`` loop is:

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/InterpolateVector.mo
   :language: modelica
   :lines: 14-16

The main elements of the ``while`` loop are the condition expression
that determines whether to continue looping and the statements within
the ``while`` loop.

``break`` and ``return``
------------------------

.. index:: break

When iterating, it is sometimes necessary to terminate the
iterations prematurely.  For example, in a ``for`` loop, the number of
iterations is normally determined by the vector of values being
iterated over.  But there are cases where subsequent iterations are
unnecessary.  Similarly, in a ``while`` loop, it may be convenient to
have a check within the ``while`` loop that indicates when to
terminate.  In these cases, a ``break`` statement can be used to
terminate the innermost loop.

.. index:: return

Another issue of control flow involves when to terminate and exit from
the ``algorithm`` section itself.  There are many circumstances in
which all the ``output`` variables have been assigned their final
values.  While it is always true that ``if`` and ``else`` statements
can be used to prevent any further calculations and assignments, it is
often more readable to simply indicate clearly that no further
calculations are needed.  In such cases, the ``return`` statement can
be used to terminate any further processing within a function's
``algorithm`` section.  When a ``return`` statement is encountered,
whatever values are currently associated with the ``output`` variables
are the ones that will be returned.
