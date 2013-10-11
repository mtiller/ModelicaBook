.. ; -*- eval: (auto-fill-mode 1); -*-

***************
Basic Equations
***************

.. _eqs:

.. _eqs-basic:

Ultimately, the purpose of the Modelica language is to create a
language that is capable of describing mathematical behavior. So we
will start with some very basic examples of describing mathematical
behavior so you can become familiar with the basic syntax of Modelica.
In subsequent chapters, we will investigate the many other compelling
capabilities in the Modelica language.

..
  - Building basic models
  - Examples
    - First model (simpler ODE)
    - Newton's law of cooling (same model)
      - Physical types
      - Initial equations
    - RLC
    - Lotka-Voterra
  - Complete Summary
    - Variables
    - Derivatives (applied to expressions?)
    - Variability
    - Types
    - Equations

Examples
========

.. _eq-examples:

Simplest Possible Model
-----------------------

.. _eqs-simplest:

Let's start with the simplest possible dynamic model we can build in
Modelica. Mathematically, what we want to do is model the following
equation:

.. math:: \dot{x} = (1-x)
   :label: first_order

If :math:`x(t=0)=0`, then we would expect the solution to this
equation to look like:

.. plot:: Plots/first_order.py
   :include-source: False

This simple first-order ordinary differential equation
:eq:`first_order` can be described by the following Modelica code:

.. _ex-first-order:

.. literalinclude:: Examples/FirstOrder.mo
   :language: modelica

Hopefully, it is obvious how we mapped the mathematical equation,
:math:`\dot{x} = 1-x`, into it's Modelica equivalent ``der(x) = 1-x``.
Obviously, the ``der`` operator in Modelica represents the time
derivative of the variable it is applied to.

An important thing to note about Modelica is the fact that equations
are exactly that, *equations*.  They are not "assignment statements".
Practically speaking, what does this mean?  It means that when you
write Modelica code you don't need to worry about what is already
known and what needs to be computed (and in what order).  You only
need to describe the mathematical relationship between the various
terms.  For this reason, the following equations are all equivalent:

.. sourcecode:: modelica

  der(x) = -x;
  der(x) + x = 0;
  x + der(x) = 0;

We will shortly return to this topic of equations with a discussion of
the difference between equations and how statements in "normal" programming
languages work.

Making it Real
--------------

Let's take our ``FirstOrder`` model and add some more physical details
to make it seem a little more "real" (albeit still very simple).

Consider how a hot cup of coffee behaves as it cools down.  We know
from Newton's Law of Cooling that the temperature will follow an
exponential trajectory because it obeys the equation:

.. math:: m c_p \dot{T} = -h A (T-T_{ref})
   :label: newton_cooling

Again, we have a first-order ordinary differential equation.  But we
have a few more physical details.  In this case, our equation includes
the mass of the cup of coffee, :math:`m`, the specific heat of the
coffee, :math:`c_p`, the temperature of the coffee, :math:`T`, the
heat transfer coefficient to the environment, :math:`h`, the surface
area between the cup of coffee and the environment, :math:`A` and
finally the temperature of the environment, :math:`T_{ref}`.

To build the equivalent Modelica model for such a system, the source
code might look as follows:

.. literalinclude:: Examples/NewtonCooling.mo
   :language: modelica

Although mathematically, this model is not much different then the
``FirstOrder`` model (it has a few more variables but retains the same basic
equation) there are a few important differences.

First, you see that all the variables have some kind of physical type
associated with them (*e.g.* ``Temperature``, ``Area``, *etc*).  These
types are "imported" from a special library of physical types (based
on `ISO standard 31-1992 <http://en.wikipedia.org/wiki/ISO_31>`_) by the statement ``import Modelica.SIunits.*``
which essentially means "take everything in the ``Modelica.SIunits``
package and include it here" [#foot-import]_.

Another difference is the fact that descriptions of all the variables
and equations are included.  It's important to note that the text
within the ``""``'s **is not a comment**.  These fragments of text are
descriptive strings and, unlike comments, they are part of the
language grammar and are formally associated with the variables and
equations.  This is important because Modelica tools can (and most, if
not all, *do*) use this information to make better dialogs and
generated documentation.

Finally, several of the variables in this problem are prefixed by the
``parameter`` qualifier.  This indicates that these variables do not
change with respect to time.  Instead, they are used to represent
characteristics of the system (or components within the system).

Unfortunately, we cannot simulate this model because none of the
parameters in the model have values.  In some sense, our model
contains 6 unknowns but only one equation.  Of those 6 unknowns, 5 are
parameters and the assumption is that parameter values are known *a
priori*.  So instead of adding equations for unknowns that happen to
be parameters, we normally give them values as shown in the
``DetailedNewtonCooling`` model below.

.. literalinclude:: Examples/DetailedNewtonCooling.mo
   :language: modelica
   :emphasize-lines: 3-7

