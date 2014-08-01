
.. _variables:

Variables
---------

As we saw in the previous section, a model definition typically
contains variable declarations.  The basic syntax for a variable
declaration is simply the "type" of the variable (which will be
discussed shortly in the section on :ref:`builtin-types`) followed by
the name of the variable, *e.g.*,

.. code-block:: modelica

    Real x;

Variables sharing the same type can be grouped together using the
following syntax:

.. code-block:: modelica

    Real x, y;

A declaration can also be followed by a description, e.g.:

.. code-block:: modelica

    Real alpha "angular acceleration";

.. _variability:

Variability
^^^^^^^^^^^

.. index:: ! parameter

.. _parameters:

Parameters
~~~~~~~~~~

By default, variables declared inside a model are assumed to be
continuous variables (variables whose solution is generally smooth, but
which may also include discontinuities).  However, as we first saw in
the section titled :ref:`getting-physical`, it is also possible to add
the ``parameter`` qualifier in front of a variable declaration and to
indicate that the variable is known *a priori*.  You can think of a
parameter as "input data" to the model that is constant with respect
to time.

.. index:: ! constant

Constants
~~~~~~~~~

Closely related to the ``parameter`` qualifier is the ``constant``
qualifier.  When placed in front of a variable declaration, the
``constant`` qualifier also implies that the value of the variable is
known *a priori* and is constant with respect to time.  The
distinction between the two lies in the fact that a ``parameter``
value can be changed from one simulation to the next whereas the value
of a ``constant`` cannot be changed once the model is compiled.  The
use of ``constant`` by a model developer ensures that end users are
not given the option to make changes to the ``constant``.  A
``constant`` is frequently used to represent physical quantities like
:math:`\pi` or the Earth's gravitational acceleration, which can be
assumed constant for most engineering simulations.

Discrete Variables
~~~~~~~~~~~~~~~~~~

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
represent real valued variables (which will generally be translated
into floating point representations by a Modelica compiler).  However,
``Real`` is just one of the four built-in types in Modelica.

.. index:: ! Integer
.. index:: ! Boolean
.. index:: ! String

Another of the built-in types is the ``Integer`` type.  This type is
used to represent integer values.  ``Integer`` variables have many
uses including representing the size of arrays (this use case will be
discussed shortly in an upcoming section on
:ref:`vectors-and-arrays`).

The remaining built-in types are ``Boolean`` (used to represent values
that can be either ``true`` or ``false``) and ``String`` (used for
representing character strings).

Each of the built-in types restricts the possible values that a
variable can have.  Obviously, an ``Integer`` variable cannot have the
value ``2.5``, a ``Boolean`` or ``String`` cannot be ``7`` and a
``Real`` variable cannot have the value ``"Hello"``.

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

An ``enumeration`` type is very similar to the ``Integer`` type.  An
``enumeration`` is typically used to define a type that can take on
only a limited set of specific values.  In fact, enumerations are not
strictly necessary in the language.  Their values can always be
represented by integers.  However, the ``enumeration`` type is safer
and more readable than an ``Integer``.

There are two built-in enumeration types.  The first of these is
``AssertionLevel`` and it is defined as follows:

.. index:: ! AssertionLevel
.. index:: ! assertion levels

.. code-block:: modelica

   type AssertionLevel = enumeration(warning, error);

The significance of these values will be discussed in a forthcoming
section on :ref:`assertions`.

The other built-in enumeration is ``StateSelect`` and it is defined as
follows:

.. code-block:: modelica

   type StateSelect = enumeration(never, avoid, default, prefer, always);

.. _attributes:

Attributes
^^^^^^^^^^

.. index:: ! attributes

So far in this chapter we have mentioned attributes (*e.g.*, ``unit``),
but we haven't discussed them in detail. For example, *which*
attributes are present on a given variable?  This depends on the type
of the variable (and which built-in and derived types it is based on).  The
following table introduces all the possible attributes indicating
their types (*i.e.*, what type of value can be given for that
attribute), which types they can be associated with and finally a
brief description of the attribute:

.. index:: ! quantity attribute
.. index:: start attribute
.. index:: ! fixed attribute
.. index:: ! min attribute
.. index:: ! max attribute
.. index:: ! unit attribute
.. index:: ! displayUnit attribute
.. index:: ! nominal attribute
.. index:: ! stateSelect attribute

.. _fixed-attribute:

Attributes of ``Real``
~~~~~~~~~~~~~~~~~~~~~~

``quantity``
    A textual description of what the variable represents

    **Default**: ``""``

    **Type**: ``String``

