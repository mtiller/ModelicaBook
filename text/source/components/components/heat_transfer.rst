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

Thermal Capacitance
~~~~~~~~~~~~~~~~~~~

Our first component model will be a model of thermal capacitance.  The
model (with the ``Icon`` annotation removed) is quite simple:

.. literalinclude:: /ModelicaByExample/Components/HeatTransfer/ThermalCapacitance.mo
   :language: modelica
   :lines: 1-10,41



ConvectionToAmbient
~~~~~~~~~~~~~~~~~~~

Convection
~~~~~~~~~~

AmbientCondition
~~~~~~~~~~~~~~~~

Example Systems
^^^^^^^^^^^^^^^
