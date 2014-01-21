.. _record-def:

Record Definitions
==================

Although we haven't seen any yet, Modelica includes a ``record``
type.  This ``record`` type is very similar to a ``connector`` because it
doesn't include any equations.  However, it also differs from a
``connector`` in significant ways as well.  In this section, we will
discuss how a ``record`` is defined in preparation for using them to
explain our next topic, :ref:`graphical-annos`.

Earlier in this chapter, we explained that a ``connector`` describes
information that is exchanged information between components.  In
fact, the way that components interact with each other is by having
their connectors connected together.  In other words, a connector is a
point of interaction between components.

A ``record``, on the other hand, is more general and ordinary.  A
record can be thought of simply as a means to **group** information
together.

Syntax
------

The syntax for a ``record`` is the same as for a ``connector``:

.. code-block:: modelica

    connector RecordName "Description of the record"
      // Declarations for record variables
    end RecordName;

However, certain qualifiers that are used within a ``connector``
(*e.g.,* ``flow``, ``input`` and ``output``) don't make sense within a
``record``.  Like a ``connector``, a ``record`` cannot include
behavior (*i.e.,* ``equation`` or ``algorithm`` sections).
