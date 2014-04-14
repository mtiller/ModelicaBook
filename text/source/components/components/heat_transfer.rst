.. _heat-transfer-components:

Heat Transfer Components
------------------------

We'll start our discussion of component models by building some
component models in the heat transfer domain.  These models will allow
us to recreate the models we saw :ref:`previously <getting-physical>`,
but this time using component models to represent each of the various
effects.  Investing the time to make component models will then allow
us to easily combine the underlying physical behavior to create models
for a wide variety of thermal systems.

Thermal Connectors
^^^^^^^^^^^^^^^^^^

In our previous discussion on :ref:`simple-domains` we described how a
thermal connector could be described.  For the component models in
this section, we will utilize the thermal connector models from the
Modelica Standard Library.  These connectors are defined as follows:

.. code-block:: modelica

    within Modelica.Thermal.HeatTransfer;
    package Interfaces "Connectors and partial models"
      partial connector HeatPort "Thermal port for 1-dim. heat transfer"
        Modelica.SIunits.Temperature T "Port temperature";
        flow Modelica.SIunits.HeatFlowRate Q_flow
          "Heat flow rate (positive if flowing from outside into the component)";
      end HeatPort;

      connector HeatPort_a "Thermal port for 1-dim. heat transfer (filled rectangular icon)"
        extends HeatPort;

        annotation(...,
          Icon(coordinateSystem(preserveAspectRatio=true,
                                extent={{-100,-100},{100,100}}),
                                graphics={Rectangle(
			          extent={{-100,100},{100,-100}},
                                  lineColor={191,0,0},
                                  fillColor={191,0,0},
                                  fillPattern=FillPattern.Solid)}));
      end HeatPort_a;

      connector HeatPort_b "Thermal port for 1-dim. heat transfer (unfilled rectangular icon)"
        extends HeatPort;

        annotation(...,
          Icon(coordinateSystem(preserveAspectRatio=true,
                                extent={{-100,-100},{100,100}}),
                                graphics={Rectangle(
                                  extent={{-100,100},{100,-100}},
                                  lineColor={191,0,0},
                                  fillColor={255,255,255},
                                  fillPattern=FillPattern.Solid)}));
      end HeatPort_b;
    end Interfaces;

Careful inspection of these connector definitions shows that
``HeatPort_a`` and ``HeatPort_b`` are identical in terms of their
content to the ``HeatPort`` model.  The only difference is that
``HeatPort_a`` and ``HeatPort_b`` have distinguishing graphical icons.

The component models presented in the remainder of this section will
utilize these connector definitions.

Component Models
^^^^^^^^^^^^^^^^

When building component models, the goal is to create component models
that implement (only) one physical effect (*e.g.,* capacitance,
convection).  By implementing component models in this way, we will
see that they can then be combined in any infinite number of different
configurations without the need to add any more equations.  This kind
of reuse of equations makes the model developer more productive and
avoids opportunities to introduce errors.

.. _thermal-capacitance:

Thermal Capacitance
~~~~~~~~~~~~~~~~~~~

Our first component model will be a model of lumped thermal capacitance.
with uniform temperature distribution.  
The equation we wish to associate with this
component model is:

.. math::

    C \dot{T} = Q_{flow}

The Modelica model (with the ``Icon`` annotation removed) representing
this equation is quite simple:

.. literalinclude:: /ModelicaByExample/Components/HeatTransfer/ThermalCapacitance.mo
   :language: modelica
   :lines: 1-10,41

where ``C`` is the thermal capacitance and ``T0`` is the initial
temperature.

Note the presence of the ``node`` connector in this model.  This is
how the ``ThermalCapacitance`` component model interacts with the
"outside world".  We will use the temperature at the ``node``,
``node.T`` to represent the temperature of the thermal capacitance.
The ``flow`` variable, ``node.Q_flow``, represents the flow of heat
**into** the thermal capacitance.  We can see this when looking at the
equation for the thermal capacitance:

.. literalinclude:: /ModelicaByExample/Components/HeatTransfer/ThermalCapacitance.mo
   :language: modelica
   :lines: 10

Note that when ``node.Q_flow`` is positive, the temperature of the
thermal capacitance, ``node.T``, will increase.  This confirms that we
have followed the Modelica convention that ``flow`` variables on a
connector represent a flow of the conserved quantity, heat in this
case, into the component (a more thorough discussion of
:ref:`flow-signs` will be presented shortly).

Using this model alone, we can already build a simple "system" model
as follows:

.. literalinclude:: /ModelicaByExample/Components/HeatTransfer/Examples/Adiabatic.mo
   :language: modelica

This model contains only the thermal capacitance element (as indicated
by the declaration of the variable ``cap`` of type
``ThermalCapacitance``) and no other heat transfer elements (*e.g.,*
conduction, convection, radiation).  Ignore the ``Placement``
annotation for the moment, we'll provide a complete explanation in a
later section on :ref:`comp-annos`.

