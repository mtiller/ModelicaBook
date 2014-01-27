.. _heat-transfer-components:

Heat Transfer Components
------------------------

We'll start our discussion of component models by building some
component models in the heat transfer domain.  These models will allow
us to recreate the models we saw :ref:`previously <getting-physical>`
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

        annotation(
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
that implement (only) on physical effect (*e.g.,* capacitance,
convection).  By implementing component models in this way, we will
see that they can then be combined in any infinite number of different
configurations without the need to add any more equations.  This kind
of reuse of equations makes the model developer more productive and
avoids opportunities to introduce errors.

.. _thermal-capacitance:

Thermal Capacitance
~~~~~~~~~~~~~~~~~~~

Our first component model will be a model of thermal capacitance.
This is a model for a lumped thermal capacitance with a uniform
temperature distribution.  The equation we wish to associate with this
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
annotation for the moment, we'll come back to that shortly.

Using the graphical annotations in the model (some of which were left
out of the previous listing) it can be rendered as:

.. image:: /ModelicaByExample/Components/HeatTransfer/Examples/Adiabatic.svg
   :width: 700

Since no heat enters or leaves the thermal capacitance component,
``cap``, the temperature of the capacitance remains constant as shown
in the following plot:

.. plot:: ../plots/HTA.py
   :include-source: no

ConvectionToAmbient
~~~~~~~~~~~~~~~~~~~

To quickly add some heat transfer, we could define another component
model to represent heat transfer to some ambient temperature.  Such a
model could be represented in Modelica (again, without the ``Icon``
annotation) as follows:

.. literalinclude:: /ModelicaByExample/Components/HeatTransfer/ConvectionToAmbient.mo
   :language: modelica
   :lines: 1-8,47

This model includes parameters for the heat transfer coefficient,
``h``, and the ambient temperature, ``T_amb``.  This model is attached
to other heat transfer elements through the connector ``port_a``.

Again, we must pay close attention to the sign convention.  Recall
from our previous discussion of :ref:`thermal-capacitance` that
Modelica follows a sign convention that a positive value for a
``flow`` variable represents flow into the component.  In particular,
let's take a close look at the equation in the ``ConvectionToAmbient``
model:

.. literalinclude:: /ModelicaByExample/Components/HeatTransfer/ConvectionToAmbient.mo
   :language: modelica
   :lines: 8

Note that when ``port_a.T`` is greater than ``T_amb``, the sign of
``port_a.Q_flow`` is greater than zero.  That means heat is flowing
**into** this component.  In other words, when ``port_a.T`` is greater
than ``T_amb``, this component will **take heat away** from
``port_a`` (and, conversely, when ``T_amb`` is greater than
``port_a.T``, it will **inject heat into** ``port_a``).

Having such a component model available enables us to combine with the
``ThermalCapacitance`` model and simulate a system just like we
modeled in :ref:`some of our earlier heat transfer examples
<getting-physical>` using the following Modelica code:

.. literalinclude:: /ModelicaByExample/Components/HeatTransfer/Examples/CoolingToAmbient.mo
   :language: modelica

.. index:: connect

In this model, we see two components have been declared, ``cap`` and
``conv``.  The parameters for each of these components are also
specified when they are declared.  But what is really remarkable about
this model is the equation section:

.. literalinclude:: /ModelicaByExample/Components/HeatTransfer/Examples/CoolingToAmbient.mo
   :language: modelica
   :lines: 11-14



Convection
~~~~~~~~~~

AmbientCondition
~~~~~~~~~~~~~~~~
