.. index:: ! record

.. _record-def:

Record Definitions
==================

Earlier, we introduced the idea of a ``model`` definition.  Although
we haven't seen any yet, Modelica also includes a ``record`` type.  A
``record`` can have variables, just like a ``model``, but it is not
allowed to include equations.  Records are primarily used to group
data together.  But as we will see shortly, they are also very useful
in describing the data associated with :ref:`annotations`.

Syntax
------

The ``record`` definition looks essentially like a ``model``
definition, but without any equations:

.. code-block:: modelica

    record RecordName "Description of the record"
      // Declarations for record variables
    end RecordName;

As with a ``model``, the definition starts and ends with the name of
the record being defined.  An explanation of the ``record`` can be
included as a string after the name.  All the variables associated
with the record are declared within the ``record`` definition.

The following are all examples of ``record`` definitions:

.. code-block:: modelica

    record Vector "A vector in 3D space"
      Real x;
      Real y;
      Real z;
    end Vector;

    record Complex "Representation of a complex number"
      Real re "Real component";
      Real im "Imaginary component";
    end Complex;

Record Constructors
-------------------

.. index:: ! record constructor

Now that we know how to define a ``record``, we need to know how to
create one.  If we are declaring a variable that happens to be a
``record``, the declaration itself will create an instance of the
``record`` and we can specify the values of variables inside the
record using modifications, *e.g.*,

.. code-block:: modelica

    parameter Vector v(x=1.0, y=2.0, z=0.0);

But there are some cases where we might want to create an instance of
a ``record`` that isn't a variable (*e.g.*, to use in an expression,
pass as an argument to a function or use in a modification).  For each
``record`` definition, a function is automatically generated with the
**same name** as the ``record``.  This function is called the "record
constructor".  The record constructor has input arguments that match
the variables inside the ``record`` definition and returns an instance
of that ``record``.  So in the case of the ``Vector`` definition
above, we could also initialize a ``parameter`` using the record
constructor as follows:

.. code-block:: modelica

    parameter Vector v = Vector(x=1.0, y=2.0, z=0.0);

In this case, the value for ``v`` comes from the **expression**
``Vector(x=1.0, y=2.0, z=0.0)`` which is a call to the record
constructor.
