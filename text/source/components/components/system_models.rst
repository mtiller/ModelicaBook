.. _system-models:

System Models
-------------

The next chapter will provide an in-depth discussion about
:ref:`subsystems`.  For now, we'll only discuss the handful of topics
related to subsystems that we've seen so far.

.. _system-connections:

Connections
^^^^^^^^^^^

One distinction that we've seen in this chapter between component and
subsystem models is that subsystem models include ``connect``
statements.  To explore how the ``connect`` statement works, let's
revisit the ``MultiDomainControl`` example from the discussion on
:ref:`thermal-control`.  If we strip away all the annotations (which
we will discuss shortly), we get a model that looks like this:

.. code-block:: modelica

    within ModelicaByExample.Components.BlockDiagrams.Examples;
    model MultiDomainControl
      "Mixing thermal components with blocks for sensing, actuation and control"

      import Modelica.SIunits.Conversions.from_degC;

      parameter Real h = 0.7 "Convection coefficient";
      parameter Real m = 0.1 "Thermal maass";
      parameter Real c_p = 1.2 "Specific heat";
      parameter Real T_inf = from_degC(25) "Ambient temperature";
      parameter Real T_bar = from_degC(30.0) "Desired temperature";
      parameter Real k = 2.0 "Controller gain";

      Components.Constant setpoint(k=T_bar);
      Components.Feedback feedback;
      Components.Gain controller_gain(k=k);
      HeatTransfer.ThermalCapacitance cap(C=m*c_p, T0 = from_degC(90));
      HeatTransfer.Convection convection2(h=h);
      HeatTransfer.AmbientCondition amb(T_amb(displayUnit="K") = T_inf);
      Components.IdealTemperatureSensor sensor;
      Components.HeatSource heatSource;
    equation
      connect(setpoint.y, feedback.u1);
      connect(feedback.y, controller_gain.u);
      connect(convection2.port_a, cap.node);
      connect(amb.node, convection2.port_b);
      connect(sensor.y, feedback.u2);
      connect(heatSource.node, cap.node);
      connect(controller_gain.y, heatSource.u);
      connect(sensor.node, cap.node);
    end MultiDomainControl;

During our earlier discussion on :ref:`acausal-modeling`, we talked
about equations that are generated for **acausal** variables in a
connector.  But the impact of a ``connect`` statement depends on the
nature of the variables being connected.  The ``MultiDomainControl``
model is useful because it isn't restricted to acausal connections.

.. index:: ! connect

Before we consider the specific connections in the
``MultiDomainControl`` model, let's first elaborate on what the
``connect`` statement actually does.  There are some complex cases
that arise, but for the sake of simplicity and pedagogy, we'll only
discuss the basic case here.

A ``connect`` statement connects exactly two connectors.  It then
"pairs up" variables across each connector **by name**.  In other
words, it takes each variable in one connector and pairs it up with
the variable of the same name in the other connector.

.. index:: connect; input
.. index:: connect; output
.. index:: connect; parameter

For each pair, the compiler first checks to make sure that the two
corresponding variables have the same type (*e.g.,* ``Real``,
``Integer``).  But what equations are generated and what additional
restrictions exists depend on what qualifiers have been applied to the
variables.  The following list covers all the essential cases:

   * **Through variables** - These are variables with the ``flow``
     qualifier.  As we covered in our previous discussion on
     :ref:`acausal-modeling`, a conservation equation is generated for
     all variables in the connection set.
   * **Parameters** - A variable that includes the ``parameter``
     qualifier does not generate any equations.  Instead, it generates
     an ``assert`` call that ensures that the values are identical
     between the two variables.  This is useful when a ``connector``
     includes ``Integer`` parameters that specify the size of arrays
     in the connector, for example, because it asserts the arrays are
     the same size.
   * **Inputs** - A variable that has the ``input`` qualifier can only
     be paired with a variable that has an ``input`` or an ``output``
     qualifier.  Assuming this requirement is met, an equation will be
     generated simply equating these two variables.
   * **Outputs** - A variable that has the ``output`` qualifier can
     only be paired with a variable that has the ``input`` qualifier
     (*i.e.,* two outputs can never be connected).  As with the case
     for input variables, an equality relationship is generated for
     such a connection.
   * **Across variables** - These are variables that lack any
     qualifiers (unlike the previous cases).  As we covered in our
     previous discussion on :ref:`acausal-modeling`, a series of
     equations will be generated equating all the across variables in
     the connection set.

