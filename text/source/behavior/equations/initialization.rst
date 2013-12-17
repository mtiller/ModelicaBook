
.. _initialization:

Initialization
--------------

Overview
========

.. index:: ! initial equation

As we already touched on during our previous discussion on
:ref:`steady-state`, behavior is represented by both the equations
contained in a model as well as the initial conditions given to the
state variables in the model.  In Modelica, the initial conditions are
computed by combining the normal equations (present in `equation`
sections) with any initial equations (present in `initial equation`
sections).

.. index:: states
.. index:: states, initialization

One of the first sources of confusion for new users is understanding
how many initial conditions are required.  The answer to this question
is simple.  In order to have a well-posed initialization problem (one
where we don't have too many or too few initial equations), we need to
have the same number of equations in the `initial equation` sections
as we have states in our system.  **Note**, we can get away with
having too few, because tools can augment the initial equations we
provide with additional ones until the problem is well-posed, but we
cannot solve a problem where we have too many initial equations.

Of course, saying the number of initial equations has to be equal to
the number of states answers one question but quickly creates another,
*i.e.,* *how do we determine how many states there are*?  For the
models we've seen in this chapter, the answer is quite simple.  The
states in each of our examples so far are the variables that appear
inside the ``der(...)`` operator.  In other words, every variable that
we differentiate in these examples is a state.

Ordinary Differential Equations
===============================

It is important to note that **it will not always be the case** that
every variable that we differentiate will be a state.  In this
chapter, all the models we have seen so far are ordinary differential
equations (ODEs).  When dealing with ODEs, every differentiated
variable is a state.  Which, in turn, means that you need an initial
equation for each of these differentiated variables.  But in
subsequent chapters we will eventually run across examples that are
so-called algebraic-differential equations (DAEs).  In those cases,
only *some* of the differentiated variables can be considered states.

As it turns out, understanding initialization doesn't really require
us to get into a detailed discussion about DAEs.  In practice, all
Modelica tools perform something called "index reduction".  While the
index reduction algorithms themselves are fairly complicated (so we
won't get into those now), the effect is quite simple.  Index
reduction transforms the DAEs into ODEs.  In other words, Modelica
compilers will transform whatever DAE problem contained in our
Modelica code into this relatively easy to explain ODE form.

So let's side-step the discussion about DAEs and index reduction and
just pick up our discussion of initialization assuming our problem has
already been reduced to an ODE.  In this case, the only thing we
really need to understand is that initialization is required for all
states in the model and that our model will have the following general
ODE form:

.. math::
   :nowrap:

   \begin{align}
   \dot{\vec{x}}(t) & = \vec{f}(\vec{x}(t), \vec{u}(t), t) \\
   \vec{y}(t) & = \vec{g}(\vec{x}(t), \vec{u}(t), t)
   \end{align}

where :math:`t` is the current simulation time, :math:`\vec{x}(t)` are
the values of the states in our system at time :math:`t`,
:math:`\vec{u}(t)` are the values of any external inputs to our system
at time :math:`t`.

Note that the arrow over a variable simply indicates that it is a
vector, not a scalar.  Also note that the only variable that appears
differentiated in this problem is :math:`\vec{x}`.  This is how we
know that :math:`\vec{x}` represents the states in the system.  One
final thing to note about this system is that neither function,
:math:`\vec{f}` nor :math:`\vec{g}`, depends on :math:`\vec{y}`.

If you think about it, both :math:`t` and :math:`\vec{u}(t)` are
external to our system.  We don't compute them or control them.  The
reason that we call :math:`\vec{x}` the state of our system is that it
the only information (from within our system) needed to compute
:math:`\dot{\vec{x}}(t)` and :math:`\vec{y}(t)` (which, in turn, are
the only things we need to compute in order to arrive at a solution).

Getting back to the topic of initialization, during a normal time step
we will solve for :math:`\vec{x}(t)` by integrating
:math:`\dot{\vec{x}}(t)` to compute :math:`\vec{x}(t)`.  In other
words:

.. math::

  \vec{x}(T) = \int_{t_i}^{T} \dot{\vec{x}}(t) \  dt +  \vec{x}(t_i)

This all works as long as there **was** a previous time step.  When
there wasn't a previous time step, then the value of :math:`\vec{x}`
that we plug into our equations has to be the very first value of
:math:`\vec{x}` in our simulation.  In other words, our initial
conditions.

One might imagine that we would specify our initial conditions by
adding an equation like this:

.. math::

  \vec{x}(t_0) = \vec{x}_0

where :math:`t_0` is the start time of our simulation and
:math:`\vec{x}_0` is an explicit specification of the initial values.
Providing explicit values for states is a very common case when
specifying initial conditions.  So we definitely need to be able to
handle this case.  But this approach won't work for the cases we
showed in :ref:`steady-state`.  There we didn't provide explicit
initial values for states.  Instead, we provided initial values for
:math:`\dot{\vec{x}}(t_0)`.  So how can we capture both of these
cases?

Initial Equations
=================

The answer is to assume that at the start of our simulation we need to
solve a problem that looks like this:

.. math::
   :nowrap:

   \begin{align}
   \dot{\vec{x}}(t_0) & = \vec{f}(\vec{x}(t_0), \vec{u}(t), t_0) \\
   \vec{y}(t_0) & = \vec{g}(\vec{x}(t_0), \vec{u}(t_0), t_0) \\
   \vec{0} & = \vec{h}(\vec{x}(t_0), \dot{\vec{x}}(t_0), \vec{u}(t_0), t_0)
   \end{align}

Note the introduction of a new function, :math:`\vec{h}`.  This new
function represents any equations we have placed in `initial equation`
sections.  The fact that :math:`\vec{h}` takes both :math:`\vec{x}`
**and** :math:`\dot{\vec{x}}` as arguments allows us to express a wide
range of initial conditions.  To define explicit initial values for
states, we could define :math:`\vec{h}` as:

.. math::

  \vec{h}(\vec{x}(t_0), \dot{\vec{x}}(t_0), \vec{u}(t_0), t_0) = \vec{x}(t_0)-\vec{x}_0

But we could also express our desire to start with a steady state
solution by defining :math:`\vec{h}` as:

.. math::

  \vec{h}(\vec{x}(t_0), \dot{\vec{x}}(t_0), \vec{u}(t_0), t_0) = \dot{\vec{x}}(t_0)

And, of course, we could mix these different forms or use a wide range
of other forms on a per state basis to describe our initial
conditions.  So when writing initial equations, all you need to keep
in mind is that they need to be of the general form shown above and
that you cannot have more of them than you have states in your system.

Conclusion
==========

As we've demonstrated in this chapter, the `initial equation`
construct in Modelica allows us to express many ways to initialize our
system.  In the end, all of them will compute the initial values for
the states in our system.  But we are given tremendous latitude in
describing exactly how those values will be computed.

This is an area where Modelica excels.  Initialization is given first
class treatment in Modelica and these flexibility pays off in many
real world applications.
