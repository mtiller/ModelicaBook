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

.. plot:: ../plots/FO.py
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

.. plot:: ../plots/FOI.py
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

.. plot:: ../plots/FOS.py
   :include-source: no

Complete coverage of the initialization topic can be found in the
:ref:`initialization` section of this chapter.

.. _getting-physical:

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

.. plot:: ../plots/NC1.py
   :include-source: no


.. _physical-units:

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

.. _physical-types:

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
responsibility to perform these manipulations, not the model
developer.

This is important because, as we will show in later sections, we
eventually want to get to the point where these equations are
"captured" in individual components models.  In those cases, we won't
know (when we create the component model) exactly what variable each
equation will be used to solve for.  Making such manipulations the
responsibility of the Modelica compiler not only makes the model
development simpler, but it dramatically improves the **reusability**
of the models.

The following figure shows the dynamic response of the ``RLC1`` model:

.. plot:: ../plots/RLC1.py
   :include-source: no

.. todo::

Add some kind of "aside" here or something to indicate that this is an
alternative path through the book

To see this model extended to include more complex behavior, you may
want to skip ahead to our :ref:`switched-rlc` example.


.. _mech-example:

A Mechanical Example
--------------------

If you are more familiar with mechanical systems, this example might
help reinforce some of the concepts we've covered so far.  The system
we wish to model is the one shown in the following figure:

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

In this way, the parameter values can be changed either in the
simulation environment (where parameters are typically editable by the
user) or, as we will see shortly, via so-called "modifications".

You will see in this latest version of the model that the values for
the newly introduced parameters are the same as the hard-coded values
used earlier.  As a result, the default initial conditions will be
exactly the same as they were before.  But now, we have the freedom to
explore other initial conditions as well.  For example, if we simulate
the ``SecondOrderSystemInitParams`` model as is, we get the following
solution for the angular positions and velocities:

.. plot:: ../plots/SOSIP.py
   :include-source: no

However, if modify the ``phi1_init`` parameter to be *1* at the start
of our simulation, we get this solution instead:

.. plot:: ../plots/SOSIP1.py
   :include-source: no

.. todo:: 

  Mark this as an aside (as in previous todo)

If you would like to see this example further developed, you may wish
to jump to the next set of examples involving rotational systems found
in the section on :ref:`speed-measurement`.

.. _lotka-volterra-systems:

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

.. _classic-lotka-volterra:

Classic Lotka-Volterra
^^^^^^^^^^^^^^^^^^^^^^

The classic Lotka-Volterra model involves two species.  One species is
the "prey" species.  In this section, the population of the prey
species will be represented by :math:`x`.  The other species is the
"predator" species whose population will be represented by :math:`y`.

.. todo::

  Need a citation for law of mass action.

There are three important effects in a Lotka-Volterra system.  The
first is reproduction of the "prey" species.  It is assumed that
reproduction is proportional to the population.  If you are familiar
with chemical reactions, this is conceptually the same as the "Law of
Mass Action".  If you aren't familiar with the "Law of Mass Action",
just consider that the more potential mates are present in the
environment, the more likely reproduction is to occur.  We can
represent this mathematically as:

.. math:: \dot{x}_{r} = \alpha x

where :math:`x` is the prey population, :math:`\dot{x}_r` is the
change in prey population *due to reproduction* and :math:`\alpha` is
the proportionality constant capturing the likelihood of successful
reproduction.

The next effect to consider is starvation of the predator species.  If
there aren't enough "prey" around to eat, the predator species will
die off.  When modeling starvation, it is important to consider the
effect of competition.  We again have a proportionality relationship,
but this time it works in reverse because, unlike with prey
reproduction, the more predators around the more likely starvation
is.  This is expressed mathematically in much the same way as
reproduction:

.. math:: \dot{y}_{s} = -\gamma y

where :math:`y` is the predator population, :math:`\dot{y}_s` is the
change in predator population *due to starvation* and :math:`\gamma`
is the proportionality constant capturing the likelihood of
starvation.

