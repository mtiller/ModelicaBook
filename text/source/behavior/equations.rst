Basic Equations
***************

As mentioned in the :ref:`preface`, our exploration of Modelica starts
with understanding how to represent basic behavior.  In this chapter,
our focus will be on demonstrating how to write basic equations.

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
.. index:: Real

This code starts with the keyword ``model`` which is used to indicate
the start of the model definition.  The ``model`` is followed by the
model name, ``FirstOrder``.  This is, in turn, followed by a
declaration of all the variables we are interested.  Since the
variable :math:`x` in our equation is clearly mean to be a continuous
real valued variable, it's declaration in Modelica takes the form
``Real x;``.  The ``Real`` type is just one of the types we can use.
See :ref:`variables` for a more complete description of the various
possibilities.

After all the variables have been declared, we can begin
including the equations that describe the behavior of our model.  In
our case, we can use the ``der`` operator to represent the time
derivative of ``x``.

Unlike most programming languages, we don't approach code like this as
a "program" that can be interpreted as a set of instructions to be
executed one after the other.  Instead, we use Modelica tools to
transform this model into something that we can simulate.  This
simulation step essentially amounts to solving (usually numerically)
the equation and providing a solution trajectory.

.. plot:: ../plots/BasicEquations_SimpleExample_FirstOrder.py
   :include-source: no

This gives you the first initial hint at one of the compelling aspect
of using a modeling language to describe mathematical behavior.  We
didn't need to describe the solution scheme at all.  The focus is
entirely on behavior.  As we work our way through more complex
examples, we will see that lots of tedious work involving the solution
process is avoided using Modelica.

.. _first-order-doc:

Adding Some Documentation
^^^^^^^^^^^^^^^^^^^^^^^^^

Now that we've solved this simple mathematical equation, let's turn
our attention briefly to how we can make the model a bit more
readable.  Consider the following model:

.. _ex_SimpleExample_FirstOrderDocumented:

.. literalinclude:: /ModelicaByExample/BasicEquations/SimpleExample/FirstOrderDocumented.mo
   :language: modelica
   :lines: 2-

.. index:: descriptive strings

Note the quoted text in this model.  An important thing to understand
about that quoted text is that those strings are **not** comments.
They are "descriptive strings" and, unlike comments, they cannot be
added in arbitrary places.  Instead, they can be inserted in specific
places to provide additional documentation about the model.

For example, the first string "A simple first order differential
equation" is used to describe what this is a model of.  Note how it
follows the name of the model.  If you wish to include such
documentation about the model, it must appear immediately after the
model name as shown.  As we will see later, this kind of documentation
can be used by tools in many ways.  For example, when searching for
models tools may look for matches within this descriptive text.  When
displaying models within a package, this text may be associated with
the graphical representation of the models somehow.  And, of course,
this kind of documentation is very useful for anybody reading the
model.

As we can see in this example, there are other places that the
descriptive text can appear.  For example, it may be included after
the declaration of a variable to document that variable.  It can also
be included after an equation to document the equation.

.. _first-order-init:

Initialization
^^^^^^^^^^^^^^

As we have seen already, Modelica allows us to describe differential
equations.  But an important part of any differential equation
solution is the initial conditions.  Modelica gives us equally
powerful constructs for describing the initialization of our system of
equation.  For example, if we wanted the initial value of ``x`` in our
model to be *2*, we could add an ``initial equation`` section to our
model as follows:

.. index:: initial equation

.. _ex_SimpleExample_FirstOrderInitial:

.. literalinclude:: /ModelicaByExample/BasicEquations/SimpleExample/FirstOrderInitial.mo
   :language: modelica
   :lines: 2-

Note that the only difference between this model and the previous one
in `Adding Some Documentation`_ is the addition of the
``initial equation`` section including the equation ``x = 2``.  If we
add this equation, our system has a different initial starting
condition and the solution trajectory is quite different as we can see
in the following figure:

.. plot:: ../plots/BasicEquations_SimpleExample_FirstOrderInitial.py
   :include-source: no

Example :ref:`FirstOrderInitial <ex_SimpleExample_FirstOrderInitial>`
shows a typical way of initializing a system by providing initial
values for the states of the system.  In fact, initial value problems
are frequently written as a combination of the differential equations
and initial conditions, *e.g.*,

.. math:: \dot{x} = (1-x);\; x(0) = 2

However, there are many cases where you want a more sophisticated type
of initialization.  An ``initial equation`` section can contain more
than just explicit equations for the values of the state variables.
For example, if we wanted our first order system to be initialized to
some steady-state condition but it was too complex to compute the
explicit values for the state variables, we can simply express our
initialization as:

