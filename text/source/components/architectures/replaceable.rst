.. _configuration-management:

Configuration Management
------------------------

``replaceable``
^^^^^^^^^^^^^^^

What really enables the configuration management features in Modelica
is the ``replaceable`` keyword.  It is used to identify components in
a model whose type can be changed (or "redeclared") in the future.
One way to think about ``replaceable`` is that it allows the model
developer to define "slots" in the model that are either "blank" to
begin with (where an interface model is the original type in the
declaration) or at least "configurable".

The advantage of using the ``replaceable`` keyword is that it allows
new models to be created without having to reconnect anything.  This
not only imposes a structural framework on future models (to ensure
naming conventions are followed, interfaces are common, *etc.*), it
also helps avoid potential errors by eliminating an error
prone task from the model development process, *i.e.,* creating
connections.

To make a component replaceable the only thing that is necessary
is to add the ``replaceable`` keyword in front of the declaration,
*i.e.,*

.. code-block:: modelica

    replaceable DeclaredType variableName;

where ``DeclaredType`` is the initial type for a variable named
``variableName``.  In such a declaration, the ``variableName``
variable can be given a new type (we will discuss how very shortly).
But any new type used for ``variableName`` must be
:ref:`plug-compatible <plug-compatibility>`.

.. _constrainedby:

``constrainedby``
^^^^^^^^^^^^^^^^^

As we just mentioned, by default the new type of any ``replaceable``
component must be plug-compatible with the initial type.  But this
doesn't have to be the case.  As our earlier discussion on
:ref:`constraining-types` pointed out, it is possible to specify both
a default type for the variable to have and a separate constraining
type that any new type needs to be compatible with.

Specifying an alternative constraining type requires the use of the
``constrainedby`` keyword.  The syntax for using the ``constrainedby``
keyword is:

.. code-block:: modelica

    replaceable DefaultType variableName constrainedby ConstrainingType;

.. todo:: this sentence needs re-writing.

where ``variableName`` is again the name of the variable being
declared, ``DefaultType`` represents the type of ``variableName`` of
the type of ``variableName`` is never changed and ``ConstrainingType``
indicates the constraining type.  As mentioned previously, any new
type attributed to the ``variableName`` variable must be
plug-compatible with the constraining type.  But, of course, the
``DefaultType`` must **also** be plug-compatible with the constraining
type.

.. topic:: ``constrainedby`` vs. ``extends``

    Older versions of Modelica didn't include the ``constrainedby``
    keyword.  Instead, the ``extends`` keyword was used instead.  But
    it was felt that inheritance and plug-compatibility were distinct
    enough that a separate keyword would be less confusing.  So don't
    be confused if you are looking at Modelica code and the keyword
    ``extends`` is used where you would expect to see the
    ``constrainedby`` keyword (*i.e.,* following a ``replaceable``
    declaration).

``redeclare``
^^^^^^^^^^^^^

So now we know that by using the ``replaceable`` keyword, we can
change the type of a variable in the future.  Changing the type is
called "redeclaring" the variable (*i.e.,* to have a different type).
For this reason, it is fitting that the keyword used to indicate a
redeclaration is ``redeclare``.  Assume that we have the following
system model:

.. code-block:: modelica

    model System
      Plant plant;
      Controller controller;
      Actuator actuator;
      replaceable Sensor sensor;
    end System;

In this ``System`` model, only the sensor is ``replaceable``.  So the
types of each of the other subsystems (*i.e.,* ``plant``,
``controller`` and ``actuator``) cannot be changed.

If we wanted to extend this model, but use a different model for the
``sensor`` subsystem, we would use the ``redeclare`` keyword as
follows:

.. code-block:: modelica

    model SystemVariation
      extends System(
        redeclare CheapSensor sensor
      );
    end SystemVariation;

What this tells the Modelica compiler is that in the context of the
``SystemVariation`` model, the ``sensor`` subsystem should be an
instance of the ``CheapSensor`` model, not the (otherwise default)
``Sensor`` model.  **However**, the ``CheapSensor`` model (or any
other type chosen during redeclaration) **must be plug-compatible with
that variable's constraining type**.

