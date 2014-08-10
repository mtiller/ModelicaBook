.. _synchronous-systems:

Synchronous Systems
-------------------

In Modelica version 3.3, new features were introduced to address
concerns about non-deterministic discrete behavior [Elmqvist]_.  In
this section, we'll present some examples of how these issues
presented themselves before version 3.3 and show how these new
features help address them.

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
   :class: interactive

Simulating this model, we get the following trajectories for ``x`` and
``y``.  Of course, they look identical.  But in order to really
determine if there are any differences between them, let's plot the
error value, ``e``:

.. plot:: ../plots/SIS_e.py
   :class: interactive

Now, let's consider the following model:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/SynchronousSystems/SynchronizedSampling.mo
   :language: modelica
   :lines: 2-

Here, we set up a common signal that triggers the assignment to both
variables.  In this way, we can be sure that when the ``tick`` signal
becomes true, both ``x`` and ``y`` will be assigned a value.  Sure
enough, if we run this model, we see that the error is always zero:

.. plot:: ../plots/SSS.py
   :class: interactive

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
   :class: interactive

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

Note that we have done away with the ``0.1``.  We no longer see any
mention of the clock interval as a real number.  Instead, we use the
``Clock`` operator to the define clock interval for ``x`` as a
rational number.  This is important because it allows us to do exact
comparisons between clocks.  This brings us to the next line:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/SynchronousSystems/SamplingWithClocks.mo
   :language: modelica
   :lines: 6

Again, we see the rational representation of the clock.  What this
means, in practice, is that the Modelica compiler can know for certain
that these two clocks, ``x`` and ``y``, are identical because they are
defined in terms of integer quantities which allow exact comparison.
This means that when executing a simulation, we can know for certain
that these two clocks will trigger simultaneously.

If we wanted to create a clock that was exactly two times slower than
``x``, we can use the ``subSample`` operator to accomplish this.  We
see this in the definition of ``z``:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/SynchronousSystems/SamplingWithClocks.mo
   :language: modelica
   :lines: 7

Behind the scenes, the Modelica compiler can reason about these
clocks.  It knows that the ``x`` clock triggers every
:math:`\frac{1}{10}` of a second.  Using the information provided by
the ``subSample`` operator the Modelica compiler can therefore deduce
that ``z`` triggers every :math:`\frac{2}{10}` of a second.
Conceptually, this means that ``z`` could also have been defined as:

.. code-block:: modelica

  z = sample(time, Clock(2,10));

But by defining ``z`` using the ``subSample`` operator and defining it
with respect to ``x`` we ensure that ``z`` is always triggering at
half the frequency of ``x`` regardless of how ``x`` is defined.

In a similar way, we can define another clock, ``w`` that triggers 3 times more
frequently than ``x`` by using the ``superSample`` operator:

.. literalinclude:: /ModelicaByExample/DiscreteBehavior/SynchronousSystems/SamplingWithClocks.mo
   :language: modelica
   :lines: 8

Again, we could have defined ``w`` directly using ``sample`` with:

.. code-block:: modelica

  w = sample(time, Clock(1,30));

But by using ``superSample``, we can ensure that ``w`` is always
sampling three times faster than ``x`` and six times faster than ``z``
(since ``z`` is also defined with respect to ``x``).

The synchronous clock features in Modelica are relatively new.  As
such, they are not yet supported by all Modelica compilers.  To learn
more about these synchronous features and their applications see
[Elmqvist]_ and/or the Modelica Specification, version 3.3 or later.

.. [Elmqvist] "Fundamentals of Synchronous Control in Modelica",
	      Hilding Elmqvist, Martin Otter and Sven-Erik Mattsson
	      http://www.ep.liu.se/ecp/076/001/ecp12076001.pdf