Finally, the last effect we need to consider is "predation", *i.e.*,
the consumption of the prey species by the predator species.  Without
predators, the prey species would (at least mathematically) grow
exponentially.  So predation is the effect that keeps the prey species
population in check.  Similarly, without any prey, the predator
species would simply die off.  So predation is what balances out this
effect and keeps the predator population from going to zero.  Again,
we have a proportionality relationship.  But this time, it is actually
a bilinear relationship that is, again, conceptually the "Law of Mass
Action" which is simply capturing mathematically the fact that the
chance a predation will occur is proportional to both the population
of the prey and the predators.  As a result, this mathematical
relationship has a slightly different structure than the other two:

.. math:: \dot{x}_p = -\beta x y
.. math:: \dot{y}_p = \delta x y

where :math:`\dot{x}_p` is the decline in the prey population *due to
predation*, :math:`\dot{y}_p` is the increase in the predator
population *due to predation*, :math:`\beta` is the proportionality constant
representing the likelihood of prey consumption and :math:`\delta` is
the proportionality constant representing the likelihood that the
predator will have sufficient extra nutrition to support reproduction.

Taking the various effects into account, the overall change in each
population can be represented by the following two equations:

.. math:: \dot{x} = \dot{x}_r + \dot{x}_p
.. math:: \dot{y} = \dot{y}_p + \dot{x}_s

Using the previous relationships, we can expand each of the right hand
side terms in these two equations into:

.. math:: \dot{x} = x (\alpha - \beta y)
.. math:: \dot{y} = y (\delta x - \gamma)

Using what we've learned in this chapter so far, translating these
equations into Modelica should be pretty straightforward:

.. literalinclude:: /ModelicaByExample/BasicEquations/LotkaVolterra/ClassicModel.mo
   :language: modelica
   :lines: 2-

.. index:: start attribute

At this point, there is only one thing we haven't discussed yet and
that is the presence of the ``start`` attribute on ``x`` and ``y``.
As we saw in the ``NewtonCoolingWithUnits`` example in the previous
section :ref:`getting-physical`, variables have various attributes
that we can specify (for a detailed discussion of available
attributes, see the upcoming section on :ref:`builtin-types`).  We
previously discussed the ``unit`` attribute but this is the first time
we are seeing the ``start`` attribute.

The observant reader may have noticed the presence of the ``x0`` and
``y0`` parameter variables and the fact that they represent the
initial populations.  Based on previous examples, one might have
expected these initial conditions to be captured in the model as
follows:

.. literalinclude:: /ModelicaByExample/BasicEquations/LotkaVolterra/ClassicModelInitialEquations.mo
   :language: modelica
   :lines: 2-

However, for the ``ClassicModel`` example we took a small shortcut.
As will be discussed shortly in the section on :ref:`initialization`,
we can specify initial conditions by specifying the value of the
``start`` attribute directly on the variable.

It is worth noting that this approach has both advantages and
disadvantages.  The advantage is one of flexibility.  The ``start``
attribute is actually more of a hint than a binding relationship.  If
the Modelica compiler identifies a particular variable as a state
(*i.e.*, a variable that requires an initial condition) **and** there
are insufficient initial conditions already specified in the model
then it can substitute the ``start`` attribute as an initial
condition.  In other words, you can think of the ``start`` attribute
as a "fallback initial condition" if an initial condition is needed.

There are a couple of disadvantages to the ``start`` attribute that
you need to watch you for.  First, it is only a hint and tools may
completely ignore it.  Whether it will be ignored is also hard to
predict.  Finally, the ``start`` attribute is also "overloaded".  This
means that it is actually used for two different things.  If the
variable in question is not a state but is instead an "iteration
variable" (*i.e.*, a variable whose solution depends on a non-linear
system of equations), then the ``start`` attribute may be used by a
Modelica compiler as an initial guess (*i.e.*, the value used for the
variable during the initial iteration of the non-linear solver).

Whether to specify a ``start`` attribute or not depends on how
strictly you want a given initial condition to be enforced.  That is
something that takes experience working with the language and is
beyond the scope of this chapter.  However, it is worth at least
pointing out that there are different options along with a basic
explanation of the trade-offs.

