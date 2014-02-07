.. _subsystems:

Subsystems
**********

Examples
========

Review
======

Modifications
^^^^^^^^^^^^^

Previously, we've seen examples of modifications applied to
variables.  In some cases, these modifications are applied to
:ref:`attributes` of built-in types, *e.g.,*

.. code-block:: modelica

    Real x(start=2, min=1);

In other cases, they have been applied to ``model`` instances to
change the values of parameters for that particular instance, *e.g.,*

.. code-block:: modelica

    StepVoltage Vs(V0=0, Vf=24, stepTime=0.5);

But it is also worth pointing out that such modifications can reach
down deeper into the hierarchy than simply one level.  For example,
consider the previous example involving a ``StepVoltage`` component.
We could also have made a modification to the ``min`` attribute
associated with the ``Vf`` parameter in the ``Vs`` instance of the
``StepVoltage`` model as follows:

.. code-block:: modelica

    StepVoltage Vs(V0=0, Vf(min=0), stepTime=0.5);

But what if we wanted to change an attribute of the ``Vf`` parameter
**and** give it a value?  The syntax for such a modification is:

.. code-block:: modelica

    StepVoltage Vs(V0=0, Vf(min=0)=24, stepTime=0.5);

An important case worth discussion, with regards to modifications, is
how modifications are performed on **arrays** of components.  Imagine
we had an array of ``StepVoltage`` components declared as follows:

.. code-block:: modelica

    StepVoltage Vs[5];

This is not only legal Modelica, but it can be useful to represent a
collection of components within a subsystem.  If we want to give the
parameter ``Vf`` a value, we have two choices.  The first is to
specify an array of values, *e.g.,*

.. code-block:: modelica

    StepVoltage Vs[5](Vf={24,26,28,30,32});

This assigns the values in the vector ``{24,26,28,30,32}`` to
``Vs[1].Vf``, ``Vs[2].Vf``, ``Vs[3].Vf``, ``Vs[4].Vf`` and
``Vs[5].Vf``, respectively.  The other choice we have is to give the
same value to every element in the array.  We could use this same
array initialization syntax, *e.g.,*

.. code-block:: modelica

    StepVoltage Vs[5](Vf={24,24,24,24,24});

The problem comes when the number of elements in an array is defined
by a ``parameter``, *e.g.,*

.. code-block:: modelica

    parameter Integer n;
    StepVoltage Vs[n](Vf=/* ??? */);

To address this situation, we could use the :ref:`fill-function`
function:

.. code-block:: modelica

    parameter Integer n;
    StepVoltage Vs[n](Vf=fill(24, n));

This is an acceptable solution.  But imagine if we wanted to modify
both the value of ``Vf`` and the ``min`` attribute inside ``Vf``?
We'd end up with something like this:

.. code-block:: modelica

    parameter Integer n;
    StepVoltage Vs[n](Vf(min=fill(0,n))=fill(24, n));

With nested modifications, this kind of thing can get complicated
quickly.  Fortunately, Modelica includes a feature to deal with such
situations.  By placing the ``each`` keyword in front of a
modification, that modification is applied to every instance, *e.g.,*

.. code-block:: modelica

    parameter Integer n;
    StepVoltage Vs[n](each Vf(min=0)=24);

Propagation
^^^^^^^^^^^

When building subsystem models, it is extremely common for a subsystem
to contain parameters that it then "propagates" down to its
components.  For example, consider the following system model used in
our discussion of :ref:`rotational-components`:

.. code-block:: modelica

    within ModelicaByExample.Components.Rotational.Examples;
    model SMD
      Components.Damper damper2(d=1);
      Components.Ground ground;
      Components.Spring spring2(c=5);
      Components.Inertia inertia2(J=1,
        phi(fixed=true, start=1),
	w(fixed=true, start=0));
      Components.Damper damper1(d=0.2);
      Components.Spring spring1(c=11);
      Components.Inertia inertia1(
	J=0.4,
	phi(fixed=true, start=0),
	w(fixed=true, start=0));
    equation
      // ...
    end SMD;

If we wanted to use this model in different contexts where the values
of the component parameters, like ``d``, might vary, we could make
``d`` a parameter at the subsystem level and then propagate it down
into the hierarchy using a modification.  The result would look
something like this:

.. code-block:: modelica

    within ModelicaByExample.Components.Rotational.Examples;
    model SMD
      import Modelica.SIunits.*;
      parameter RotationalDampingConstant d;
      Components.Damper damper2(d=d);
      // ...

.. index:: ! final

There is one complication here.  It is possible for a user to come
along and change the value of ``damper2.d`` instead of modifying the
``d`` parameter in the ``SMD`` model.  To avoid having the ``d``
parameter and the ``damper2.d`` parameter from getting out of sync
(having different values), we can permanently bind them using the
``final`` qualifier:

.. code-block:: modelica

    within ModelicaByExample.Components.Rotational.Examples;
    model SMD
      import Modelica.SIunits.*;
      parameter RotationalDampingConstant d;
      Components.Damper damper2(final d=d);
      // ...

By adding the ``final`` qualifier, we are indicating that it is no
longer possible to modify the value of ``damper2.d``.  Any
modifications must be made to ``d`` only.

Giving all of the "hard-wired" numerical values in the ``SMD`` model
the same treatment, we would end up with a highly reusable model like
this:

.. code-block:: modelica

    within ModelicaByExample.Components.Rotational.Examples;
    model SMD
      import Modelica.SIunits.*;

      parameter RotationalDampingConstant d1, d2;
      parameter RotationalSpringConstant c1, c2;
      parameter Inertia J1, J2;
      parameter Angle phi1_init=0, phi2_init=0;
      parameter AngularVelocity w1_init=0, w2_init=0;

      Components.Damper damper2(final d=d2);
      Components.Ground ground;
      Components.Spring spring2(final c=c2);
      Components.Inertia inertia2(
        final J=J2,
        phi(fixed=true, final start=phi2_init),
	w(fixed=true, final start=w2_init));
      Components.Damper damper1(final d=d1);
      Components.Spring spring1(final c=c1);
      Components.Inertia inertia1(
	final J=J1,
	phi(fixed=true, final start=phi1_init),
	w(fixed=true, final start=w1_init));
    equation
      // ...
    end SMD;

If we wanted to use a specific set of parameter values, we could do it
in one of two ways.  One way would be to extends the parameterized
model above and include a modification in the ``extends`` statement,
*e.g.,*

.. code-block:: modelica

    model SpecificSMD
      extends SMD(d2=1, c2=5, J2=1,
                  d1=0.5, c1=11, J1=0.4,
                  phi1_init=1);

Note that we did not need to include modifications for the values of
``phi2_init``, ``w1_init`` and ``w2_init`` since those parameters were
declared with default values.  In general, **default values for
parameters should only be used when those defaults are reasonable for
the vast majority of cases**.  The reason for this is that if a
parameter has no default value most Modelica compilers will generate a
warning alerting you that a value is required.  But if a default value
is there, it will silently use the default value.  If that default
value is not reasonable or typical, then you will silently introduce
an unreasonable value into your model.

But returning to the topic of propagation, the other approach that
could be used would be to instantiate an instance of the ``SMD`` model
and use modifications on the declared variable to specify parameter
values, *e.g.,*

.. code-block:: modelica

    SMD mysmd(d2=1, c2=5, J2=1,
              d1=0.5, c1=11, J1=0.4,
              phi1_init=1);

We'll defer the discussion on which of these approaches is better
until upcoming chapter on :ref:`architectures`.