.. literalinclude:: /ModelicaByExample/BasicEquations/SimpleExample/FirstOrderSteady.mo
   :language: modelica
   :lines: 2-

Simulating this system gives the following solution:

.. plot:: ../plots/BasicEquations_SimpleExample_FirstOrderSteady.py
   :include-source: no

Complete coverage of the initialization topic can be found in the
:ref:`initialization` section of this chapter.

Getting Physical
----------------

Although the previous section got us started with representing
mathematical behavior, it doesn't convey any connection to physical
behavior.  In this section, we'll explore how to build models that are
clearly modeling physical behavior and some of the language features
we can leverage to make these models clear and even help prevent
errors.

Let's start with the following example:

.. literalinclude:: /ModelicaByExample/BasicEquations/CoolingExample/NewtonCooling.mo
   :language: modelica
   :lines: 2-

.. index:: parameter

Again, we see the familiar pattern, from our :ref:`first-order`
example, of a ``model`` definition that includes variables and
equations.  However, this time we see the word ``parameter`` for the
first time.  Generally speaking, the ``parameter`` keyword is used to
indicate variables whose value is known *a priori*.  More precisely,
``parameter`` is a keyword that specifies the *variability* of the
variable.  This will be discussed more thoroughly in the section on
:ref:`variability`.

Looking our the ``NewtonCooling`` example, we see there are five
parameters: ``T_inf``, ``T0``, ``h``, ``m`` and ``c_p``.  We don't
need to bother explaining what these variables are because the model
itself includes a descriptive string for each one.  At the moment,
there are no values for these parameters, but we will return to that
topic shortly.  As with all the variables we have seen so far, all
these variables are of type ``Real``.

Let's examine the rest of this model.  The next variable is ``T``
(also a ``Real``).  This variable is truly an unknown since it does
not have the ``parameter`` qualifier.

Next we see the two ``equation`` sections.  The first is an ``initial
equation`` section so it specifies how the variable ``T`` should be
initialized.  It should be pretty clear that the initial value for
``T`` is going to be whatever value was given for the parameters
``T0``.

The other equation is the differential equation that governs the
behavior of ``T``.  Mathematically, we could express this equation as:

.. math:: m c_p \dot{T} = h (T_{\infty}-T)

What we see in our ``NewtonCooling`` example is how this equation
would be expressed in Modelica.  Note that this is really no different
than the equation we saw in our ``FirstOrder`` model from the
:ref:`first-order` example.  One thing worth noting is that the
equation in our ``NewtonCooling`` example contains a complete
expression on the left hand side.  In Modelica, it is **not**
necessary for each equation to be an explicit equation for a single
variable.  An equation can contain complete expressions on either
side.  It is the compilers job to determine how to use these equations
to solve for the different variables in the problem.

What distinguishes our ``NewtonCooling`` example from the
``FirstOrder`` model is that we can independently adjust the different
parameter values.  Furthermore, these parameter values are tied to
physical, measurable properties of the materials or environmental
conditions.  In other words, this version is slightly more physical
than the simple mathematical relationship used in the ``FirstOrder``
model.

Now, we can't really run the ``NewtonCooling`` model as is because it
lacks values for the five parameters.  In order to create a model that
is ready to be simulated, we need to specify those values, *e.g.*,

.. literalinclude:: /ModelicaByExample/BasicEquations/CoolingExample/NewtonCoolingWithDefaults.mo
   :language: modelica
   :lines: 2-