Note the presence of the initializer expressions for the parameters.

Now we have a model that can be simulated and when simulated the
solution trajectory should like like this:

.. plot:: Plots/complete_newton_cooling.py

.. _eqs-initialize:

Providing Initial Values
------------------------

A close look at the results for the ``DetailedNewtonCooling`` model
shows that the solution is in degrees Kelvin and the initial
conditions assume that the initial temperature of our "hot" cup of
coffee is 0K.  Since "absolute zero" would not be considered "hot" by
anyone's standards, we should 

.. index:: start attribute

There are two ways we can specify the initial value for a state
variable.  The first is using something called the ``start``
attribute.  If we had declared our temperature as follows:

.. sourcecode:: modelica

  Temperature T(start=350) "Coffee cup temperature";

As you can see, we have added a non-zero value for the ``start``
attribute associated with the variable ``T``.  As we will cover later
in :ref:`eqs-basic-summary` there are a few important caveats to
consider when using the ``start`` attribute.

.. index:: initial equation

Another way to specify initial conditions is using an ``initial
equation`` section, *e.g.*

.. sourcecode:: modelica

  initial equation
    T = 350;

In both cases, an initial value of 350 for ``T`` will be used.  The
following plot shows the difference between the analytical solution to
Equation :eq:`newton_cooling` plotted against a simulated solution to
the ``DetailedNewtonCooling`` model where an initial temperature of
350 is used:

.. plot:: Plots/first_order_compare.py

The advantage of using an ``initial equation`` section is that it is
both more explicit and more general.  This is because it introduces a
formal equation to use for computing initial values.  This equation
does not have to be just an initial value for a given state, it can be
an arbitrarily complex equation.  For example, we could include any of
the following as an initial equation:

.. sourcecode:: modelica

   initial equation
     der(T) = 0 "Start in steady-state";

This would cause our system to start in steady-state.  By inspection,
we can see that the system is only in equilibrium if the coffee is at
the ambient temperature.  But for complex systems (or complex initial
equations), it is frequently quite difficult to determine how to
achieve a steady-state result.  Fortunately, Modelica allows us to
state our intent (*i.e.* pick ``T`` such that it's derivative is zero
at the start of the simulation) instead of forcing us to derivate an
explicit equation.

.. _eqs-basic-summary:

Review of Basic Equations
=========================

Definitions
-----------

So far, we've seen a few examples of building models.  But let's take
moment to review what we've seen.

From the various examples, we saw that defining a model in Modelica
follows a template like this:

.. sourcecode: modelica

  model <ModelName>
    <Parameters>
    <Variables>
  equation
    <Equations>
  end <ModelName>;

As we will see later, we can create a definition for something other
than a ``model``.  But for now, we will focus on ``model`` since it is
the primary entity we will be dealing with.  This is, of course, a
simplification of the complete Modelica grammar, but it is a more than
sufficient as we get started.

Variables
---------

Declaring variables within a model is a simple matter of identifying
the type of variable (*e.g.*, ``Real``) and giving it a name (*e.g.*,
``x``).  There are four fundamental types of variables in Modelica

- ``Real``
- ``Integer``
- ``Boolean``
- ``String``

As we saw in the ``NewtonCooling`` example, we can associate physical
types like ``Area`` with a variable.  These are :term:`derived
types`.  In the case of ``Area``, it is derived from the ``Real`` type
and specialized to represent a physical area.  In the case of
``Area``, this means that it is given units (:math:`m^2`) and limits
(it cannot be less than zero).  But fundamentally, it is still a real
variable.

In addition to a name and a type, variables can also have a
"variability" associated with them.  In our example, we introduced the
``parameter`` keyword which indicates that a given variable does not
change with time.  Modelica also includes a special ``constant``
qualifier that indicates the variable will not change **ever** (*e.g.*
the ideal gas constant).  Another qualifier is the ``discrete``
qualifier which indicates that a variable is piece-wise constant (we
will explain that more in :ref:`discrete-equations`.

In several of our examples so far, there were variables where the
variability was unspecified.  By default, ``Real`` variables are
continuous unless otherwise qualified.  Similarly, ``Integer``,
``Boolean`` and ``String`` variables are ``discrete`` by default.


Equations
---------

From the examples, we introduced several different types of equations.
These are more or less identical to their mathematical counterparts.
Since differential equations are an important aspect of the Modelica
language, the ``der`` operator will play a central role in most
models.  So the ability to express the time derivative of a variable
is an important aspect of writing equations.

Another important aspect about equations in Modelica is that they are
truly equations and not assignment statements.  This means that we do
not need to stick to equations that are explicit equations for a given
variable (*e.g.* ``x = ...``).  Instead, we can have more general
equations (*e.g.* ``x + y = a*b``) where we have expressions on both
sides of the ``=`` sign.

Furthermore, equations *always* apply.  This has two important
consequences.  First, it means their relative order does not matter.
So,

.. sourcecode:: modelica

  a = x+y;
  b = a+z;

is equivalent to:

.. sourcecode:: modelica

  b = a+z;
  a = x+y;

If you are used to conventional "imperative" programming languages,
this looks incorrect because ``a`` is used before it is given a value.
But the equation ``a = x+y`` always applies.  These equations are not
executed sequentially, they are simultaneous equations.  But by this
same token, you cannot incrementally compute a value by chaining
together assignments.  For example, in imperative languages (*e.g.* C,
Java, *etc*), you might perform a calculation like this:

.. sourcecode:: c

  b = 4.0*a;
  b = b+25;
  b = b^2;

as a way of breaking down the more complex expression ``b =
((a*4.0)+25)^2)``.  However, if you write that same code in Modelica
you introducing 3 different relations that always have to hold.  To
understand the problem with this, look at it from a mathematical
perspective.  Imagine you were given the following three equations:

