.. _lotka-volterra-systems:

Lotka-Volterra Systems
----------------------

So far, we've seen thermal, electrical and mechanical examples.  In
effect, these have all been engineering examples.  However, Modelica is
not limited strictly to engineering disciplines.  To reinforce this
point, this section will present a common ecological system dynamics
model based on the relationship between predator and prey species.
The equations we will be using are the [Lotka]_-[Volterra]_ equations.

.. _classic-lotka-volterra:

Classic Lotka-Volterra
^^^^^^^^^^^^^^^^^^^^^^

The `classic Lotka-Volterra model
<http://en.wikipedia.org/wiki/Lotka-Volterra_equation>`_
involves two species.  One species is the "prey" species.  In this
section, the population of the prey species will be represented by
:math:`x`.  The other species is the "predator" species whose
population will be represented by :math:`y`.

There are three important effects in a Lotka-Volterra system.  The
first is reproduction of the "prey" species.  It is assumed that
reproduction is proportional to the population.  If you are familiar
with chemical reactions, this is conceptually the same as the `Law of
Mass Action <http://en.wikipedia.org/wiki/Law_of_mass_action>`_
[Guldberg]_.  If you aren't familiar with the Law of Mass Action, just
consider that the more potential mates are present in the environment,
the more likely reproduction is to occur.  We can represent this
mathematically as:

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
a bilinear relationship that is, again, conceptually similar to the
Law of Mass Action.  This relationship is simply capturing,
mathematically, the fact that the chance that a predator will find and
consume some prey is proportional to both the population of the prey
and the predators.  Since this particular effect requires both species
to be involved, this mathematical relationship has a slightly
different structure than reproduction and starvation, *i.e.,*

.. math::

   \dot{x}_p &= -\beta x y \\
   \dot{y}_p &= \delta x y

where :math:`\dot{x}_p` is the decline in the prey population *due to
predation*, :math:`\dot{y}_p` is the increase in the predator
population *due to predation*, :math:`\beta` is the proportionality constant
representing the likelihood of prey consumption and :math:`\delta` is
the proportionality constant representing the likelihood that the
predator will have sufficient extra nutrition to support reproduction.

Taking the various effects into account, the overall change in each
population can be represented by the following two equations:

.. math::

   \dot{x} &= \dot{x}_r + \dot{x}_p \\
   \dot{y} &= \dot{y}_p + \dot{y}_s

Using the previous relationships, we can expand each of the right hand
side terms in these two equations into:

.. math::

   \dot{x} &= x (\alpha - \beta y) \\
   \dot{y} &= y (\delta x - \gamma)

Using what we've learned in this chapter so far, translating these
equations into Modelica should be pretty straightforward:

.. literalinclude:: /ModelicaByExample/BasicEquations/LotkaVolterra/ClassicModel.mo
   :language: modelica
   :lines: 2-

.. index:: start attribute

At this point, there is only one thing we haven't discussed yet and
that is the presence of the ``start`` attribute on ``x`` and ``y``.
As we saw in the ``NewtonCoolingWithUnits`` example in the previous
section titled :ref:`getting-physical`, variables have various
attributes that we can specify (for a detailed discussion of available
attributes, see the upcoming section on :ref:`builtin-types`).  We
previously discussed the ``unit`` attribute, but this is the first time
we are seeing the ``start`` attribute.

The observant reader may have noticed the presence of the ``x0`` and
``y0`` parameter variables and the fact that they represent the
initial populations.  Based on previous examples, one might have
expected these initial conditions to be captured in the model as
follows:

.. literalinclude:: /ModelicaByExample/BasicEquations/LotkaVolterra/ClassicModelInitialEquations.mo
   :language: modelica
   :emphasize-lines: 10-12
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
are insufficient initial conditions already explicitly specified in
the model via ``initial equation`` sections then it can substitute the
``start`` attribute as an initial condition for the variable it is
associated with.  In other words, you can think of the ``start``
attribute as a "fallback initial condition" if an initial condition is
needed.

There are a couple of disadvantages to the ``start`` attribute that
you need to watch out for.  First, it is only a hint and tools may
completely ignore it.  Next, whether it will be ignored is also hard
to predict since different tools may make different choices about
which variables to treat as states.

One way to avoid both of these disadvantages is to use the ``fixed``
attribute (also discussed in the section on :ref:`builtin-types`).
The ``fixed`` attribute can be used to tell the compiler that the
start attribute **must** be used as an initial condition.  In other
words, an ``initial equation`` like this:

.. code-block:: modelica

     Real x;
   initial equation
     x = 5;

is equivalent to the following declaration utilizing the ``start`` and
``fixed`` attributes:

.. code-block:: modelica

     Real x(start=5, fixed=true);