``start``
    The ``start`` attribute has many uses.  The main purpose of the
    ``start`` attribute (as discussed extensively in the section on
    :ref:`initialization`) is to provide "fallback" initial conditions
    for state variables (see ``fixed`` attribute for more details).

    The ``start`` attribute may also be used as an initial guess if
    the variable has been chosen as an iteration variable.

    Finally, if a ``parameter`` doesn't have an explicit value
    specified, the value of the ``start`` attribute will be used as the
    default value for the ``parameter``.

    **Default**: ``0.0``

    **Type**: ``Real``

``fixed``
    The ``fixed`` attribute changes the way the ``start`` attribute is
    used when the ``start`` attribute is used as an initial
    condition.  Normally, the ``start`` attribute is considered a
    "fallback" initial condition and only used if there are
    insufficient initial conditions explicitly specified in the ``initial
    equation`` sections.  However, if the ``fixed`` attribute is set
    to ``true``, then the ``start`` attribute is treated as if it was
    used as an explicit ``initial equation`` (*i.e.,* it is no longer
    used as a fallback, but instead treated as a strict initial
    condition).

    Another, more obscure, use of the ``fixed`` attribute is for
    "computed parameters".  In rare cases where a ``parameter`` cannot
    be initialized explicitly, it is possible to provide a general
    equation for the parameter in an ``initial equation`` section.
    But in cases where the ``parameter`` is initialized in this way,
    the ``fixed`` attribute for the parameter variable must be set to
    ``false``.

    **Default**: ``false`` (except for ``parameter`` variables, where
    it is ``true`` by default)

    **Type**: ``Real``

``min``
    The ``min`` attribute is used to specify the minimum allowed value
    for a variable.  This attribute can be used by editors and
    compilers in various ways to inform users or developers about
    potentially invalid input data or solutions.

    **Default**: -:math:`\infty`

    **Type**: ``Real``

``max``
    The ``max`` attribute is used to specify the maximum allowed value
    for a variable.  This attribute can be used by editors and
    compilers in various ways to inform users or developers about
    potentially invalid input data or solutions.

    **Default**: :math:`\infty`

    **Type**: ``Real``

``unit``
    As discussed extensively in this chapter, variables can have
    physical units associated with them.  There are rules about how
    these units are expressed, but the net result is that by using the
    ``unit`` attribute it is possible check models to make sure that
    equations are physically consistent.  A value of ``"1"`` indicates
    the value has no physical units.  On the other hand, a value of
    ``""`` (the default value if no value is given) indicates that the
    physical units are simply unspecified.  The difference between
    ``"1"`` and ``""`` is that the former is an explicit statement
    that the quantity is dimensionless (has not units) while the
    latter indicates that the quantity may have physical units but
    they are left unspecified.

    **Default**: ``""`` (*i.e.,* no physical units specified)

    **Type**: ``String``

``displayUnit``
    While the ``unit`` attribute describes what physical units should
    be associated with the value of a variable, the ``displayUnit``
    expresses a preference for what units should be used when
    displaying the value of a variable.  For example, the SI unit for
    pressure is *Pascals*.  However, standard atmospheric pressure is
    101,325 *Pascals*.  When entering, displaying or plotting pressures
    it may be more convenient to use *bars*.

    The ``displayUnit`` attribute doesn't affect the
    value of a variable or the equations used to simulate a model.  It
    only affects the *rendering* of those values by potentially
    transforming them into more convenient units for display.

    **Default**: ``""``

    **Type**: ``String``

``nominal``
    The ``nominal`` attribute is used to specify a nominal value for a
    variable.  This nominal value is generally used in numerical
    calculations to perform various types of scaling used to avoid
    round-off or truncation error.

    **Default**: ``0.0``

    **Type**: ``Real``

``stateSelect``
    The ``stateSelect`` attribute is used as a hint to Modelica
    compilers about whether a given variable should be chosen as a
    state (in cases where there is a choice to be made).  As discussed
    previously in the section on :ref:`enumerations`, the possible
    values for this attribute are ``never``, ``avoid``, ``default``,
    ``prefer`` and ``always``.

    **Default**: ``default``

    **Type**: ``StateSelect`` (enumeration, see :ref:`enumerations`)

Attributes of ``Integer``
~~~~~~~~~~~~~~~~~~~~~~~~~

``quantity``
    A textual description of what the variable represents

    **Default**: ``""``

    **Type**: ``String``

``start``
    It is worth noting that an ``Integer`` variable can be chosen as a
    state variable or as an iteration variable.  Under these
    circumstances, the ``start`` attribute may be used by a compiler
    in the same was as it is for ``Real`` variables (*see previous
    discussion of* :ref:`fixed-attribute`)

    In the case of a ``parameter``, the ``start`` attribute will (as
    usual) be used as the default value for the ``parameter``.

    **Default**: ``0.0``

    **Type**: ``Integer``

