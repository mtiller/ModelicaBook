.. index:: ! record

.. _record-def:

Record Definitions
==================

Earlier, we introduced the idea of a ``model`` definition.  Although
we haven't seen any yet, Modelica includes a ``record`` type.  A
``record`` can have variables, just like a ``model``, but it is not
allowed to include equations.  Records are primarily used to group
data together.  But as we will see shortly, they are also very useful
in describing the data associated with :ref:`annotations`.

Syntax
------

The ``record`` definition looks essentially like a ``model``
definition but without any equations:

.. code-block:: modelica

    record RecordName "Description of the record"
      // Declarations for record variables
    end RecordName;

As with a ``model``, the definition starts (and ends) with the name of
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

.. todo:: I need to fill this in

