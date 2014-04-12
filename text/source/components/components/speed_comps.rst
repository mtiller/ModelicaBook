.. _speed-components:

Speed Measurement Revisited
---------------------------

Recall our previous discussion on :ref:`speed-measurement`.  That
discussion took place before we had introduced the idea of building
reusable components.  As a result, adding equations associated with
the various speed measurement techniques was awkward.

In this section, we'll revisit that topic and all of the various speed
estimation techniques discussed there.  As before, we assume that we
have an existing model of the "plant" (the system whose speeds we wish
to measure).  But this time, we'll create reusable component models
for different speed estimation algorithms and add them to the plant
model as graphical components.

Plant Model
^^^^^^^^^^^

We'll start with our "plant model".  It is identical in behavior to
the system we used in our previous discussion of
:ref:`speed-measurement` and when rendered as a schematic, looks like
this:

.. figure:: /ModelicaByExample/Components/SpeedMeasurement/Examples/Plant.*
   :width: 100%
   :align: center
   :alt: Plant Model Schematic
   :figclass: align-center

The source code for the underlying Modelica model is:

.. literalinclude:: /ModelicaByExample/Components/SpeedMeasurement/Examples/Plant.mo
   :language: modelica

In the remaining sections we will create models that use different
approximation techniques to measure the speed of the ``inertia1``
component in our plant model.

Before we look at the different speed approximation methods, let's
have a look at the actual speed response from our plant model.

.. plot:: ../plots/PBase.py
   :class: interactive

Note that this is exactly the same response we saw when we initially
covered this topic.

.. _sample-hold-sensor:

Sample and Hold Sensor
^^^^^^^^^^^^^^^^^^^^^^

Previously, we discussed the :ref:`sample-and-hold` approach to speed
measurement.  Here we will revisit this topic, but encapsulate the
speed approximation in a reusable sensor model.  The following model
implements the "sample and hold" approximation to speed measurement:

.. literalinclude:: /ModelicaByExample/Components/SpeedMeasurement/Components/SampleHold.mo
   :language: modelica

Behaviorally, there is not difference between this estimation
technique and our previous implementation of :ref:`sample-and-hold`.
But our approach is different this time because we have wrapped that
estimation technique in a reusable component model.

We have once again saved ourselves some trouble by utilizing a
``partial`` model to represent code that will be common across our
various sensor models.  As we can see from the definition of the
``SpeedSensor`` model:

.. literalinclude:: /ModelicaByExample/Components/SpeedMeasurement/Interfaces/SpeedSensor.mo
   :language: modelica

We can see from the ``SpeedSensor`` model that the output signal is
named ``w``.  But we also see that ``SpeedSensor`` inherits from
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

.. figure:: /ModelicaByExample/Components/SpeedMeasurement/Examples/PlantWithSampleHold.*
   :width: 100%
   :align: center
   :alt: Plant with sample hold sensor
   :figclass: align-center

If we simulate this system for 5 seconds, we can compare the actual
speed of the inertia with the signal returned from our sensor:

.. plot:: ../plots/PwSH.py
   :class: interactive

These results are identical to the results from our previous
discussion of the :ref:`sample-and-hold` approach.

Interval Measurement
^^^^^^^^^^^^^^^^^^^^

Now let us turn our attention to the :ref:`interval-measurement`
technique.  Again, we will create a reusable component model by
extending from our ``Sensor`` model.  This time, the implementation
will use the time between teeth to estimate speed:

.. literalinclude:: /ModelicaByExample/Components/SpeedMeasurement/Components/IntervalMeasure.mo
   :language: modelica

Adding this sensor to our plant model is as simple as creating the
following Modelica model:

.. literalinclude:: /ModelicaByExample/Components/SpeedMeasurement/Examples/PlantWithIntervalMeasure.mo
   :language: modelica

When assembled, our system model looks like this:

.. figure:: /ModelicaByExample/Components/SpeedMeasurement/Examples/PlantWithIntervalMeasure.*
   :width: 100%
   :align: center
   :alt: Plant with interval measure sensor
   :figclass: align-center

Simulating this system, we get the following results for estimated speed:

.. plot:: ../plots/PwIM.py
   :class: interactive

As we saw in our previous discussion of the
:ref:`interval-measurement` technique, the quality of the estimated
signal is severely reduced if we reduce the number of teeth.  The
previous plot used a sensor with 200 teeth per rotation.  If we plot
the shaft angle with respect to the bracketing teeth angles, we see
that the shaft cannot move very far without triggering a measurement:

.. plot:: ../plots/PwIM_gaps.py
   :class: interactive

On the other hand, if we reduce the number of teeth per rotation down
to 20, we get the following results:

.. plot:: ../plots/PwIMf.py
   :class: interactive

Plotting the teeth angles that bracket the current shaft angle, we see
that crossings are far less frequent, and, as a result the accuracy of
the measurement is greatly reduced:

.. plot:: ../plots/PwIMf_gaps.py
   :class: interactive

Again, we can validate our component-oriented sensor implementations
by noting that these results are identical to the results presented
during our previous discussion of the :ref:`interval-measurement`
technique.

Pulse Counter
^^^^^^^^^^^^^

Finally, we have the :ref:`pulse-counting` approach.  Again, the
estimation technique can be wrapped in a reusable component that
extends from the base ``Sensor`` model:

.. literalinclude:: /ModelicaByExample/Components/SpeedMeasurement/Components/PulseCounter.mo
   :language: modelica

and then added to our overall ``Plant`` model:

.. literalinclude:: /ModelicaByExample/Components/SpeedMeasurement/Examples/PlantWithPulseCounter.mo
   :language: modelica

The resulting system, when rendered, looks like this:

.. figure:: /ModelicaByExample/Components/SpeedMeasurement/Examples/PlantWithPulseCounter.*
   :width: 100%
   :align: center
   :alt: Plant with pulse counter sensor
   :figclass: align-center

Simulating the system, we see that the results are the same as in our
previous discussion of :ref:`pulse-counting`:

.. plot:: ../plots/PwPC.py
   :class: interactive

Conclusion
^^^^^^^^^^

The discussion of :ref:`speed-measurement` earlier in the book went
into great detail about the various measurement techniques that can be
used to estimate the speed of a rotating shaft.  The purpose of this
section was not to revisit that discussion but rather to show how the
estimation techniques presented earlier can benefit greatly from the
component-oriented features in Modelica.  As we have seen, all of
these techniques can be nicely encapsulated in component models.  The
result is that utilizing these different estimation techniques is now
as easy as dragging and dropping one of these sensor models into a
system and attaching it to the rotating element whose speed you wish
to measure.