The syntax of a ``redeclare`` statement is really exactly the same as
a normal declaration except that it is preceded by the ``redeclare``
keyword.  Obviously, any variable that is redeclared had to be
declared in the first place (*i.e.,* you cannot use this syntax to
declare a variable, only to *redeclare* it).

It is **very important** to understand that when you redeclare a
component, the new redeclaration supersedes the previous one.  For
example, after the following redeclaration:

.. code-block:: modelica

    redeclare CheapSensor sensor;

the ``sensor`` component **is no longer replaceable**.  This is
because the new declaration doesn't include the ``replaceable``
keyword.  As a result, it is as if it was never there.  If we wanted
the component to remain replaceable, the redeclaration would need to be:

.. code-block:: modelica

    redeclare replaceable CheapSensor sensor;

Furthermore, if we choose to make the redeclared variable replaceable,
we also have the option **to redeclare the constraining type**, like
this:

.. code-block:: modelica

    redeclare replaceable CheapSensor sensor constrainedby NewSensorType;

However, the original constraining type still plays a role even in
this case because the type ``NewSensorType`` must be plug-compatible
with the original constraining type.  In the terminology of
programming languages, we can narrow the type (reducing the set of
things that are plug-compatible), but we can never widen the type
(which would make things that were previously not plug-compatible
now plug-compatible).

Earlier, when discussing :ref:`arrays-of-components`, we made the point
that it was not possible to redeclare individual elements in arrays.
Instead, a redeclaration must be applied to the entire array.  In
other words, if we declare something initially as:

.. code-block:: modelica

    replaceable Sensor sensors[5];

It is then possible to redeclare the array, *e.g.,*

.. code-block:: modelica

    redeclare CheapSensor sensors[5];

But the important point is that the redeclaration affects every
element of the ``sensors`` array.  There is no way to redeclare only
one element.

Modifications
^^^^^^^^^^^^^

.. index:: modifications; in the context of redeclarations

One important complexity that comes with replaceability is what
happens to modifications in the case of a redeclaration.  To
understand the issue, consider the following example.

.. code-block:: modelica

    replaceable SampleHoldSensor sensor(sample_rate=0.01)
      constrainedby Sensor;

Now, what happens if we were to redeclare the ``sensor`` as follows:

.. code-block:: modelica

    redeclare IdealSensor sensor;

Is the value for ``sample_rate`` lost?  We would hope so since the
``IdealSensor`` model probably doesn't have a ``parameter`` called
``sample_rate`` to set.

But let's consider another case:

.. code-block:: modelica

    replaceable Resistor R1(R=100);

Now imagine we had another resistor model, ``SensitiveResistor`` that
was plug-compatible with ``Resistor`` (*i.e.,* it had a ``parameter``
called ``R``) but included an additional parameter, ``dRdT``,
indicating the (linear) sensitivity of the resistance to temperature.
We might want to do something like this:

.. code-block:: modelica

    redeclare SensitiveResistor R1(dRdT=0.1);

What happens to ``R`` in this case?  In this case, we would actually
like to preserve the value of ``R`` so it persists across the
redeclaration.  Otherwise, we'd need to restate it all the time,
*i.e.,*

.. code-block:: modelica

    redeclare SensitiveResistor R1(R=100, dRdT=0.1);

and this would violate the DRY principle.  The result would be that
any change in the original value of ``R`` would be overridden by any
redeclarations.

So, we've seen two cases valid use cases.  In one case, we don't want
a modification to persist following a redeclaration and in the other
we would like the modification to persist.  Fortunately, Modelica has
a way to express both of these.  The normal Modelica semantics take
care of the first case.  If we redeclare something, all modifications
from the original declaration are erased.  But what about the second
case?  In that case, the solution is to **apply the modifications to
the constraining type**.  So for our resistor example, our original
declaration would need to be:

.. code-block:: modelica

    replaceable Resistor R1 constrainedby Resistor(R=100);