Using the graphical annotations in the model (some of which were left
out of the previous listing) it can be rendered as:

.. image:: /ModelicaByExample/Components/HeatTransfer/Examples/Adiabatic.*
   :height: 200px
   :align: center
   :alt: Adiabatic system schematic

Since no heat enters or leaves the thermal capacitance component,
``cap``, the temperature of the capacitance remains constant as shown
in the following plot:

.. plot:: ../plots/HTA.py
   :class: interactive

ConvectionToAmbient
~~~~~~~~~~~~~~~~~~~

To quickly add some heat transfer, we could define another component
model to represent heat transfer to some ambient temperature.  Such a
model could be represented in Modelica (again, without the ``Icon``
annotation) as follows:

.. literalinclude:: /ModelicaByExample/Components/HeatTransfer/ConvectionToAmbient.mo
   :language: modelica
   :lines: 1-9,48

This model includes parameters for the heat transfer coefficient,
``h``, the surface area, ``A`` and the ambient temperature, ``T_amb``.
This model is attached to other heat transfer elements through the
connector ``port_a``.

Again, we must pay close attention to the sign convention.  Recall
from our previous discussion of :ref:`thermal-capacitance` that
Modelica follows a sign convention that a positive value for a
``flow`` variable represents flow into the component.  In particular,
let's take a close look at the equation in the ``ConvectionToAmbient``
model:

.. literalinclude:: /ModelicaByExample/Components/HeatTransfer/ConvectionToAmbient.mo
   :language: modelica
   :lines: 9

Note that when ``port_a.T`` is greater than ``T_amb``, the sign of
``port_a.Q_flow`` is greater than zero.  That means heat is flowing
**into** this component.  In other words, when ``port_a.T`` is greater
than ``T_amb``, this component will **take heat away** from
``port_a`` (and, conversely, when ``T_amb`` is greater than
``port_a.T``, it will **inject heat into** ``port_a``).

Having such a component model available enables us to combine it with
the ``ThermalCapacitance`` model and simulate a system just like we
modeled in :ref:`some of our earlier heat transfer examples
<getting-physical>` using the following Modelica code:

.. literalinclude:: /ModelicaByExample/Components/HeatTransfer/Examples/CoolingToAmbient.mo
   :language: modelica

.. index:: connect

In this model, we see two components have been declared, ``cap`` and
``conv``.  The parameters for each of these components are also
specified when they are declared.  The following is a schematic for
the ``CoolingToAmbient`` model:

.. image:: /ModelicaByExample/Components/HeatTransfer/Examples/CoolingToAmbient.*
   :height: 200px
   :align: center
   :alt: Cooling to ambient schematic

But what is really remarkable about this model is the equation
section:

.. literalinclude:: /ModelicaByExample/Components/HeatTransfer/Examples/CoolingToAmbient.mo
   :language: modelica
   :lines: 10-14

This statement introduces one of the most important features in
Modelica.  Note that statement appears within an ``equation``
section.  While the ``connect`` operator looks like a function, it is
much more than that.  It represents the equations that should be
generated to model the interaction between the two specified
connectors, ``cap.node`` and ``conv.port_a``.

In this context, a connection does two important things.  The first
thing it does is to generate an equation that equates the "across"
variables on either connector.  In this case, that means the following
equation:

.. code-block:: modelica

    cap.node.T = conv.port_a.T "Equating across variables";

In addition, a connection generates an equation for all the through
variables as well.  The equation that is generated is a conservation
equation.  You can think of this conservation equation as a
generalization of Kirchoff's current law to any conserved quantity.
Basically, it represents the fact that the connection itself has no
"storage" ability and that whatever amount of the conserved quantity,
in this case heat, that flows out of one component must go into the
other(s).  So in this case, the connect statement will generate the
following equation with respect to the ``flow`` variables:

.. code-block:: modelica

    cap.node.Q_flow + conv.port_a.Q_flow = 0 "Sum of heat flows must be zero";

Note the sign convention here.  All the ``flow`` variables are summed.
We will examine more complex cases shortly where multiple components
are interacting.  But in this simple case, with only two components,
we see clearly that if one value for ``Q_flow`` is positive, the other
must be negative.  In other words, if heat is flowing out of one
component, it must be flowing into another.  These conservation
equations ensure that we have a proper accounting of conserved
quantities throughout our network and that no amount of the conserved
quantity gets "lost".

A very simple way to summarize the behavior of a connection, in the
context of a thermal problem, is to **think of a connection as a
perfectly conducting element with no thermal capacitance**.

If we simulate the ``CoolingToAmbient`` model above, we get the
following temperature trajectory:

.. plot:: ../plots/HT_CTA.py
   :class: interactive

.. _digging-deeper:

Digging Deeper
^^^^^^^^^^^^^^

