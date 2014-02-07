.. _synchronous-systems:

Synchronous Systems
-------------------

.. todo:: I cannot get to the page containing this text - is there a link missing?

In Modelica version 3.3, new features were introduced to address
concerns about non-deterministic discrete behavior.  In this section,
we'll present some examples of how these issues presented themselves
before version 3.3 and show how these new features help address them.

To start, consider the following model:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/SynchronousSystems/IndependentSampling.mo
   :language: modelica
   :lines: 2-

If you look carefully, you will see that ``x`` and ``y`` are both
computed at discrete times.  Furthermore, they are both sampled
initially at the start of the simulation and then again every 0.1
seconds.  But the question is, are they really identical?  To help
address this question, we include the variable ``e`` which measures
the difference between them.

.. plot:: ../plots/SIS.py
   :include-source: no


Simulating this model, we get the following trajectories for ``x`` and
``y``.  Of course, they look identical.  But in order to really
determine if there are any differences between them, let's plot the
error value, ``e``:

.. plot:: ../plots/SIS_e.py
   :include-source: no

Now, let's consider the following model:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/SynchronousSystems/SynchronizedSampling.mo
   :language: modelica
   :lines: 2-

Here, we set up a common signal that triggers the assignment to both
variables.  In this way, we can be sure that when the ``tick`` signal
becomes true, both ``x`` and ``y`` will be assigned a value.  Sure
enough, if we run this model, we see that the error is always zero:

.. plot:: ../plots/SSS.py
   :include-source: no

This kind of approach, where each signal is sampled based on a common
"tick" (or clock), is a good way to avoid determinism issues.  However,
what about cases where you have one signal that samples at a higher
rate than another, but you know that at certain times they should be
sampled together?  Consider the following example:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/SynchronousSystems/SubsamplingWithIntegers.mo
   :language: modelica
   :lines: 2-

In this case, the variable ``tick`` is a counter.  Every time it
changes, we update the values of ``x`` and ``y``.  So this much is
identical to the previous models.  However, we added a third signal,
``z``, that is sampled only when the value of ``tick`` is odd.  So
``x`` and ``y`` are sampled twice as often.  But every time ``z`` is
updated, we can be sure that ``x`` and ``y`` are updated at exactly
the same time.  Simulating this model gives us:

.. plot:: ../plots/SSI.py
   :include-source: no

This is the approach taken in Modelica prior to version 3.3.  But
version 3.3 introduced some new features that allow us to more easily
express these situations.

Consider the following model:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/SynchronousSystems/SamplingWithClocks.mo
   :language: modelica
   :lines: 2-

Now, instead of relying on a ``when`` statement, we use an enhanced
version of the ``sample`` function where the first argument is an
expression to evaluate to determine the sampled value and the second
argument is used to tell us when to evaluate it.  Let's work through
these lines one by one and discuss them.  First we have:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/SynchronousSystems/SamplingWithClocks.mo
   :language: modelica
   :lines: 5

.. todo::

  Finish this explanation after checking on the semantics of Clock

.. todo::

  Cite Hilding's paper for detailed discussion of synchronous
  features.
