.. _propagation:

Propagation
-----------

When building subsystem models, it is extremely common for a subsystem
to contain parameters that it then propagates or cascades down to its
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
in one of two ways.  One way would be to extend the parameterized
model above and include a modification in the ``extends`` statement,
*e.g.,*

.. code-block:: modelica

    model SpecificSMD
      extends SMD(d2=1, c2=5, J2=1,
                  d1=0.5, c1=11, J1=0.4,
                  phi1_init=1);

Note that we did not need to include modifications for the values of
``phi2_init``, ``w1_init`` and ``w2_init``, since those parameters were
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
until the upcoming chapter on :ref:`architectures`.
