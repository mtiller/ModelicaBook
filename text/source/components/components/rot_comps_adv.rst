.. _adv-rotational-components:

Advanced Rotational Components
------------------------------

In the previous section, we discussed :ref:`rotational-components` and
showed how to build a system model from basic components.  In this
section we will demonstrate how to incorporate event handling, which
we will use to when modeling a backlash.  Furthermore, we'll also show
how to use parameter values to affect the interface of a component.

Modeling Backlash
^^^^^^^^^^^^^^^^^

Let's start our exploration of more advanced component models by
looking at a rotational backlash element.  The equation for a backlash
model is very simple:

.. math::

    \tau =
    \left\{
    \begin{array}{cc}
    c (\Delta \varphi - \frac{b}{2}) \ \  &\mathrm{if}\ \Delta \varphi>\frac{b}{2} \\
    c (\Delta \varphi + \frac{b}{2}) \ \  &\mathrm{if}\ \Delta \varphi<-\frac{b}{2} \\
    0 \ \ &\mathrm{otherwise}
    \end{array}
    \right.

.. todo::

   Include a torque-deflection diagram here.

In Modelica, this component be described as follows:

.. literalinclude:: /ModelicaByExample/Components/Rotational/Components/Backlash.mo
   :language: modelica
   :lines: 1-13,37

.. image:: /ModelicaByExample/Components/Rotational/Examples/SMD_WithBacklash.svg
   :width: 100%
   :align: center
   :alt: 

Grounding and Reaction Torques
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: /ModelicaByExample/Components/Rotational/Examples/SMD_WithGroundedGear.svg
   :width: 100%
   :align: center
   :alt: 

Comparison
^^^^^^^^^^

.. image:: /ModelicaByExample/Components/Rotational/Examples/SMD_GearComparison.svg
   :width: 100%
   :align: center
   :alt: 

Optional Ground Connector
^^^^^^^^^^^^^^^^^^^^^^^^^

.. figure:: /ModelicaByExample/Components/Rotational/Examples/SMD_ConfigurableGear.svg
   :width: 100%
   :align: center
   :alt: Example using a configurable gear
   :figclass: align-center
