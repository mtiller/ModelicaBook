
.. _initialization:

Initialization
--------------

As we already touched during our previous discussion on
:ref:`steady-state`, behavior is represented by both the equations
contained in a model as well as the initial conditions given to the
state variables in the model.  In Modelica, the initial conditions are
computed by combing the normal equations (present in `equation`
sections) with any initial equations (present in `initial equation`
sections).

.. index:: states
.. index:: states, initialization

One of the first sources of confusion for new users is understanding
how many initial conditions are required.  The answer to this question
is simple.  In order to have a well-posed initialization problem (one
where we don't have too many or too few initial equations), we need to
have the same number of equations in the `initial equation` sections
as we have states in our system.

Of course, this answers one question but creates another, *i.e.,* *how
do we determine how many states there are*?  For the models we've seen
in this chapter, the answer is quite simple.  The states in each of
our examples so far are the variables that appear inside the
``der(...)`` operator.  In other words, every variable that we
differentiate in these examples is a state.

.. note::

  It is important to note that it will not always be the case every
  variable that we differentiate will be a state.  In this chapter,
  all the models we have seen so far are ordinary differential
  equations (ODEs).  When dealing with ODEs, every differentiated
  variable is a state.  Which, in turn, means that you need an initial
  equation for each of these differentiated variables.  But in
  subsequent chapters we will eventually run across examples that are
  so-called algebraic-differential equations (DAEs).  In those cases,
  only *some* of the differentiated variables can be considered
  states.

.. todo:: Figure out where we will go deeper into DAEs

As it turns out, understanding initialization doesn't really require
us to get into a detailed discussion about DAEs.  The only thing we
really need to make clear is that initialization is required for all
states in the model.  In this section, we'll use ODEs as our examples
just to avoid confusing the issue of initialization more than
necessary.

The following equation shows the general form for ODEs:

.. math::
   :nowrap:

   \begin{aligned}
   \dot{\vec{x}} & = \vec{f}(\vec{x}, \vec{u}, t) \\
   \vec{y} & = \vec{g}(\vec{x}, \vec{u}, t)
   \end{aligned}

The first thing to notice about this system of equations is the arrow
over many of the variables.  This simply indicates that these are
vectors.  The other thing to note is that the variable that appears
differentiated in this problem is :math:`\vec{x}`.  Combining these
two facts we can conclude that every element of :math:`\vec{x}` is a
state in this problem.  One final thing to note about this system is
that neither function, :math:`\vec{f}` nor :math:`\vec{g}`, depends on
:math:`\vec{y}`.

Make sure problems are well specified.  Note default initial condition
in :ref:`first-order`
vs. :ref:`first-order-init`

.. index:: ! start attribute
.. index:: ! initial equation
.. index:: ! descriptive strings