Finally, one additional complication is that the ``start`` attribute
is also "overloaded".  This means that it is actually used for two
different things.  If the variable in question is not a state, but is
instead an "iteration variable" (*i.e.*, a variable whose solution
depends on a non-linear system of equations), then the ``start``
attribute may be used by a Modelica compiler as an initial guess
(*i.e.*, the value used for the variable during the initial iteration
of the non-linear solver).

Whether to specify a ``start`` attribute or not depends on how
strictly you want a given initial condition to be enforced.  Knowing
that is something that takes experience working with the language and
is beyond the scope of this chapter.  However, it is worth at least
pointing out that there are different options along with a basic
explanation of the trade-offs.

Using either initialization method, the results for these models will
be the same.  The typical behavior for the Lotka-Volterra system can
be seen in this plot:

.. plot:: ../plots/LVCM.py
   :class: interactive

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
given the fact that the Lotka-Volterra system of equations is actually
non-linear.

.. _steady-state:

Steady State Initialization
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Let's imagine that these extreme swings in species population had some
undesirable ecological consequences.  In such a case, it would be
useful to understand what might reduce or even eliminate these
fluctuations.  A simple approach would be to keep the populations in a
state of equilibrium.  But how can we use these models to help use
determine such a "quiescent" state?

The answer lies in the initial conditions.  Instead of specifying an
initial population for both the predator and prey species, we might
instead chose to initialize the system with some other equations that
somehow capture the fact that the system is in equilibrium (you may
remember this trick from the ``FirstOrderSteady`` model :ref:`discussed
previously <ex_SimpleExample_FirstOrderSteady>`).  Fortunately,
Modelica's approach to initialization is rich enough to allow us to
specify this (and many other) useful types of initial conditions.

To ensure that our system starts in equilibrium, we simply need to
define what equilibrium is.  Mathematically speaking, the system is in
equilibrium if the following two conditions are met:

.. math::

   \dot{x} &= 0 \\
   \dot{y} &= 0

To capture this in our Modelica model, all we need to do is use these
equations in our ``initial equation`` section, like this:

.. literalinclude:: /ModelicaByExample/BasicEquations/LotkaVolterra/QuiescentModel.mo
   :language: modelica
   :emphasize-lines: 8-10
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
that :math:`x` and :math:`\dot{x}` are "coupled" by the following
equations:

.. math:: x(t) = \int_{t_0}^{t_f} \dot{x}\  \mathrm{d}x + x(t_0)

(and, of course, a similar relationship exists between :math:`y` and
:math:`\dot{y}`)

**However**, during initialization of the system (*i.e.*, when solving
for the initial conditions) this relationship doesn't hold.  So there
is no "coupling" between :math:`x` and :math:`\dot{x}` in that case
(nor for :math:`y`: and :math:`\dot{y}`).  In other words, knowing
:math:`x` or :math:`y` doesn't give you any clue as to how to compute
:math:`\dot{x}` or :math:`\dot{y}`.  The net result is that for the
initialization problem we can think of :math:`x`, :math:`y`,
:math:`\dot{x}` and :math:`\dot{y}` as four independent variables.

Said another way, while simulating, we solve for :math:`x` by
integrating :math:`\dot{x}`.  So that integral equation is the
equation used to solve for :math:`x`.  But during initialization, we
cannot use that equation so we need an additional equation (for each
integration that we would otherwise perform during simulation).

In any case, the bottom line is that during initialization we require
four different equations to arrive at a unique solution.  In the case
of our ``QuiescentModel``, those four equations are:

.. math::

   \dot{x} &= 0 \\
   \dot{x} &= x \ (\alpha - \beta y) \\
   \dot{y} &= 0 \\
   \dot{y} &= y \ (\delta  x - \gamma)

It is very important to understand that these equations **do not
contradict each other**.  Especially if you come from a programming
background you might look at the first two equations and think "Well
what is :math:`\dot{x}`?  Is it zero or is it :math:`x (\alpha - \beta
y)`?"  The answer is **both**.  There is no reason that both equations
cannot be true!

The essential thing to remember here is that these are **equations not
assignment statements**.  The following system of equations is
mathematically identical and demonstrates more clearly how :math:`x`
and :math:`y` could be solved:

.. math::

   \dot{x} &= 0 \\
   \dot{y} &= 0 \\
   x (\alpha - \beta y) &= \dot{x} \\
   y (\delta x - \gamma) &= \dot{y}

In this form, it is a bit easier to recognize how we could arrive at
values of :math:`x` and :math:`y`.  The first thing to note is that we
cannot solve explicitly for :math:`x` and :math:`y`.  In other words,
we cannot rearrange these equations into the form :math:`x=...`
without having :math:`x` also appear on the right hand side.  So we
have to deal with the fact that **this is a simultaneous system of
equations** involving both :math:`x` and :math:`y`.

But the situation is further complicated by the fact that this system
is non-linear (which is precisely why we cannot use linear algebra to
arrive at a set of explicit equations).  In fact, if we study these
equations carefully we can spot the fact that there exist two
potential solutions.  One solution is trivial (:math:`x=0;y=0`) and
the other is not.