``fixed``
    *see previous discussion of* :ref:`fixed-attribute`

    **Default**: ``false`` (except for ``parameter`` variables, where
    it is ``true`` by default)

    **Type**: ``Boolean``

``min``
    The ``min`` attribute is used to specify the minimum allowed value
    for a variable.  This attribute can be used by editors and
    compilers in various ways to inform users or developers about
    potentially invalid input data or solutions.

    **Default**: -:math:`\infty`

    **Type**: ``Integer``

``max``
    The ``max`` attribute is used to specify the maximum allowed value
    for a variable.  This attribute can be used by editors and
    compilers in various ways to inform users or developers about
    potentially invalid input data or solutions.

    **Default**: :math:`\infty`

    **Type**: ``Integer``


Attributes of ``Boolean``
~~~~~~~~~~~~~~~~~~~~~~~~~

``quantity``
    A textual description of what the variable represents

    **Default**: ``""``

    **Type**: ``String``

``start``
    It is worth noting that an ``Boolean`` variable can be chosen as a
    state variable or as an iteration variable.  Under these
    circumstances, the ``start`` attribute may be used by a compiler
    in the same was as it is for ``Real`` variables (*see previous
    discussion of* :ref:`fixed-attribute`)

    In the case of a ``parameter``, the ``start`` attribute will (as
    usual) be used as the default value for the ``parameter``.

    **Default**: ``0.0``

    **Type**: ``Boolean``

``fixed``
    *see previous discussion of* :ref:`fixed-attribute`

    **Default**: ``false`` (except for ``parameter`` variables, where
    it is ``true`` by default)

    **Type**: ``Boolean``

Attributes of ``String``
~~~~~~~~~~~~~~~~~~~~~~~~

``quantity``
    A textual description of what the variable represents

    **Default**: ``""``

    **Type**: ``String``

``start``
    Technically, a ``String`` could be chosen as a state variable (or
    even an iteration variable), but in practice this never happens.
    So for a ``String`` variable the only practical use of the
    ``start`` attribute is to define the value of a ``parameter``
    (that happens to have the type of ``String``) if no explicit value
    for the parameter is given.

    **Default**: ``""``

    **Type**: ``String``

It is worth noting that :ref:`derived-types` retain the attributes of
the built-in type that they are ultimately derived from.  Also,
although the type of, for example, the ``min`` attribute on a ``Real``
variable is listed having the type ``Real`` it should be pointed out
explicitly that attributes cannot themselves have attributes.  In
other words, the ``start`` attribute doesn't have a ``start``
attribute.

.. _modifications:

Modifications
^^^^^^^^^^^^^

.. index:: ! modifications

So far, we've seen two types of modifications.  The first is when we
change the value of an attribute, *e.g.,*

.. index:: modification, attribute
.. index:: attribute modification

.. code-block:: modelica

   Real x(start=10);

In this case, we are creating a variable ``x`` of type ``Real``.  But
rather than leaving it "as is", we then apply a modification to
``x``.  Specifically, we "reach inside" of ``x`` and change the
``start`` attribute value.  In this example, we are only going one
level into ``x`` to make our modification.  But as we will see in our
next example, it is possible to make modifications at arbitrary
depths.

The other case where we have seen modifications was in the section on
:ref:`avoiding-repetition`.  There we saw modification used in
conjunction with ``extends`` clauses, *e.g.,*

.. index:: modification, extends

.. code-block:: modelica

   extends QuiescentModelWithInheritance(gamma=0.3, delta=0.01);

Here, the modification is applied to elements that were inherited from
the ``QuiescentModelWithInheritance`` model.  As with modifications
to attributes, the element being modified (a model in this case) is
followed by parentheses and inside those parentheses we specify the
modifications we wish to make.

.. index:: modification, hierarchical

It is worth noting that modifications can be nested arbitrarily deep.
For example, imagine we wanted to modify the ``start`` attribute for
the variable ``x`` inherited from the
``QuiescentModelWithInheritance`` model.  In Modelica, such a
modification would be made as follows:

.. code-block:: modelica

   extends QuiescentModelWithInheritance(x(start=5));

Here we first "reach inside" the ``QuiescentModelWithInheritance``
model to modify the contents that we "inherit" from it (``x`` in this
case) and then we "reach inside" ``x`` to modify the value of the
``start`` attribute.

One of the central themes of Modelica is support for reuse and
avoiding the need to "copy and paste" code.  Modifications are
one of the essential features in Modelica that support reuse.  We'll
learn about others in future sections.
