.. _ref-pkg-contents:

Referencing Package Contents
----------------------------

Now that we've covered :ref:`organizing-content`, we'll discuss how to
access that content across different packages.  Let's consider the
following example:

.. literalinclude:: /ModelicaByExample/PackageExamples/RLC.mo
   :language: modelica

As we learned in the previous section, the very first line,

.. literalinclude:: /ModelicaByExample/PackageExamples/RLC.mo
   :language: modelica
   :lines: 1

tells us that the ``RLC`` model is contained within the
``ModelicaByExample.PackageExamples`` package.  As with the previous
example, we are going to make use of the Modelica ``package`` system
to allow us to avoid defining types directly in our model.  In this
way, we define the types once in one package and then we can reuse
them in many places simply by referencing them.

Unlike the previous example in this chapter, we don't define any types
in this example.  Instead, we rely on types that are defined in the
:ref:`msl`.  The :ref:`msl` contains many useful types, models,
constants, *etc*.  For this example, we'll just utilize a few of
them.  These types can be easily recognized because they start with
``Modelica.`` in the name of the type.

We look more closely at the :ref:`lookup-rules` later in this chapter.
For now, it is sufficient to say that all the types starting with
``Modelica.`` exist within the ``Modelica`` package.  In this case,
all types start with ``Modelica.SIunits``.  ``SIunits`` is a package
within the ``Modelica`` package.  The purpose of the ``SIunits``
package is to store type definitions that conform to ISO standard
quantities and units.

.. index:: fully qualified name

As can be seen in the example code, these types are referenced by
their "fully qualified name".  That means that type name starts with
the name of a top-level package (a package that is not contained
within another package).  Each ``.`` in the name represents a new
child package.  The last name in the sequence identifies that actual
type being referenced.

In this case, we are using 5 different types from within the
``Modelica.SIunits`` package: ``Voltage``, ``Inductance``,
``Resistance``, ``Capacitance`` and ``Current``.  These types provide
information about the units for each of these types, limitations on
the values of these types (*e.g.*, a capacitance cannot be less than
zero), *etc*.  They are defined in the :ref:`msl` as follows:

.. code-block:: modelica

    // Base Definitions
    type ElectricPotential = Real(final quantity="ElectricPotential",
                                  final unit="V");
    type ElectricCurrent = Real(final quantity="ElectricCurrent",
                                final unit="A");

    // The types referenced in our example
    type Voltage = ElectricPotential;
    type Inductance = Real(final quantity="Inductance",
                           final unit="H");
    type Resistance = Real(final quantity="Resistance",
                           final unit="Ohm");
    type Capacitance = Real(final quantity="Capacitance",
                            final unit="F", min=0);
    type Current = ElectricCurrent;

Apart from providing better documentation, there is an immediate
benefit to associating such types with variables and that is because
it enables unit consistency checking of the equations.  For example,
note the following equation from this example:

.. code-block:: modelica

  i_R = V/R;

Clearly, this is a statement of Ohm's law.  But what if we made a
mistake and accidentally wrote:

.. code-block:: modelica

  i_R = V*R;

Syntactically speaking, this equation is perfectly legal.
Furthermore, if the variable ``i_R``, ``V`` and ``R`` were all
declared to have the type ``Real``, there would be no issue with this
equation.  However, because we know (from the type definitions) that
these variables represent a current, a voltage and a resistance,
respectively, a Modelica compiler is able to determine (in a
completely automatic way using the definitions shown previously) that
the left and right hand sides of this equation are inconsistent with
respect to physical units.  In other words, by associating a physical
type with variables it is possible to detect modeling errors,
automatically.