So what happens if we try to simulate our ``QuiescentModel``?  The
answer is pretty obvious in the plot below:

.. plot:: ../plots/LVQM.py

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
chosen as an iteration variable.  Well, our ``QuiescentModel``
happens to be a case where ``x`` and ``y`` are, in fact, iteration
variables because they must be solved using a system of non-linear
equations.  This means that if we want to avoid the trivial solution,
we need to specify values for the ``start`` attribute on both ``x``
and ``y`` that are "far away" from the trivial solution we are trying
to avoid (or at least closer to the non-trivial solution we seek).
For example:

.. literalinclude:: /ModelicaByExample/BasicEquations/LotkaVolterra/QuiescentModelUsingStart.mo
   :language: modelica
   :emphasize-lines: 6-7
   :lines: 2-

This model leads us to a set of initial conditions that is more inline
with what we were originally looking for (*i.e.*, one with non-zero
populations for both the predator and prey species).

.. plot:: ../plots/LVQMUS.py
   :class: interactive

It is worth pointing out (as we will do shortly in the section on
:ref:`builtin-types`), that **the default value of the ``start``
attribute is zero**.  This is why when we simulated our original
``QuiescentModel`` we happened to land exactly on the trivial
solution...because it was our initial guess and it happened to be an
exact solution so no other solution or iterating was required.

.. _avoiding-repetition:

Avoiding Repetition
^^^^^^^^^^^^^^^^^^^

We've already seen several different models (``ClassicModel``,
``QuiescentModel`` and ``QuiescentModelUsingStart``) based on the
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
in the future chapter on :ref:`components`) and *inheritance* which
we will briefly introduce here.

If we look closely at the ``QuiescentModelUsingStart`` example, we
see that there are almost no differences between it and our original
``ClassicModel`` version.  In fact, the only real differences are
shown here:

.. literalinclude:: /ModelicaByExample/BasicEquations/LotkaVolterra/ClassicModel.mo
   :language: modelica
   :lines: 2-

.. literalinclude:: /ModelicaByExample/BasicEquations/LotkaVolterra/QuiescentModelUsingStart.mo
   :language: modelica
   :emphasize-lines: 8-10
   :lines: 2-

.. index:: extends

In other words, the only real difference is the addition of the
``initial equation`` section (the original ``ClassicModel`` already
contained non-zero ``start`` values for our two variables, ``x`` and
``y``).  Ideally, we could avoid having any redundant code by
simply defining a model in terms of the differences between it and
another model.  As it turns out, this is exactly what the ``extends``
keyword allows us to do.  Consider the following alternative to the
``QuiescentModelUsingStart`` model:

.. literalinclude:: /ModelicaByExample/BasicEquations/LotkaVolterra/QuiescentModelWithInheritance.mo
   :language: modelica
   :emphasize-lines: 9-11
   :lines: 2-

Note the presence of the ``extends`` keyword.  Conceptually, this
"extends clause" simply asks the compiler to insert the contents of
another model (``ClassicModel`` in this case) into the model being
defined.  In this way, we copy (or "inherit") everything from
``ClassicModel`` without having to repeat its contents.  As a result,
the ``QuiescentModelWithInheritance`` is the same as the
``ClassicModel`` with an additional set of initial equations inserted.

.. index:: modifications

But what about a case where we don't want **exactly** what is in the
model we are inheriting from?  For example, what if we wanted to
change the values of the ``gamma`` and ``delta`` parameters?

Modelica handles this by allowing us to include a set of "modifications"
when we use ``extends``.  These modifications come after the name of
the model being inherited from as shown below:

.. literalinclude:: /ModelicaByExample/BasicEquations/LotkaVolterra/QuiescentModelWithModifications.mo
   :language: modelica
   :emphasize-lines: 2
   :lines: 2-

Also note that we could have inherited from ``ClassicModel``, but then
we would have had to repeat the initial equations in order to have
quiescent initial conditions.  But by instead inheriting from
``QuiescentModelWithModifications``, we reuse the content from
**two** different models and avoid repeating ourselves even once.

.. topic:: More population dynamics

  This concludes the set of examples for this chapter.  If you'd like
  to explore the Lotka-Volterra equations in greater depth, an
  upcoming section titled :ref:`population-components` demonstrates
  how to build complex models of population dynamics using graphical
  components that are dropped onto a schematic and connected together.

.. [Lotka] Lotka, A.J., "Contribution to the Theory of Periodic Reaction", J. Phys. Chem., 14 (3), pp 271–274 (1910)
.. [Volterra] Volterra, V., Variations and fluctuations of the number of individuals in animal species living together in Animal Ecology, Chapman, R.N. (ed), McGraw–Hill, (1931)
.. [Guldberg] C.M. Guldberg and P. Waage,"Studies Concerning Affinity" C. M. Forhandlinger: Videnskabs-Selskabet i Christiana (1864), 35
