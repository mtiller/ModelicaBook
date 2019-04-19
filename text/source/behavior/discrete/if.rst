.. _if:

If
--

.. index:: ! if

Although it is pretty intuitive, it is worth having a short review of
the syntax for ``if`` statements and ``if`` expressions.  Let's start
with ``if`` expressions because they are the simplest to explain.  An
``if`` expression has the form:

.. code-block:: modelica

    if cexpr then expr1 else expr2;

where ``cexpr`` is a conditional expression (that will evaluate to a
``Boolean`` value), ``expr1`` is the value the expression will have if
``cexpr`` evaluates to ``true`` and ``expr2`` is the value the
expression will have if ``cexpr`` evaluates to ``false``.

An ``if`` statement has the general syntax:

.. code-block:: modelica

    if cond1 then
      // Statements used if cond1==true
    elseif cond2 then
      // Statements used if cond1==false and cond2==true
    // ...
    elseif condn then
      // Statements used if all previous conditions are false
      // and condn==true
    else
      // Statements used otherwise
    end if;

It is important to note that when an ``if`` statement appears in an
``equation`` section, the number of equations must be the same
regardless of which branch through the ``if`` statement is taken (this
applies in the presence of ``elseif`` as well).  One exception is the
use of ``if`` within an ``initial equation`` or ``initial algorithm``
section where an ``else`` clause is not required since the number of
equations doesn't have to be same for both branches.  Another notable
exception is the use of ``if`` within :ref:`functions` where, again,
there is not requirement that the number of equations be the same
across both branches.

A special case here is when you have an ``if`` statement that looks like this:

.. code-block:: modelica

    if cond then
      x = y;
    else
      x = z;
    end if;

We can see that in both branches, a value is assigned to ``x``.  As such, an
equivalent way to write this using an ``if`` expression would be:

.. code-block:: modelica

    x = if cond then y else z;

The advantage of the second formulation is that it may make it easier for a tool
to optimize the code generation in the case of an ``if`` expression.

.. note::

    Note that conditional expressions within both ``if`` statements
    and ``if`` expressions have the potential to generate
    :ref:`events`.
