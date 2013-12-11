.. _speed-measurement:


Speed Measurement
-----------------

Baseline System
^^^^^^^^^^^^^^^

There are many applications where we need to model the interaction
between continuous behavior and discrete behavior.  For this section,
we'll look at techniques used to measure the speed of a rotating
shaft.  For our discussion here, we will reuse the :ref:`mechincal
example <mech-example>` we discussed previously in our discussion of
:ref:`basic-equations`:

.. literalinclude:: /ModelicaByExample/BasicEquations/RotationalSMD/SecondOrderSystem.mo
   :language: modelica
   :lines: 2-

Recall the solution for this model looks like this:

.. plot:: ../plots/SOSIP.py
   :include-source: no

In this case, we are simply plotting the solution that we computed.
But in a real system, we can't directly know the rotational velocity
of a shaft.  Instead, we have to measure it.  But measurement
introduces error and each measurement techniques introduce different
kinds of errors.  In this section, we'll look at how we can model
different kinds of measurement techniques.

Sample and Hold
^^^^^^^^^^^^^^^

The first type of measurement we will examine is a sample and hold
approach to measurement.  Some speed sensors have circuits for
measuring the rotational speed of the system.  But instead of
providing a continuous value for the speed, they sample it at a given
point in time and then store it somewhere.  This is called "sample and
hold".  The following model demonstrates how to implement and sample
and hold approach to measuring the angular velocity ``omega1``:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/SpeedMeasurement/SampleAndHold.mo
   :language: modelica
   :lines: 2-

.. plot:: ../plots/SampleAndHold.py
   :include-source: no