In our discussion of :ref:`block-components`, we describe the
``input`` and ``output`` qualifiers as "causal".  In fact, the
``input`` and ``output`` qualifiers do not actually specify the order
in which calculations are performed.  As discussed above, they just
enforce restrictions on how the variables can be connected.  In
addition to the restriction already mentioned, there is one additional
restriction that, within a connection set, there can only be one
``output`` signal (for obvious reasons).

In our ``MultiDomainControl`` model, we can see several of these cases
covered.  For example,

.. code-block:: modelica

      connect(setpoint.y, feedback.u1);

Here, an ``output`` signal, ``setpoint.y``, is connected to an
``input`` signal, ``feedback.u1``.  So this is a connection involving
only causal signals.  On the other hand, we have connections like
this:

.. code-block:: modelica

      connect(heatSource.node, cap.node);

This will lead to the types of conservations equations :ref:`discussed
earlier <acausal-modeling>`.

In summary, a ``connect`` statement is a way to generate equations
that automatically manages complex tasks (like generation of conservation
and continuity equations) while at the same time checking to make sure
that the connection makes sense (*e.g..,* that the variables have the
same type).

.. _subsystem-diagrams:

Diagrams
^^^^^^^^

In this chapter, we showed how Modelica subsystem models can be
represented graphically, *e.g.,*

.. image:: /ModelicaByExample/Components/HeatTransfer/Examples/Cooling.*
   :height: 200px
   :align: center
   :alt: Cooling example schematic

All the information required to generate such a diagram is contained
in the Modelica model.  While this information has been visible in
some of the Modelica code listings in this chapter, we haven't really
discussed what information is stored and where.

To render a subsystem diagram, three pieces of information are needed:

   * The icon to use to represent each component.
   * The location of each component.
   * The path for each connection

Component Icon
~~~~~~~~~~~~~~

The icon used for each component is simply whatever drawing primitives
are included in the ``Icon`` annotation for that component's
definition.  The details of the ``Icon`` annotation were covered in
our previous discussion of :ref:`graphical-annos`.

.. index:: annotation; Placement

.. _placement:

Component Placement
~~~~~~~~~~~~~~~~~~~

Now that we know what to draw for each component, we need to know
where to draw it.  This is where the ``Placement`` annotation comes
in.  This annotation appeared in many of the examples in this
chapter, *e.g.,*

.. literalinclude:: /ModelicaByExample/Components/HeatTransfer/Examples/Cooling.mo
   :language: modelica
   :lines: 6-7
   :emphasize-lines: 7

The ``Placement`` annotation simply establishes a rectangular region
in which to draw the icon associated with each component.  As with
other :ref:`graphical-annos`, we can describe the ``Placement``
annotation in terms of a ``record`` definition:

.. code-block:: modelica

    record Placement
      Boolean visible = true;
      Transformation transformation "Placement in the diagram layer";
      Transformation iconTransformation "Placement in the icon layer";
    end Placement; 

The ``visible`` field serves the same purpose as it does in the
``GraphicItem`` annotation we discussed earlier, *i.e.,* it is used to
control whether the component is rendered or not.

The ``transformation`` field defines how the icon is rendered in a
schematic diagram and the ``iconTransformation`` defines how it is
rendered if it is considered part of the **subsystem's** icon.
Generally, the ``iconTransformation`` is only defined for connectors
since these are typically the only components that appear in the icon
representation.

The ``Transformation`` annotation, which is defined as follows:

.. code-block:: modelica

    record Transformation
      Point origin = {0, 0};
      Extent extent;
      Real rotation(quantity="angle", unit="deg")=0;
    end Transformation; 

The ``rotation`` field indicates how many degrees the component's icon
should be rotated and the ``origin`` field indicates the point around
which this rotation should occur.  Finally, the ``extent`` field
indicates the size of the region the icon will be rendered into.

Connection Rendering
~~~~~~~~~~~~~~~~~~~~

Finally, we have the third topic, rendering the connections.  Again,
the annotations that govern how connections are rendered have appeared
in many examples.  Now, finally, we'll explain what that information
represents.  Consider the following ``connect`` statement from our
:ref:`thermal-control` example:

.. literalinclude:: /ModelicaByExample/Components/BlockDiagrams/Examples/MultiDomainControl.mo
   :language: modelica
   :lines: 55-58

Note that the ``connect`` statement is followed by an annotation.  In
particular, note that this is a ``Line`` annotation.  We already
discussed the :ref:`line-anno`.  The annotation data is the same in
this context as it was then.
