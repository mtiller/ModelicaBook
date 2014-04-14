.. _distributed-heat-transfer:

Spatially Distributed Heat Transfer
-----------------------------------

Our next example of creating reusable subsystems will introduce a
slight twist.  In this section we will not only demonstrate how to
create a reusable subsystem model, as in the previous examples from
this chapter, but that subsystem model will use an array of
**component** instances where the size of that array can be used to
control the spatial resolution of the results.

Flat System
^^^^^^^^^^^

Let's start, as usual, with a flat system level model like the one
shown below:

.. image:: /ModelicaByExample/Subsystems/HeatTransfer/Examples/FlatRod.*
   :width: 100%
   :align: center
   :alt: Flat version of our heat transfer system

This model consists of a collection of thermal capacitances with
thermal conductors in between them.  In this case, there are 3 thermal
capacitances and 5 thermal conductors.  On the left side, heat is
applied to the system and on the right side a temperature sensor
measures how the temperature of the rightmost thermal capacitance
changes.

When implemented in Modelica, the model looks like this:

.. literalinclude:: /ModelicaByExample/Subsystems/HeatTransfer/Examples/FlatRod.mo
   :language: modelica

Simulating this system, we can see the temperature response of the
rightmost thermal capacitance in the following plot:

.. plot:: ../plots/FR.py
   :class: interactive

Segmented Rod Subsystem
^^^^^^^^^^^^^^^^^^^^^^^

.. todo:: N not being rendered correctly

In our flat system model, we have 3 thermal capacitances and 5
conductances.  This configuration represents a rod that has been
divided into 3 equal segments and the conductance that occurs between
those segments as well as between each segment and some ambient
conditions.  In theory, we can divide a rod into :math:`N` equal
segments with :math:`N-1` conduction paths between them and :math:`N`
conduction paths between each segment and the ambient conditions.

Our particular configuration was for :math:`N=3`.  But we can create a
subsystem model where :math:`N` is a parameter of the subsystem.  In
other words, we can create a subsystem model that is divided into
:math:`N` equal segments.  But to do so, we cannot simply drag and
drop the capacitances into the model and connect them with
conductances because we don't know the exact number.

Instead, we'll use an array **of components** to represent this
collection of capacitances and conductances.  The resulting ``Rod``
model can be written in Modelica as follows:

.. literalinclude:: /ModelicaByExample/Subsystems/HeatTransfer/Components/Rod.mo
   :language: modelica
   :lines: 1-45,129

There are several interesting things to note about this model.  First,
the number of segments the rod will be divided into is represented by
the ``n`` parameter:

.. literalinclude:: /ModelicaByExample/Subsystems/HeatTransfer/Components/Rod.mo
   :language: modelica
   :lines: 5

The parameter ``n`` is then used in the following declarations to
specify the number of capacitance and conductance elements in the rod:

.. literalinclude:: /ModelicaByExample/Subsystems/HeatTransfer/Components/Rod.mo
   :language: modelica
   :lines: 23-32

Note that if we wish to apply a modification, *e.g.,* ``G=G_rod`` to
every component in an array of components, we can use the ``each``
qualifier on the modification.  We'll discuss the ``each`` qualifier
and how to apply modifications to arrays of components later in this
chapter in the section on :ref:`sub-modifications`.

Now that we've declared our component arrays, we can then wire
together the capacitances and conductances using ``for`` loops in an
``equation`` section:

.. literalinclude:: /ModelicaByExample/Subsystems/HeatTransfer/Components/Rod.mo
   :language: modelica
   :lines: 34-43

We also need to connect the ends of the rod to the external connectors
so that the rod can be connected to other models:

.. literalinclude:: /ModelicaByExample/Subsystems/HeatTransfer/Components/Rod.mo
   :language: modelica
   :lines: 44-45

In this way, we are able to create a segmented rod model with an
arbitrary number of equally divided segments.

Spatial Resolution
^^^^^^^^^^^^^^^^^^

Now that we have our parameterized ``Rod`` model, we can look at how
the number of segments in the rod impacts the response we see.
Ultimately, what we should see is that as the number of segments gets
larger (or, as the size of the segments gets smaller), we should
converge on a solution.

We'll start by considering a model where ``n=3``, *i.e.,*

.. literalinclude:: /ModelicaByExample/Subsystems/HeatTransfer/Examples/ThreeSegmentRod.mo
   :language: modelica
   :emphasize-lines: 14

We can then extend this model to create additional models with more
segments, *e.g.,*

.. literalinclude:: /ModelicaByExample/Subsystems/HeatTransfer/Examples/SixSegmentRod.mo
   :language: modelica

.. literalinclude:: /ModelicaByExample/Subsystems/HeatTransfer/Examples/TenSegmentRod.mo
   :language: modelica

.. literalinclude:: /ModelicaByExample/Subsystems/HeatTransfer/Examples/OneHundredSegmentRod.mo
   :language: modelica

.. literalinclude:: /ModelicaByExample/Subsystems/HeatTransfer/Examples/TwoHundredSegmentRod.mo
   :language: modelica

If we simulate all of these cases, we see that as ``n`` gets larger,
they appear to converge to a common solution and that ``n=10`` seems
to provide a reasonable solution without the need to introduce a large
number of superfluous components:

.. todo::

   Something is wrong with this plot.  I can't believe I would have
   made a mistake here.  I need to check with Dymola.

.. plot:: ../plots/SegC.py
   :class: interactive

Conclusion
^^^^^^^^^^

In this section, we've seen how we can build assemblies of arbitrary
size using arrays of components and ``for`` loops to connect them
together.  