Using either initialization method, the results for these models will
be the same.  The typical behavior for the Lotka-Volterra system can
be seen in this plot:

.. plot:: ../plots/BasicEquations_LotkaVolterra_ClassicModel.py
   :include-source: no

Note the cyclical behavior of each population.  Initially, there are
more predators than can be supported by the existing food supply.
Those predators that are present consume whatever prey the can find.
Nevertheless, some starvation occurs and the predator population
declines.  The rate at which predators consume the prey species is so
high during this period that the rate at which the prey species
reproduces is not sufficient to make up for those lost to predation so
the prey population declines as well.

At some point, the predator population gets so low that the rate of
reproduction in the prey species is larger than the rate of prey
consumption by the predators and the prey species begins to rebound.
Because the predator species population takes longer to rebound, the
prey species experiences growth that is, for the moment, virtually
unchecked by predation.  Eventually, the predator population begins to
rebound due to the abundance of prey until the system returns to the
original predator and prey populations **and the entire cycle then
repeats itself** *ad infinitum*.

The fact that the system returns again and again to the same initial
conditions (ignoring numerical error, of course) is one of the most
interesting things about the system.  This is even more remarkable
given the fact that the LotkaVolterra system of equations is actually
non-linear.

Steady State Initialization
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Let's imagine that these extreme swings in species population had some
undesirable ecological consequences.  In such a case, it would be
useful to understand what might reduce or even eliminate these
fluctuations.  A simple approach would be to keep the populations in a
state of equilibrium.  But how can we use these models to help use
determine such a "quiescient" state?

The answer lies in the initial conditions.  Instead of specifying an
initial population for both the predator and prey species, we might
instead chose to initialize the system with some other equations that
somehow capture the fact that the system is in equilibrium.
Fortunately, Modelica's approach to initialization is rich enough to
allow us to specify this (and many other) useful initial conditions.

To ensure that our system starts in equilibrium, we simply need to
define what equilibrium is.  Mathematically speaking, the system is in
equilibrium if the following two conditions are met:

.. math:: \dot{x} = 0
.. math:: \dot{y} = 0

To capture this in our Modelica model, all we need to do is use these
equations in our ``initial equation`` section, like this:

.. literalinclude:: /ModelicaByExample/BasicEquations/LotkaVolterra/QuiescientModel.mo
   :language: modelica
   :emphasize-lines: 9-11
   :lines: 2-

The main difference between this and our previous model is the
presence of the highlighted initial equations.  Looking at this model,
you might wonder exactly what those initial equations mean.  After
all, what we need to solve for are ``x`` and ``y``.  But those
variables don't even appear in our initial equations.  So how are they
solved for?