.. math:: b = 4*a

.. math:: b = b + 25

.. math:: b = b^2

What would this tell us about ``b`` (when viewed in this
*mathematical* context).  Let's start with the last equation, :math:`b
= b^2`.  Mathematically, this tells us that :math:`b = 0` or
:math:`b=1`.  Those are the only values for `b` that could satisfy
this equation.  The penultimate equation, :math:`b = b + 25`, has no
solution since no number can also be that same number plus 25.  In
Modelica, you must either write the complete equation, *i.e*,

.. sourcecode:: modelica

  b = ((4*a)+25)^2;

or, you would need to give the intermediate results different names,
*e.g.*

.. sourcecode:: modelica

  b1 = 4*a;
  b2 = b1+25;
  b = b2^2;

There are cases where you would like the ability to compute values
incrementally like you would in C.  That is possible and will be
discussed later in :ref:`algorithms`.  But whenever possible,
equations should be used because there are some important
optimizations that can be performed on equations.

Initialization
--------------

Finally, we introduced the idea of initial equations.  These are
equations that are used at the start of a simulation to compute
initial conditions.  To understand exactly how these initial equations
are used, let's take a step back to understand how our equations are
simulated.

If we have a system of ordinary differential equations of the form:

.. math:: \dot{x} = f(x, t)

where :math:`x \in \mathbb{R}^n`.  In this case, each *x* is a
:term:`state`.  We solve this system by assuming that we know the
values of the states (:math:`x_1 ... x_n`) at the current time.  So we
compute the derivatives (:math:`\dot{x_1} ... \dot{x_n}`) and then
using the equation:

.. math:: x_i(t) = \int_{t_i}^{t_f}{\dot{x_i} dt} + x_i(t=t_i)

So the solution process is basically:

- Assume an initial value for all values of *x*
- Compute the derivatives of *x* using the function *f*
- Integrate the derivatives the compute new values for *x*
- Repeat

Each step simply depends on the results from the previous steps.  So
the problem is reduced down to how do we start this process.  We have
to provide some initial value at some point and once that happens the
whole process is bootstrapped and can continue on its own.

Another way to think of this is as follows:

The differential equations in our model tell us how, given one set
of states, we can get to the next set of states.  But they don't tell
us how to pick the very first set.  So while we have enough equations
to simulate, we don't have enough equations to *start*.

Of course, the simplest way to start is to just pick values for each
of the state variables.  The problem is, that might not be a good way
to describe the initial state of your system.  For example, in the
previous section on :ref:`eqs-initialize` we saw the following example:

.. sourcecode:: modelica

   initial equation
     der(T) = 0 "Start in steady-state";

This equation is an *implicit* equation for the initial value of *T*.
It doesn't say "At the start of the simulation, *T* should be ...".
Instead, it says "At the start of the simulation, determine *T* **such
that** the derivative of *T* is zero".  This is very useful because,
depending on the complexity of our system's dynamics, it may be very
difficult or tedious (or error prone) to derive an explicit equation
for *T* that accomplishes the same thing.

Conclusion
==========

This chapter introduced a few examples of how to build models in
Modelica.  This covered the basics of how to define a model, declare
variables and specify equations.  We even discussed different ways to
compute initial values for state variables.

There are a surprisingly large class of interesting problems that you
can already tackle with just these building blocks.  However, as we
shall see in the following chapters, there is much more to Modelica
than just simple equations.

.. index::
   keyword: model
   keyword: der
   keyword: end
   keyword: equation
   keyword: initial
   keyword: constant
   keyword: parameter
   keyword: false
   keyword: true
   keyword: import
   keyword: in
   keyword: for
   keyword: loop
   keyword: if
   keyword: then
   keyword: else
   keyword: elseif
   keyword: and
   keyword: not
   keyword: or

.. [#foot-import] OK, not exactly *included*, but at least accessible from here.