Here we explicitly list both the default type ``Resistor`` and the
constraining type ``Resistor(R=100)`` separately because the
constraining type now includes a modification.  By moving the
modification to the constraining type, **that modification will
automatically be applied to both the original declaration and any
subsequent redeclarations**.  So in this case, the resistor instance
``R1`` will have an ``R`` value of ``100`` even though the
modification isn't directly applied after the variable name.  But
furthermore, if we perform the redeclaration we discussed previously, *i.e.,*

.. code-block:: modelica

    redeclare SensitiveResistor R1(dRdT=0.1);

the ``R=100`` modification will automatically be applied here as well.

In summary, if you want a modification to apply only to a specific
declaration and not in subsequent redeclarations, apply it after the
variable name.  If you want it to persist through subsequent
redeclarations, apply it to the constraining type.

.. todo:: has definition vs. declaration been discussed somwehere?

Redefinitions
^^^^^^^^^^^^^

It turns out that the ``replaceable`` keyword can also be associated
with *definitions*, not just declarations.  The main use of this
feature is to be able to change the type of **multiple** components at
once.  For example, imagine a circuit model with several different
resistor components:

.. code-block:: modelica

    model Circuit
      Resistor R1(R=100);
      Resistor R2(R=150);
      Resistor R4(R=45);
      Resistor R5(R=90);
      // ...
    equation
      connect(R1.p, R2.n);
      connect(R1.n, R3.p);
      // ...
    end Circuit;

Now imagine we wanted one version of this model with ordinary
``Resistor`` components and the other where each resistor was an
instance of the ``SensitiveResistor`` model.  One way we could achieve
this would be to define our ``Circuit`` as follows:

.. code-block:: modelica

    model Circuit
      replaceable Resistor R1 constrainedby Resistor(R=100);
      replaceable Resistor R2 constrainedby Resistor(R=150);
      replaceable Resistor R4 constrainedby Resistor(R=45);
      replaceable Resistor R5 constrainedby Resistor(R=90);
      // ...
    equation
      connect(R1.p, R2.n);
      connect(R1.n, R3.p);
      // ...
    end Circuit;

But in that case, our circuit with ``SensitiveResistor`` components
would be defined as:

.. code-block:: modelica

    model SensitiveCircuit
      extends Circuit(
        redeclare SensitiveResistor R1(dRdT=0.1),
        redeclare SensitiveResistor R2(dRdT=0.1),
        redeclare SensitiveResistor R3(dRdT=0.1),
        redeclare SensitiveResistor R4(dRdT=0.1)
      );
    end SensitiveCircuit;

Note that we don't have to specify resistance values because the
modifications that set the resistance were applied to the constraining
type in our ``Circuit`` model.  But, it is a bit tedious that we have
to change each individual resistor and specify ``dRdT`` over and over
again even though they are all the same value.  However, Modelica
gives us a way to do them all at once.  The first
step is to define a local type within the model like this:

.. code-block:: modelica

    model Circuit
      model ResistorModel = Resistor;
      ResistorModel R1(R=100);
      ResistorModel R2(R=150);
      ResistorModel R4(R=45);
      ResistorModel R5(R=90);
      // ...
    equation
      connect(R1.p, R2.n);
      connect(R1.n, R3.p);
      // ...
    end Circuit;

What this does is establish ``ResistorModel`` as a kind of alias for
``Resistor``.  This by itself doesn't help us with changing the type
of each resistor easily.  But making ``ResistorModel`` ``replaceable``
does:

.. code-block:: modelica

    model Circuit
      replaceable model ResistorModel = Resistor;
      ResistorModel R1(R=100);
      ResistorModel R2(R=150);
      ResistorModel R4(R=45);
      ResistorModel R5(R=90);
      // ...
    equation
      connect(R1.p, R2.n);
      connect(R1.n, R3.p);
      // ...
    end Circuit;

If our ``Circuit`` is defined in this way, we can create the
``SensitiveCircuit`` model as follows:

.. code-block:: modelica

    model SensitiveCircuit
      extends Circuit(
        redeclare ResistorModel = SensitiveResistor(dRdT=0.1)
      );
    end SensitiveCircuit;

