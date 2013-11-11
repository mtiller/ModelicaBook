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
:ref:`builtin-types`.

At this point, you might find the idea of defining ``Temperature``,
``ConvectionCoefficient``, ``SpecificHeat`` and ``Mass`` in every
model extremely tedious.  But don't worry, this won't be necessary as
you will see in a later section where we discuss
:ref:`importing_physical_types`.  For now, just realize that we are
able to define physical types and then associate them with variables.

