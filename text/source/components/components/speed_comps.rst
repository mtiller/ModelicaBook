.. _speed-components:

Speed Measurement Revisited
---------------------------

Recall our previous discussion on :ref:`speed-measurement`.  That
discussion took place before we had introduced the idea of building
reusable components.  As a result, adding equations associated with
the various speed measurement techniques was awkward.

In this section, we'll revisit that topic.  As before, we assume that
we have an existing model of the "plant" (the system whose speeds we
wish to measure).  But this time, we'll create reusable component
models for different speed estimation algorithms and add them as
graphical components.

Plant Model
^^^^^^^^^^^

We'll start with our "plant model".  The plant model is the system we
wish to control.  The schematic for our plant model is rendered as:

.. figure:: /ModelicaByExample/Components/SpeedMeasurement/Examples/Plant.svg
   :width: 100%
   :align: center
   :alt: Plant Model Schematic
   :figclass: align-center

The source code for the underlying Modelica model is:

.. literalinclude:: /ModelicaByExample/Components/SpeedMeasurement/Examples/Plant.mo
   :language: modelica

The first step in (feedback) control is to be able to measure the
thing we are trying to control.  So in the remaining sections we will
create models that use different approximation techniques to measure
the speed of the ``inertia`` component in our plant model.

Before we look at the different speed approximation methods, let's
have a look at the actual speed response from our plant model.

.. plot:: ../plots/PBase.py
   :include-source: no

Note that the response has a 1 Hertz frequency and includes both
positive and negative rotational velocities.

Sample and Hold Sensor
^^^^^^^^^^^^^^^^^^^^^^

Previously, we discussed the :ref:`sample-and-hold` approach to speed
measurement.  Here we will revisit this topic but encapsulate the
speed approximation in a reusable sensor model.  The following model
implements the "sample and hold" approximation to speed measurement:

.. literalinclude:: /ModelicaByExample/Components/SpeedMeasurement/Components/SampleHold.mo
   :language: modelica

However, we have once again saved ourselves some trouble by utilizing
a ``partial`` model to represent code that will be common across our
various sensor models.  As we can see from the definition of the
``SpeedSensor`` model:

.. literalinclude:: /ModelicaByExample/Components/SpeedMeasurement/Interfaces/SpeedSensor.mo
   :language: modelica

We can see from the ``SpeedSensor`` model that the output signal will
be named ``w``.  But we also see that ``SpeedSensor`` inherits from
another model in the Modelica Standard Library,
``PartialAbsoluteSensor``.  The ``PartialAbsoluteSensor`` model is
defined as:

.. code-block:: modelica

    partial model PartialAbsoluteSensor
      "Partial model to measure a single absolute flange variable"
      extends Modelica.Icons.RotationalSensor;

      Flange_a flange "Flange from which speed will be measured"
        annotation(Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
    equation
      0 = flange.tau;
    end PartialAbsoluteSensor;

In addition to providing a nice icon, the ``PartialAbsoluteSensor``
model features a rotational connector, ``flange``.  Furthermore, the
model assumes that the sensor model is completely passive (*i.e.,* it
has no impact on the system it is sensing) since it applies zero
torque at the connection point.

To test this model, we simply extend from our ``Plant`` model, add an
instance of the ``SampleHold`` sensor and connect it to the
``inertia``, *e.g.*,

.. literalinclude:: /ModelicaByExample/Components/SpeedMeasurement/Examples/PlantWithSampleHold.mo
   :language: modelica

When assembled, our final system looks like this:

.. figure:: /ModelicaByExample/Components/SpeedMeasurement/Examples/PlantWithSampleHold.svg
   :width: 100%
   :align: center
   :alt: Plant with sample hold sensor
   :figclass: align-center

If we simulate this system for 10 seconds, we can compare the actual
speed of the inertia with the signal returned from our sensor:

.. plot:: ../plots/PwSH.py
   :include-source: no

Interval Measurement
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: /ModelicaByExample/Components/SpeedMeasurement/Examples/PlantWithIntervalMeasure.mo
   :language: modelica

.. figure:: /ModelicaByExample/Components/SpeedMeasurement/Examples/PlantWithIntervalMeasure.svg
   :width: 100%
   :align: center
   :alt: Plant with interval measure sensor
   :figclass: align-center

.. plot:: ../plots/PwIM.py
   :include-source: no

Pulse Counter
^^^^^^^^^^^^^

.. literalinclude:: /ModelicaByExample/Components/SpeedMeasurement/Examples/PlantWithPulseCounter.mo
   :language: modelica

.. figure:: /ModelicaByExample/Components/SpeedMeasurement/Examples/PlantWithPulseCounter.svg
   :width: 100%
   :align: center
   :alt: Plant with pulse counter sensor
   :figclass: align-center

.. plot:: ../plots/PwPC.py
   :include-source: no