The only real difference here is that each of the ``parameter``
variables also has a value specified.  One way to think about the
``NewtonCooling`` model is that we could not simulate it because it
had 6 variables (total) and only one equation (see the section on 
:ref:`initialization` for an explanation of why the ``initial equation``
doesn't really count).  However, the ``NewtonCoolingWithDefaults``
model has, conceptually speaking, 6 equations (5 of them coming from
the initialization of the ``parameter`` variables) and 6 unknowns.

If we simulate the ``NewtonCoolingWithDefaults`` model, we get the
following solution for ``T``.

.. plot:: ../plots/BasicEquations_CoolingExample_NewtonCoolingWithDefaults.py
   :include-source: no


Physical Units
^^^^^^^^^^^^^^

As mentioned already in this section, this example is a bit more
physical because it includes individual physical parameters that
correspond to individual properties of our real world system.
However, we are still missing one important dimension, physical types.

As you may have already guessed, the variable ``T`` is a temperature.
This is made clear in the descriptive text associated with the
variable.  Furthermore, it doesn't take a very deep analysis of our
previous model to determine that ``T0`` and ``T_inf`` must also be
temperatures.

But what about the other variables like ``h``?  What do they
represent.  Even more important, are the equations **physically
consistent**?  By physically consistent, we mean that both side of the
equations have the same physical units (*e.g.*, temperature, mass,
etc).

We could convey the physical units of the different variables more
rigorously by actually including them in the variable declarations,
like so:

.. literalinclude:: /ModelicaByExample/BasicEquations/CoolingExample/NewtonCoolingWithUnits.mo
   :language: modelica
   :lines: 2-

.. index:: attributes, unit attribute

Note that each of the variable declarations now includes the text
``(unit="...")`` to associate a physical unit with the variable.  What
this additional text is actually doing is specifying a value for the
``unit`` attribute associated with the variable.  Attributes are
special properties that each variable has.  The set of attributes a
variable can have depends on the type of the variable (this is
discussed in more detail in the section on :ref:`variables`.

At first glance, it may not seem obvious why specifying the unit
attribute (*e.g.*, ``(unit="K")``) is any better than simply adding
``"Temperature"`` to the descriptive string following the variable.
In fact, one might even argue it is worse because "Temperature" is
more descriptive than just a single letter like "K".

However, setting the ``unit`` attribute is actually a more formal
approach for two reasons.  The first reason is that the Modelica
specification defines relationships for all the standard SI unit
attributes (*e.g.*, ``K``, ``kg``, ``m``, etc).  This includes complex
unit types that can be composed of other base units (*e.g.*, ``N``).
The other reasons is that the Modelica specification also defines
rules for how to compute the units of complex mathematical
expressions.  In this way, the Modelica specification defines
everything that is necessary to **unit check** Modelica models for
errors or physical inconsistencies.  This is a big win for model
developers because adding units not only makes the models clearer, it
provides better diagnostics in the case of errors.

Physical Types
^^^^^^^^^^^^^^

But truth be told, there is one drawback of the code for our
``NewtonCoolingWithUnits`` example and that is that we have to repeat
the ``unit`` attribute specification for every variable.  Furthermore,
as mentioned previously, ``K`` isn't nearly as descriptive as
"Temperature".

.. index:: derived types

Fortunately, we have a simple solution to both problems because
Modelica allows us to define *derived types*.  So far, all the
variables we have declared have been of type ``Real``.  The problem
with ``Real`` is that it could be anything (*e.g.*, a voltage, a
current, a temperature).  What we'd like to do is narrow things down a
bit.  This is where derived types come in.  To see how to define
derived types and then use them in declarations, consider the
following example:

.. literalinclude:: /ModelicaByExample/BasicEquations/CoolingExample/NewtonCoolingWithTypes.mo
   :language: modelica
   :lines: 2-

.. index:: min attribute
.. index:: type

You can read the definition ``type Temperature=Real(unit="K",
min=0);`` as "Let us define a new unit, ``Temperature``, that is a
specialization of the built-in type ``Real`` with physical units of
Kelvin (``K``) and a minimum possible value of ``0``."

From this example, we can see that once we define a physical type like
``Temperature``, we can use it to declare multiple variables (*e.g.*,
``T``, ``T_inf`` and ``T0``) without having to specify the ``unit`` or
``min`` attribute for each variable.  Also, we get to use the familiar
name ``Temperature`` instead of the SI unit, ``K``.  You might be
wondering what other attributes are available when creating derived
types.  For further discussion, see the section on
:ref:`built-in-types`.

At this point, you might find the idea of defining ``Temperature``,
``ConvectionCoefficient``, ``SpecificHeat`` and ``Mass`` in every
model extremely tedious.  But don't worry, this won't be necessary as
you will see in a later section where we discuss
:ref:`importing_physical_types`.  For now, just realize that we are
able to define physical types and then associate them with variables.

An Electrical Example
---------------------

Let us return now to an engineering context.  For readers who are more
familiar with electrical systems, here is a simple example of an
electrical circuit.  Consider the following circuit:

.. todo:: 

   Need to add a figure here.

As we can see from this figure, we have four variables to solve for:
:math:`V`, :math:`i_L`, :math:`i_R` and :math:`i_C`.  To solve for
each of the currents :math:`i_L`, :math:`i_R` and :math:`i_C`, we can
use the equations associated an inductor, resistor and capacitor,
respectively:

.. math:: V = i_R R
.. math:: C*\dot{V} = i_C
.. math:: L*\dot{i_L} = (V_b-V)

where :math:`V_b` is the battery voltage.  Since we have only 3
equations but 4 variables, we need one additional equation.  That
additional equation is going to be Kirchoff's current law:

.. math:: i_L = i_R+i_C

Now that we have determined the equations and variables for this
problem, we will create a basic model (including physical types) by
translating the equations directly into Modelica.  But in a later
section on :ref:`electrical-components` we will return to this same
circuit and demonstrate how to create models by dragging, dropping and
connecting models that really look like the circuit components in the
previous figure.

A model composed simply of variables and equations could be written as
follows:

.. literalinclude:: /ModelicaByExample/BasicEquations/RLC/RLC1.mo
   :language: modelica
   :lines: 2-

Let's go through this example bit by bit and reinforce the meaning of
the various statements.  Let's start at the top:

.. literalinclude:: /ModelicaByExample/BasicEquations/RLC/RLC1.mo
   :language: modelica
   :lines: 2-2

Here we see that the name of the model is ``RLC``.  Furthermore, a
description of this model has been included, namely ``"A
resistor-inductor-capacitor circuit model"``.  Next, we introduce a
few physical types that we will need:

.. literalinclude:: /ModelicaByExample/BasicEquations/RLC/RLC1.mo
   :language: modelica
   :lines: 3-7

Each of these lines introduces a physical type that specializes the
built-in ``Real`` type by associating it with a particular physical
unit.  Then, we declare all of the ``parameter`` variables in our
problem:

.. literalinclude:: /ModelicaByExample/BasicEquations/RLC/RLC1.mo
   :language: modelica
   :lines: 8-11

These ``parameter`` variables represent various physical
characteristics (in this case, voltage, inductance, resistance and
capacitance, respectively).  The last variables we need to define are
the ones we wish to solve for, *i.e.*,

.. literalinclude:: /ModelicaByExample/BasicEquations/RLC/RLC1.mo
   :language: modelica
   :lines: 12-15

Now that all the variables have been declared, we add an ``equation``
section to the model that specifies the equations to use when
generating solutions for this model:

.. literalinclude:: /ModelicaByExample/BasicEquations/RLC/RLC1.mo
   :language: modelica
   :lines: 16-20

Finally, we close the model by creating an ``end`` statement that
includes the ``model`` name (*i.e.*, ``RLC`` in this case):

.. literalinclude:: /ModelicaByExample/BasicEquations/RLC/RLC1.mo
   :language: modelica
   :lines: 21-21

.. index:: state-space form

One thing that distinguishes this example from the previous examples
is the fact that it contains more equations.  As with the
``NewtonCooling`` example, we have some equations with expressions on
both the left and right hand sides.  We have some equations that
involve derivatives while others do not.  This further emphasizes the
point that in Modelica it is not necessary to put the system of
equations into the so-called "explicit state-space form" required in
some modeling environments.  We could, of course, rearrange the
equations into a more explicit form, *e.g.*,

.. literalinclude:: /ModelicaByExample/BasicEquations/RLC/RLC2.mo
   :language: modelica
   :lines: 17-21

But the important point is that with Modelica, we do not need to
perform such manipulations.  Instead, we are free to write the
equations in whatever form we chose.  If such manipulations are
necessary in order to solve these equations, it is the tools
responsibility to perform these manipulations, no the model
developer.

This is important because, as we will show in later sections, we
eventually want to get to the point where these equations are
"captured" in individual components models.  In those cases, we won't
know (when we create the component model) exactly what variable each
equation will be used to solve for.  Making such manipulations the
responsibility of the Modelica compiler not only makes the model
development simpler, but it dramatically improves the **reusability**
of the models.

.. todo::

Add some kind of "aside" here or something to indicate that this is an
alternative path through the book

To see this model extended to include more complex behavior, you may
want to skip ahead to our :ref:`switched-rlc` example.


.. _mech-example:

A Mechanical Example
--------------------

If you are more familiar with mechanical systems, this example might
be more enlightening than the one presented in the previous section.
The system we wish to model is the one shown in the following figure:

.. todo::

   Add a figure here of the two inertia system

It is worth pointing out how much easier it is to convey the intention
of a model be presenting a schematic.  Assuming appropriate graphical
representations are used in the schematic, experts can very quickly
understand the composition of the system and develop an intuition
about how it is likely to behave.  While we are currently focusing on
equations and variables, we will eventually work our way up to an
approach (see :ref:`components`) where models will be built in this
schematic form from the beginning.

For now, however, we will focus on how to express the equations
associated with our simple mechanical system.  Each inertia has a
rotational position, :math:`\phi`, and a rotational speed,
:math:`\omega` where :math:`\omega = \dot{\phi}`.  For each inertia,
the balance of angular momentum for the inertia can be expressed as:

.. math:: J \dot{omega} = \sum_i \tau_i

In other words, the sum of the torques, :math:`\tau`, applied to the
inertia should be equal to the product of the moment of inertia,
:math:`J`, and the angular acceleration, :math:`\dot{omega}`.

.. index:: Hooke's law

At this point, all we are missing are the torque values,
:math:`\tau_i`.  From the previous figure, we can see that there are
two springs and two dampers.  For the springs, we can use Hooke's law
to express the torque as a function of angular displacement as
follows:

.. math:: \tau = k \Delta \phi

For each damper, the torque can be expressed as:

.. math:: \tau = d \dot{\Delta \phi}

If we pull together all of these relations, we get the following
system of equations:

.. math:: \omega_1 = \dot{\phi_1}
.. math:: J_1 \dot{omega_1} = k_1 (\phi_2-\phi_1) + d_1 \frac{d
	  (phi_2-phi_1)}{dt}
.. math:: \omega_2 = \dot{\phi_2}
.. math:: J_2 \dot{omega_2} = k_1 (\phi_1-\phi_2) + d_1 \frac{d
	  (phi_1-phi_2)}{dt} - k_2 \phi_2 - d_2 \dot{phi_2}

Let's assume our system has the following initial conditions as well:

.. math:: \phi_1 = 0
.. math:: \omega_1 = 0
.. math:: \phi_2 = 1
.. math:: \omega_2 = 0

These initial conditions essentially mean that the system starts in a
state where neither inertia is actually moving (*i.e.*,
:math:`\omega=0`) but there is a non-zero deflection across both
springs.

Pulling all of these variables and equations together, we can express
this problem in Modelica as follows:

.. literalinclude:: /ModelicaByExample/BasicEquations/RotationalSMD/SecondOrderSystem.mo
   :language: modelica
   :lines: 2-

.. index:: modifications

The only drawback of this model is that all of our initial conditions
have been "hard-coded" into the model.  This means that we will be
unable to specify any alternative set of initial conditions for this
model.  We can overcome this issue by defining ``parameter`` variables
to represent the initial conditions as follows:

.. literalinclude:: /ModelicaByExample/BasicEquations/RotationalSMD/SecondOrderSystemInitParams.mo
   :language: modelica
   :lines: 2-

In this way, the parameter values can be changed changed either in the
simulation environment (where parameters are typically editable by the
user) or, as we will see shortly, via so-called "modifications".

You will see in this latest version of the model that the values for
the newly introduced parameters are the same as the hard-coded values
used earlier.  As a result, the default initial conditions will be
exactly the same as they were before.  But now, we have the freedom to
explore other initial conditions as well.

.. todo:: 

  Mark this as an aside (as in previous todo)

If you would like to see this example further developed, you may wish
to jump to the next set of examples involving rotational systems found
in the section on :ref:`speed-measurement`.

Lotka-Volterra Systems
----------------------

.. todo::

  Figure out how to do citations and provide one for the
  Lotka-Volterra equations.

So far, we've seen thermal, electrical and mechanical examples.  In
effect, these have all been engineering example.  However, Modelica is
not limited strictly to engineering disciplines.  To reinforce this
point, this section will present a common ecological system dynamics
model based on the relationship between predator and prey species.
The equations we will be using are the Lotka-Volterra equations.

Steady State Initialization
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Inheritance
^^^^^^^^^^^

Complex Initialization
^^^^^^^^^^^^^^^^^^^^^^


Initial Conditions
^^^^^^^^^^^^^^^^^^

Review
======

Model Definition
----------------

.. index:: ! model

.. _variables:

Variables
---------

.. _built-in-types:

Built-In Types
^^^^^^^^^^^^^^

.. index:: ! Real
.. index:: ! attributes
.. index:: ! unit attribute
.. index:: ! start attribute
.. index:: ! fixed attribute

.. _variability:

Variability
^^^^^^^^^^^

.. index:: ! parameter

Derived Types
^^^^^^^^^^^^^

.. index:: ! derived types
.. index:: ! type

Equations
---------

.. index:: ! der
.. index:: ! state-space form

.. _initialization:

Initialization
--------------

Make sure problems are well specified.  Note default initial condition
in :ref:`first-order`
vs. :ref:`first-order-init`

.. index:: ! initial equation


.. index:: ! descriptive strings