There is one slight issue with the ``CoolingToAmbient`` model.  We
mentioned earlier that when building component models it is best to
isolate each individual physical effect to its own component.  But we've
actually lumped two different effects into one component.  As we will
see in a moment, this limits the reusability of the component models.
But first, let's refactor the code to separate these effects out and
then we'll revisit the system level model using these new components.

Convection
~~~~~~~~~~

The first new component is a ``Convection`` model.  In this case, we
won't make any assumptions about the temperature at either end.
Instead, we'll only assume that each is connected to something with an
appropriate thermal connector.  The result is a model like this one:

.. literalinclude:: /ModelicaByExample/Components/HeatTransfer/Convection.mo
   :language: modelica
   :lines: 1-11,50

This model contains two equations.  The first equation:

.. code-block:: modelica

    port_a.Q_flow + port_b.Q_flow = 0 "Conservation of energy";

represents the fact that this component does not store heat.  The
equation enforces the constraint that whatever heat flows in from one
connector must flow out from the other (which is exactly the same
behavior we saw from the ``connect`` statement earlier in this
section).  The next equation:

.. code-block:: modelica

    port_a.Q_flow = h*A*(port_a.T-port_b.T) "Heat transfer equation";

captures the heat transfer relationship for convection by expressing
the relationship between the flow of heat through this component and
the temperatures on either end.

.. index:: number of equations required

.. topic:: Number of equations

    All our previous models had one connector and one equation.  The
    ``Convection`` model has two connectors.  As a result, it has two
    equations.  A simple rule of thumb is that you need as many
    equations as connectors.  But keep in mind that this rule of thumb
    assumes that you are using connectors with only one through
    variable on them and no "internal variables" in your model
    (*e.g.,* ``protected`` variables).  The upcoming section on
    :ref:`model-comps` will provide a more comprehensive discussion on
    determining how many equations a component requires.
    Specifically, it will provide guidance on how to build so-called
    :ref:`balanced-components`.

.. _amb-cond:

AmbientCondition
~~~~~~~~~~~~~~~~

Now that we have the convection model, we need something to represent
the ambient conditions.  We need something like a thermal capacitance
model, but one that maintains a constant temperature.  Imagine if we
took the ``ThermalCapacitance`` model and gave a very large value for
its capacitance, ``C``.  Then we'd have something that changed
temperature very slowly.  But what we want is something that doesn't
change temperature at all, as if it had a ``C`` value that was
infinitely large.

.. index:: infinite reservoir

This kind of model comes up frequently and it is commonly called an
"infinite reservoir" model.  Typically, such a model is characterized
by the fact that no matter how much of the conserved quantity (heat in
this case) flows into or out of the component, the across variable
remains constant.  In an electrical context, such a model would
represent electrical ground.  In a mechanical context, it would
represent a mechanical ground (something that didn't change position,
regardless of how much force was applied).

We will represent our ambient conditions using the
``AmbientConditions`` model:

.. literalinclude:: /ModelicaByExample/Components/HeatTransfer/AmbientCondition.mo
   :language: modelica
   :lines: 1-9,28

Since we are talking about the heat transfer domain, this model is an
infinite reservoir for heat and no matter how much heat flows into or
out of this component, its temperature remains the same.

Flexibility
~~~~~~~~~~~

Using these new ``Convection`` and an ``AmbientCondition`` models, we
can reconstruct our simple system level heat transfer model using
the following:

.. literalinclude:: /ModelicaByExample/Components/HeatTransfer/Examples/Cooling.mo
   :language: modelica

When rendered, the model looks like this:

.. image:: /ModelicaByExample/Components/HeatTransfer/Examples/Cooling.*
   :height: 200px
   :align: center
   :alt: Cooling example schematic

This may not seem like much of an improvement.  Although we went to
the trouble to break up the ``ConvectionToAmbient`` model into individual
``Convection`` and ``AmbientTemperature`` models, we still end up with
the same fundamental behavior, *i.e.,*

.. plot:: ../plots/HT_C.py
   :class: interactive

The big benefit of breaking down ``ConvectionToAmbient`` into
``Convection`` and ``AmbientTemperature`` models is the ability to
recombine them in different ways.  The following schematic is just one
example of how the handful of fundamental components we've constructed
so far can be rearranged to form an entirely new (and more complex)
model:

.. image:: /ModelicaByExample/Components/HeatTransfer/Examples/ComplexNetwork.*
   :width: 100%
   :align: center
   :alt: Complex thermal network schematic

.. todo::

   I should include some results here.  The issue is that the current
   model is singular.  So I need to revisit the ``ComplexNetwork``
   model.  There is already an entry in the spec file, I just need to
   fix it so it can simulate.

.. plot:: ../plots/HT_CN.py
   :class: interactive

In fact, with these components we can now make **arbitrarily complex**
networks of components and still never have to worry about formulating
the associated equations that describe their dynamics.  Everything
that is required to do this has already been captured in our component
models.  This allows us to focus on the process of creating and
designing our system and leave the tedious, time-consuming and error
prone work of manipulating equations behind.