The answer lies in understanding that the functions :math:`x(t)` and
:math:`y(t)` are solved for by integrating the differential equations
starting from some initial equations.  During the simulation, we see
that :math:`x` and :math:`\dot{x} are "coupled" by the following
equations:

.. math:: x(t) = \int_{t_0}^{t_f} \dot{x} dx + x(t_0)

(and, of course, a similar relationship exists between :math:`y` and
:math:`\dot{y}`)

**However**, during initialization of the system (*i.e.*, solving for
the initial conditions) this relationship doesn't hold.  So there is
no "coupling" between :math:`x` and :math:`\dot{x}` in that case (nor
for :math:`y`: and :math:`\dot{y}`).  The net result is that for the
initialization problem we can think of :math:`x`, :math:`y`,
:math:`\dot{x}` and :math:`\dot{y}` as four independent variables.

Said another way, while simulating we solve for :math:`x` by
integrating :math:`\dot{x}`.  So that integral equation is the
equation used to solve for :math:`x`.  But during initialization, we
cannot use that equation so we need an additional equation (for each
integration that perform during initialization).

In any case, the bottom line is that during initialization we require
four different equations to arrive at a unique solution.  In the case
of our ``QuiescientModel``, those four equations are:

.. math:: \dot{x} = 0
.. math:: \dot{x} = x (\alpha - \beta y)
.. math:: \dot{y} = 0
.. math:: \dot{y} = y (\delta x - \gamma)

It is very important to understand that these equations **do not
contradict each other**.  Especially if you come from a programming
background you might see look at the first two equations and think
"Well what is :math:`\dot{x}`?  Is it zero or is it :math:`x (\alpha -
\beta y)`?"  The answer is **both**.  There is no reason that both
equations cannot be true!

The essential thing to remember here is that these are **equations not
assignment statements**.  The following system of equations is
mathematically identical and demonstrates more clearly how :math:`x`
and :math:`y` could be solved:

.. math:: \dot{x} = 0
.. math:: \dot{y} = 0
.. math:: x (\alpha - \beta y) = \dot{x}
.. math:: y (\delta x - \gamma) = \dot{y}

In this form, it is a bit easier to recognize how we could arrive at
values of :math:`x` and :math:`y`.  The first thing to note is that we
cannot solve explicitly for :math:`x` and :math:`y`.  In other words,
we cannot rearrange these equations into the form :math:`x=...`
without have :math:`x` also appear on the right hand side.  So we have
to deal with the fact that this is a simultaneous system of equations
involving both :math:`x` and :math:`y`.  But the situation is further
complicated by the fact that this system is non-linear (which is
precisely why we cannot use linear algebra to arrive at a set of
explicit equations).  In fact, if we study these equations carefully
we can spot the fact that there exist two potential solutions.  One
solution is trivial (:math:`x=0;y=0`) and the other is not.

So what happens if we try to simulate our ``QuiescientModel``?  The
answer is pretty obvious in the plot below:

.. plot:: ../plots/BasicEquations_LotkaVolterra_QuiescentModel.py
   :include-source: no

We ended up with the trivial solution where the prey and predator
populations are zero.  In this case, we have no reproduction,
predation or starvation because all these effects are proportional to
the populations (*i.e.*, zero) so nothing changes.  But this isn't a
very interesting solution.

There are two solutions to this system of equations because it is
non-linear.  How can we steer the non-linear solver away from this
trivial solution?  If you were paying attention during the discussion
of the :ref:`classic-lotka-volterra` model, then you've already been
given a hint about the answer.

Recall that the ``start`` attribute is overloaded.  During our
discussion of the :ref:`classic-lotka-volterra` model, it was pointed
out that one of the purposes of the ``start`` attribute was to provide
an initial guess if the variable with the ``start`` attribute was
chosen as an iteration variable.  Well, our ``QuiesceintModel``
happens to be a case where ``x`` and ``y`` are, in fact, iteration
variables because they must be solved using a system of non-linear
equations.  This means that if we want to avoid the trivial solution,
we need to specify values for the ``start`` attribute on both ``x``
and ``y`` that are "far away" from the trivial solution we are trying
to avoid.  For example:

.. literalinclude:: /ModelicaByExample/BasicEquations/LotkaVolterra/QuiescientModelUsingStart.mo
   :language: modelica
   :emphasize-lines: 7-8
   :lines: 2-

This model leads us to a set of initial conditions that is more inline
with what we were originally looking for (*i.e.*, a non-trivial solution):

.. plot:: ../plots/BasicEquations_LotkaVolterra_QuiescentModel.py
   :include-source: no


It is worth pointing out (as we will do shortly in the section on
:ref:`builtin-types`), that the default value of the ``start``
attribute is zero.  This is why when we simulated our original
``QuiescientModel`` we happened to land exactly on the trivial
solution...because it was our initial guess and it happened to be an
exact solution so no other solution or iterating was required.

.. _avoiding-repetition:

Avoiding Repetition
^^^^^^^^^^^^^^^^^^^

We've already seen several different models (``ClassicModel``,
``QuiescientModel`` and ``QuiescientModelUsingStart``) based on the
Lotka-Volterra equations.  Have you noticed something they all have in
common?  If you look closely, you will see that they have almost
**everything** in common and that there are actually hardly any
**differences** between them!

In software engineering, there is a saying that "Redundancy is the
root of all evil".  Well the situation is no different here (in no
small part because Modelica code really is software).  The code we
have written so far would be very annoying to maintain.  This is
because any bugs we found would have to be fixed in each model.
Furthermore, any improvements we made would also have to be applied to
each model.  So far, we are only dealing with a relatively small
number of models.  But this kind of "copy and paste" approach to model
development will result in a significant proliferation of models with
only slight differences between them.

.. index:: composition
.. index:: inheritance

So what can be done about this?  In object-oriented programming
languages there are basically two mechanisms that exist to reduce the
amount of redundant code.  They are *composition* (which we will address
in the future chapter on :ref:`_components`) and *inheritance* which
we will introduce here briefly.

If we look closely at the ``QuiescientModelUsingStart`` example, we
see that there are almost no differences between it and our original
``ClassicModel`` version.  In fact, the only real differences are
shown here:

.. literalinclude:: /ModelicaByExample/BasicEquations/LotkaVolterra/ClassicModel.mo
   :language: modelica
   :lines: 2-

.. literalinclude:: /ModelicaByExample/BasicEquations/LotkaVolterra/QuiescientModelUsingStart.mo
   :language: modelica
   :emphasize-lines: 9-11
   :lines: 2-

.. index:: extends

In other words, the only real difference is the addition of the
``initial equation`` section (the original ``ClassicModel`` already
contained non-zero ``start`` values for our two variables, ``x`` and
``y``).  Ideally, we could avoid having any redundant code by
simply defining a model in terms of the differences between it and
another model.  As it turns out, this is exactly what the ``extends``
keyword allows us to do.  Consider the following alternative to the
``QuiescientModelUsingStart`` model:

.. literalinclude:: /ModelicaByExample/BasicEquations/LotkaVolterra/QuiescientModelWithInheritance.mo
   :language: modelica
   :emphasize-lines: 9-11
   :lines: 2-

Note the presence of the ``extends`` keyword.  Conceptually, this
"extends clause" simply asks the compiler to insert the contents of
another model (``ClassicModel`` in this case) into the model being
defined.  In this way, we use everything (or "inherit") from
``ClassicModel`` without having to repeat it's contents.  As a result,
the ``QuiescientModelWithInheritance`` is the same as the
``ClassicModel`` with a set of initial equations inserted.

.. index:: modifications

But what about a case where we don't want **exactly** what is in the
model we are inheriting from?  For example, what if we wanted to
change the values of the ``gamma`` and ``delta`` parameters?

Modelica handles this by allow us to include a set of "modifications"
when we use ``extends``.  These modifications follow the name of the
model being inherited from as shown below:

.. literalinclude:: /ModelicaByExample/BasicEquations/LotkaVolterra/QuiescientModelWithModifications.mo
   :language: modelica
   :emphasize-lines: 3
   :lines: 2-

Also note that we could have inherited from ``ClassicModel`` but then
we would have had to repeat the initial equations in order to have
quiescient initial conditions.  But by instead inheriting from
``QuiescientModelWithModifications``, we reuse the content from
**two** different models and avoid repeating ourselves even once.


Review
======

The first part of this chapter introduced languages features through
examples.  This part will review the various features and concepts and
provide a more complete discussion of each topic.

Model Definition
----------------

Syntax of a Model Definition
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. index:: ! model

As we saw throughout this chapter, a model definition starts with the
``model`` keyword and is followed by a model name and model
description.  The model name must start with a letter and can be
followed by any collection of letters, numbers or underscores
(``_``).

.. index:: camel case

.. note::

Although not strictly required by the language.  It is a convention
that model names start with an *upper case* letter.  Most model
developers use the so-called "camel case" convention where the first
letter of each word in the model name is upper case.

The model definition can contain variable and equations (to be
discussed shortly).  The end of the model is indicated by the presence
of the ``end`` keyword followed by a repetition of the model name.
Any text appearing after the sequence ``//`` or between the delimeters
``/*`` and ``*/`` is considered a comment.

In summary, a model definition has the following general form:

.. source::
   :language: modelica

model SomeModelName "An optional description"
  // By convention, variables are listed at the start
equation
  /* And equations are listed at the end */
end SomeModelName;

Inheritance
^^^^^^^^^^^

.. index:: ! inheritance
.. index:: ! extends

As we in the section on :ref:`avoiding-repetition`, we can reuse code
from other models by adding and ``extends`` clause to the model.  It
is worth noting that a model definition can include multiple
``extends`` clauses.  Each ``extends`` clause must include the name of
the model being extended from and can be optionally followed by
modifications that are applied to the contents of the model being
extended from.  In the case of a model definition that inherits from
other model definitions, you can think of the general syntax as
looking something like this:

.. source::
   :language: modelica

model SpecializedModelName "An optional description"
  extends Model1; // No modifications
  extends Model2(n=5); // Including modification
  // By convention, variables are listed at the start
equation
  /* And equations are listed at the end */
end SpecializedModelName;

By convention, ``extends`` clauses are normally listed at the very
top of the model definition, before any variables.

In later chapters, we will show how this same syntax can be used to
define other entities besides models.  But for now, we will focus
primarily on models

.. _variables:

Variables
---------

As we saw in the previous section, a model definition typically
contains variable declarations.  The basic syntax for a variable
declaration is simply the "type" of the variable (which will be
discussed shortly in the section on :ref:`built-in-types`) followed by
the name of the variable, *e.g.*, ``Real x;``.  Variables sharing the
same type can be grouped together using the following syntax: ``Real
x, y;``

.. _variability:

Variability
^^^^^^^^^^^

.. index:: ! parameter

By default, variable declared inside a model are assumed to be
continuous variables.  That means that their value can change at any
time (or be constantly changing).  However, as first saw in the
section :ref:`getting-physical`, it is also possible to add the
``parameter`` qualifier in front of a variable declaration and to
indicate that the variable is known *a priori*.  You can think of a
parameter as "input data" to the model that is constant with respect
to time.

.. index:: ! constant

Closely related to the ``parameter`` qualifier is the ``constant``
qualifier.  When placed in front of a variable declaration, the
``constant`` qualifier indicates also implies that the value of the
variable is known *a priori* and is constant with respect to time.
The distinction between the two lies in the fact that a ``parameter``
value can be changed from one simulation to the next whereas the value
of a ``constant`` cannot be changed once the model is compiled.  The
use of ``constant`` by a model developer ensures that end users are
not given the option to make changes to the ``constant``.

.. index:: discrete

Another qualifier that can be placed in front of a variable
declaration is the ``discrete`` qualifier.  We have not yet shown any
example where the ``discrete`` qualifier would be relevant.  However,
it is included now for completeness since it is the last remaining
variability qualifier.

.. _built-in-types:

Built-In Types
^^^^^^^^^^^^^^

.. index:: ! Real

Many of the examples so far referenced the ``Real`` type when
declaring variables.  As the name suggests, ``Real`` is used to
represented real values variables.  However, ``Real`` is just one of
the four built-in types in Modelica.

.. index:: ! Integer
.. index:: ! Boolean
.. index:: ! String

Another of the built-in types is the ``Integer`` type.  This type is
used to represent integer values and is often used in conjunction with
array types which will be covered in future section titled
:ref:`vectors-and-arrays`.  The remaining built-in types are
``Boolean`` (used to represent values that can be either ``true`` or
``false``) and ``String`` (used for representing character strings).

Each of the built-in types restricts the possible values that a
variable can have.  Obviously, an ``Integer`` variable cannot have the
value ``2.5``, a ``Boolean`` or ``String`` cannot be ``7`` and a
``Real`` can't be ``"Hello"``.
.. _derived-types:

Derived Types
^^^^^^^^^^^^^

.. index:: ! derived types

As we saw in the previous examples that introduced
:ref:`physical-types`, it is possible to "specialize" the built-in
types.  This feature is used mainly to modify the values associated
with :ref:`attributes` like ``unit``.  The general syntax for creating
derived types is:

.. index:: ! type

.. source::

type NewTypeName = BaseTypeName(/* attributes to be modified */);

Frequently, the ``BaseTypeName`` will be one of the built-in types
(*e.g.*, ``Real``).  But it can also be another derived type.  This
means that multiple levels of specialization can be supported, *e.g.*,

.. source::

type Temperature = Real(unit="K"); // Could be a temperature difference
type AbsoluteTemperature = Temperature(min=0); // Must be positive

.. _enumerations:

Enumerations
^^^^^^^^^^^^

.. index:: ! enumeration

.. todo:: We need an example that uses enumerations.  Explain
	  enumerations here (once we have an example)

There are two built-in enumeration types.  The first of these is
``AssertionLevel`` and it is defined as follows:

.. source::

  type AssertionLevel = enumeration(warning, error);

.. todo:: Need to add ``assert`` to the ``Lotka-Volterra`` examples somewhere!

.. index:: ! assert
.. index:: ! AssertionLevel
.. index:: ! assertion levels

The ``AssertionLevel`` attribute is used in conjunction with the
``assert`` function which was presented in our discussion of
:ref:`lotka-volterra-systems`.  In our previous discussion, only two
arguments were passed to assert.  The first was a conditional
expression that we wish to assert should always be true.  The second
was a string that represents the error message to be used should the
assertion be violated (*i.e.*, if the conditional expression becomes
false).  However, there is a *third* **optional** argument to the
``assert`` function of type ``AssertionLevel``.  If no value for the
third argument is provided, the default value is
``AssertionLevel.error``.

During simulation, the simulation environment will generally attempt,
by various means (*e.g.*, tightening tolerances, taking smaller time
steps), to find a solution trajectory that does not violate the
assertion.  However, if it cannot find a trajectory that avoids the
assertion, the value of the third argument to ``assert`` determines
how the simulation environment should respond to the assertion
violation.  If the third argument is ``AssertionLevel.error``, then
the simulation will terminate if it cannot avoid the assertion
violation.  On the other hand, if the value of the third argument is
``AssertionLevel.warning``, then the simulation will simply generate a
diagnostic error message (*i.e.*, the second argument) and
**continue** the simulation.

The other built-in enumeration is ``StateSelect`` and it is defined as
follows:

.. source::

  type StateSelect = enumeration(never, avoid, default, prefer, always);

.. todo:: Add a reference to whatever future section will discuss
	  state selection.

.. _attributes:

Attributes
^^^^^^^^^^

.. index:: ! attributes

So far in this chapter we have mentioned attributes (*e.g.*, ``unit``)
but we haven't discussed them in detail. For example, *which*
attributes are present on a given variable?  This depends on the
built-in type that it is derived from.  The following table introduces
all the possible attributes indicating their types (*i.e.*, what type
of value can be given for that attribute), which types they can be
associated with and finally a brief description of the attribute:

.. index:: ! quantity attribute
.. index:: start attribute
.. index:: ! fixed attribute
.. index:: ! min attribute
.. index:: ! max attribute
.. index:: ! unit attribute
.. index:: ! displayUnit attribute
.. index:: ! nominal attribute
.. index:: ! stateSelect attribute

.. todo:: Get descriptions from the specification

| Attribute name | Type | Supporting Types | Default | Description |
| ``quantity`` | ``String`` | RIBS | ``""`` | |
| ``start`` | T | RIBS | | |
| ``fixed`` | ``Boolean`` | RIB | | |
| ``min`` | T | RI | | |
| ``max`` | T | RI | | |
| ``unit`` | ``String`` | R | | |
| ``displayUnit`` | ``String`` | R | | |
| ``nominal`` | ``Real`` | R | | |
| ``stateSelect`` | ``StateSelect`` | R | | |

It is worth noting that :ref:`derived-types` retain the attributes of
the built-in type that they are ultimately derived from.

Modifications
^^^^^^^^^^^^^

.. index:: ! modifications
.. index:: modification, extends
.. index:: modification, attribute
.. index:: modification, components

.. index:: attribute modification

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

.. index:: ! start attribute
.. index:: ! initial equation
.. index:: ! descriptive strings