All our resistor components are still of type ``ResistorModel``, we
didn't have to redeclare any of them.  What we **did do** was redefine
what a ``ResistorModel`` is by changing its definition to
``SensitiveResistor(dRdT=0.1)``.  Note that the modification
``dRdT=0.1`` will be applied to all components of type
``ResistorModel``.  Technically, this isn't a redeclaration of a
component's type, it is a redefinition of a type.  But we reuse the
``redeclare`` keyword.

Interestingly, with these redefinitions we still have the notion of a
default type and a constraining type.  The general syntax for a
redefinable type is:

.. code-block:: modelica

    replaceable model AliasType = DefaultType(...) constrainedby ConstrainingType(...);

Just as with a replaceable component, any modifications associated
with the default type, ``DefaultType``, are only applied in the case
that ``AliasType`` isn't redefined.  But, any modification associated
with the constraining type, ``ConstrainingType``, will persist across
redefinitions.  Furthermore, ``AliasType`` must always be plug
compatible with the constraining type.

Although this aspect of the language is less frequently used, compared
to replaceable components, it can save time and help avoid errors in
some cases.

Choices
^^^^^^^

This section has focused on configuration management and we've learned
that the constraining type controls what options are available when
doing a ``redeclare``.  If a single model developer creates an
architecture and all compatible implementations, then they have a very
good sense of what potential configurations will satisfy the
constraining types involved.

But what if you are using an architecture developed by someone else?
How can you determine what possibilities exist?  Fortunately, the
Modelica specification includes a few standard annotations that help
address this issue.

``choices``
~~~~~~~~~~~

The ``choices`` annotation allows the original model developer to
associate a list of modifications with a given declaration.  The very
simplest use case for this could be to specify values for a given
parameter:

.. code-block:: modelica

    parameter Modelica.SIunits.Density rho
      annotation(choices(choice=1.1455 "Air",
                         choice=992.2 "Water"));

In this case, the model developer has listed several possible values
that the user might want to give to the ``rho`` parameter.  Each
choice is a modification to be applied to the ``rho`` variable.  This
information is commonly used by graphical Modelica tools to provide
users with intelligent choices.

This feature can just as easily be used in the context of
configuration management.  Consider the following example:

.. code-block:: modelica

    replaceable IdealSensor sensor constrainedby Sensor
      annotation(
        choices(
          choice=redeclare SampleHoldSensor sensor
                 "Sample and hold sensor",
          choice=redeclare IdealSensor sensor
                 "An ideal sensor"));

Again, the model developer is embedding a set of possible
modifications along with the declaration.  These ``choice`` values can
also be used by graphical tools to provide a reasonable set of choices
when configuring a system.

``choicesAllMatching``
~~~~~~~~~~~~~~~~~~~~~~

But one problem here is that it is not only tedious to have to
explicitly list all of these choices, but the set of possibilities
might change.  After all, other developers (besides the original model
developer) might come along and create implementations that satisfy a
given constraining type.  How about giving users the option of seeing
**all** legal options when configuring their system?

Fortunately, Modelica includes just such an annotation.  It is the
``choicesAllMatching`` annotation.  By setting the value of this
annotation to ``true`` on a given declaration (or ``replaceable``
definition), this instructs the tool to find all possible legal
options and present them through the user interface.  For example,

.. code-block:: modelica

    replaceable IdealSensor sensor constrainedby Sensor
      annotation(choicesAllMatching=true);

By adding this annotation, the tool knows to find all legal
redeclarations when a user is reconfiguring their models through the
graphical user interface.  This can increase the usability of
architecture based models **enormously** because it presents users
with the full range of options at their disposal with trivial effort
on the part of the model developer.

Conclusion
^^^^^^^^^^

In this section, we've discussed the configuration management features
in Modelica.  As with other aspects of the Modelica language, the
goals here are the same: promote reuse, increase productivity and
ensure correctness.  Modelica includes many powerful options for
redeclaring components and redefining types.  By combining this with
the ``choicesAllMatching`` annotation, models can be built to support
a large combination of possible configurations using clearly defined
choice points.
