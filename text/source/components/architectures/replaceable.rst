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
also helps avoid potential errors by eliminating one potentially error
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

where ``variableName`` is again the name of the variable being
declared, ``DefaultType`` represents the type of ``variableName`` of
the type of ``variableName`` is never changed and ``ConstrainingType``
indicates the constraining type.  As mentioned previously, any new
type attributed to the ``variableName`` variable must be
plug-compatible with the constraining type.  But, of course, the
``DefaultType`` must **also** be plug-compatible with the constraining
type.

.. topic::

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

If we wanted to extend this model but use a different model for the
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
that variables constraining type**.

The syntax of a ``redeclare`` statement is really exactly the same as
a normal declaration except that it is preceded by the ``redeclare``
keyword.  Obviously, any variable that is redeclared had to be
declared in the first place (*i.e.,* you cannot use this syntax to
declare a variable, only to *redeclare* it).

It is **very important** to understand that when you redeclare a
component, the new redeclaration supercedes the previous one.  For
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

Earlier when discussing :ref:`arrays-of-components`, we made the point
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

Choices
^^^^^^^

* replaceable
* redeclare
* constrainedby

* modifications

* choices

* type redefinition (modifications)
