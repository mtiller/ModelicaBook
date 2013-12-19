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
    else
      // Statements used otherwise
    end if;

.. todo:: clarify: can you have multiple elseif statements?

.. todo:: clarify: instead of saying the number of equations must be the same
regardless of the value of cond1, would it not be more accurate  to end with
must be the same in each branch of the if statement since the number of
statements must be the same regardless of the value of cond1 *and* cond2

The use of ``elseif`` is always optional.  The use of ``else`` is
generally required since the number of equations must be the same
regardless of the value of ``cond1``.  One exception is the use of
``if`` within an ``initial equation`` or ``initial algorithm`` section
where an ``else`` clause is not required since the number of equations
doesn't have to be same for both branches.  Another notable exception
is the use of ``if`` within :ref:`functions` where, again, there is
not requirement that the number of equations be the same across both
branches.

.. note::

    Note that conditional expressions within both ``if`` statements
    and ``if`` expressions have the potential to generate
    :ref:`events`.
