
.. _variables:

Variables
---------

As we saw in the previous section, a model definition typically
contains variable declarations.  The basic syntax for a variable
declaration is simply the "type" of the variable (which will be
discussed shortly in the section on :ref:`builtin-types`) followed by
the name of the variable, *e.g.*, ``Real x;``.  Variables sharing the
same type can be grouped together using the following syntax: ``Real
x, y;``

.. _variability:

Variability
^^^^^^^^^^^

.. index:: ! parameter

By default, variable declared inside a model are assumed to be
continuous variables.  That means that their value can change at any
time (or be constantly changing).  However, as first saw in the
section :ref:`getting-physical`, it is also possible to add the
``parameter`` qualifier in front of a variable declaration and to
indicate that the variable is known *a priori*.  You can think of a
parameter as "input data" to the model that is constant with respect
to time.

.. index:: ! constant

Closely related to the ``parameter`` qualifier is the ``constant``
qualifier.  When placed in front of a variable declaration, the
``constant`` qualifier indicates also implies that the value of the
variable is known *a priori* and is constant with respect to time.
The distinction between the two lies in the fact that a ``parameter``
value can be changed from one simulation to the next whereas the value
of a ``constant`` cannot be changed once the model is compiled.  The
use of ``constant`` by a model developer ensures that end users are
not given the option to make changes to the ``constant``.

.. index:: discrete

Another qualifier that can be placed in front of a variable
declaration is the ``discrete`` qualifier.  We have not yet shown any
example where the ``discrete`` qualifier would be relevant.  However,
it is included now for completeness since it is the last remaining
variability qualifier.

.. _builtin-types:

Built-In Types
^^^^^^^^^^^^^^

.. index:: ! Real

Many of the examples so far referenced the ``Real`` type when
declaring variables.  As the name suggests, ``Real`` is used to
represented real values variables.  However, ``Real`` is just one of
the four built-in types in Modelica.

.. index:: ! Integer
.. index:: ! Boolean
.. index:: ! String

Another of the built-in types is the ``Integer`` type.  This type is
used to represent integer values and is often used in conjunction with
array types which will be covered in future section titled
:ref:`vectors-and-arrays`.  The remaining built-in types are
``Boolean`` (used to represent values that can be either ``true`` or
``false``) and ``String`` (used for representing character strings).

Each of the built-in types restricts the possible values that a
variable can have.  Obviously, an ``Integer`` variable cannot have the
value ``2.5``, a ``Boolean`` or ``String`` cannot be ``7`` and a
``Real`` can't be ``"Hello"``.

.. _derived-types:

Derived Types
^^^^^^^^^^^^^

.. index:: ! derived types

As we saw in the previous examples that introduced
:ref:`physical-types`, it is possible to "specialize" the built-in
types.  This feature is used mainly to modify the values associated
with :ref:`attributes` like ``unit``.  The general syntax for creating
derived types is:

.. index:: ! type

.. code-block:: modelica

   type NewTypeName = BaseTypeName(/* attributes to be modified */);

Frequently, the ``BaseTypeName`` will be one of the built-in types
(*e.g.*, ``Real``).  But it can also be another derived type.  This
means that multiple levels of specialization can be supported, *e.g.*,

.. code-block:: modelica

   type Temperature = Real(unit="K"); // Could be a temperature difference
   type AbsoluteTemperature = Temperature(min=0); // Must be positive

.. _enumerations:

Enumerations
^^^^^^^^^^^^

.. index:: ! enumeration

.. todo:: We need an example that uses enumerations.  Explain
	  enumerations here (once we have an example)

There are two built-in enumeration types.  The first of these is
``AssertionLevel`` and it is defined as follows:

.. code-block:: modelica

   type AssertionLevel = enumeration(warning, error);

.. todo:: Need to add ``assert`` to the ``Lotka-Volterra`` examples somewhere!

.. index:: ! assert
.. index:: ! AssertionLevel
.. index:: ! assertion levels

The ``AssertionLevel`` attribute is used in conjunction with the
``assert`` function which was presented in our discussion of
:ref:`lotka-volterra-systems`.  In our previous discussion, only two
arguments were passed to assert.  The first was a conditional
expression that we wish to assert should always be true.  The second
was a string that represents the error message to be used should the
assertion be violated (*i.e.*, if the conditional expression becomes
false).  However, there is a *third* **optional** argument to the
``assert`` function of type ``AssertionLevel``.  If no value for the
third argument is provided, the default value is
``AssertionLevel.error``.

During simulation, the simulation environment will generally attempt,
by various means (*e.g.*, tightening tolerances, taking smaller time
steps), to find a solution trajectory that does not violate the
assertion.  However, if it cannot find a trajectory that avoids the
assertion, the value of the third argument to ``assert`` determines
how the simulation environment should respond to the assertion
violation.  If the third argument is ``AssertionLevel.error``, then
the simulation will terminate if it cannot avoid the assertion
violation.  On the other hand, if the value of the third argument is
``AssertionLevel.warning``, then the simulation will simply generate a
diagnostic error message (*i.e.*, the second argument) and
**continue** the simulation.

The other built-in enumeration is ``StateSelect`` and it is defined as
follows:

.. code-block:: modelica

   type StateSelect = enumeration(never, avoid, default, prefer, always);

.. todo:: Add a reference to whatever future section will discuss
	  state selection.

.. _attributes:

Attributes
^^^^^^^^^^

.. index:: ! attributes

So far in this chapter we have mentioned attributes (*e.g.*, ``unit``)
but we haven't discussed them in detail. For example, *which*
attributes are present on a given variable?  This depends on the
built-in type that it is derived from.  The following table introduces
all the possible attributes indicating their types (*i.e.*, what type
of value can be given for that attribute), which types they can be
associated with and finally a brief description of the attribute:

.. index:: ! quantity attribute
.. index:: start attribute
.. index:: ! fixed attribute
.. index:: ! min attribute
.. index:: ! max attribute
.. index:: ! unit attribute
.. index:: ! displayUnit attribute
.. index:: ! nominal attribute
.. index:: ! stateSelect attribute

.. todo:: Get descriptions from the specification

| Attribute name | Type | Supporting Types | Default | Description |
| ``quantity`` | ``String`` | RIBS | ``""`` | |
| ``start`` | T | RIBS | | |
| ``fixed`` | ``Boolean`` | RIB | | |
| ``min`` | T | RI | | |
| ``max`` | T | RI | | |
| ``unit`` | ``String`` | R | | |
| ``displayUnit`` | ``String`` | R | | |
| ``nominal`` | ``Real`` | R | | |
| ``stateSelect`` | ``StateSelect`` | R | | |

It is worth noting that :ref:`derived-types` retain the attributes of
the built-in type that they are ultimately derived from.

Modifications
^^^^^^^^^^^^^

.. index:: ! modifications
.. index:: modification, extends
.. index:: modification, attribute
.. index:: modification, components

.. index:: attribute modification

Equations
---------

.. index:: ! der
.. index:: ! state-space form
