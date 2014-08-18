.. _harmonic-motion:

Harmonic Motion of Pendulums
----------------------------

In this section, we will recreate an interesting experiment [Berg]_
involving pendulums.  If we create a series of pendulums with
different natural frequencies and then start them all at the same
position, what we will see is that they will oscillate at different
frequencies.  But if we remove any energy dissipation from the system,
they will eventually all "reunite" at their initial position.

In general, the period between these "reunion" events is the least
common multiple of the periods of all the pendulums in the
system.  We can choose the lengths of the pendulums to achieve a
specific period between these "reunions".

Pendulum Model
^^^^^^^^^^^^^^

In this section, we will use arrays of components to build our
subsystem model just like we did in our
:ref:`distributed-heat-transfer` example.  But before we can create an
array of pendulums, we need to first have a model of a single
pendulum.

.. literalinclude:: /ModelicaByExample/Subsystems/Pendula/Pendulum.mo
   :language: modelica

.. todo:: Need more discussion of the parts here

The components of the pendulum can be rendered as follows:

.. image:: /ModelicaByExample/Subsystems/Pendula/Pendulum.*
   :width: 100%
   :align: center
   :alt: A single pendulum

System Model
^^^^^^^^^^^^

.. todo:: rendering problems follow

Now that we have an individual pendulum model, we can build a system
of pendulums.  If we want a system of :math:`n` pendulums where the
period for a complete cycle of the system is :math:`T` seconds, we
compute the length of the :math:`i^{th}` pendulum as:

.. math::

    l_i = g_n\frac{T}{2 \pi (X+(n-i))}

where :math:`g_n` is Earth's gravitational constant, :math:`n` is the
number of pendulums, :math:`T` is the period of one complete cycle of
the system and :math:`X` is the number of oscillations of the longest
pendulum over :math:`T` seconds.

In Modelica, we could build such a system as follows:

.. literalinclude:: /ModelicaByExample/Subsystems/Pendula/System.mo
   :language: modelica
   :lines: 1-16,19

The following declaration is particularly interesting:

.. literalinclude:: /ModelicaByExample/Subsystems/Pendula/System.mo
   :language: modelica
   :lines: 13

Because ``pendulum`` is an array of ``n`` components, there will be
``n`` values for the ``x``, ``m``, ``phi`` and ``L`` parameters
associated with these pendulums.  For example, if ``n=3``, then the
model will have 3 values for ``x``: ``pendulum[1].x``,
``pendulum[2].x`` and ``pendulum[3].x``.  In the declaration of
``pendulum``, we handle this in different ways for different
parameters.  In the case of ``m``, we give each pendulum the same
value with the modification ``each m=1``.  However, in the case of
``L`` (and ``x``), we supply an array of values, ``L=lengths`` used to
initialize the parameters where the values in the ``lengths`` array
are computed using the equation for pendulum lengths we introduced
earlier.  We will give a more complete discussion on how to apply
modifications to arrays of components :ref:`later in this chapter
<sub-modifications>`.

If we simulate this system, we get the following solution for the
trajectory of each of the pendulums:

.. todo::

    I need to add the results here.  Unfortunately, I cannot get OM to
    simulate this system at the moment.

As we can see from this plot, every 54 seconds all the pendulums
return to their initial position.


.. only:: html

   The results are even more impressive when visualized in three
   dimensions:

    .. raw:: html

        <iframe width="630" height="472"
                src="//www.youtube.com/embed/cc7ajqhfLVM"
		frameborder="0" allowfullscreen>
        </iframe>

Conclusion
^^^^^^^^^^

In this section, we have seen how arrays of components can be used,
declared and modified.  In this particular case, this allows us to
specify the number of pendulums in our system and then simulate them
to observe the peculiar behavior observed when we choose their
lengths according to the equation specified earlier.

.. [Berg] Richard E. Berg, "Pendulum waves: A demonstration of wave
	  motion using pendula" http://dx.doi.org/10.1119/1.16608
