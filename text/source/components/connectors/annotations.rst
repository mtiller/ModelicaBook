.. _graphical-annos:

Graphical Annotations
=====================

Although this section appears in the chapter on :ref:`connectors`,
this topic applies to graphical annotations associated with other
definitions in Modelica (*e.g.,* ``model`` definitions).  So the
information presented here will be a useful reference with respect to
many aspects of Modelica.

.. todo::

    Need to make sure we formally introduce annotations and their
    structure at some point (before functions, I suppose)

Graphical Layers
----------------

When describing the appearance of a Modelica entity, there are two
different representations to choose from.  One is called the "icon"
representation and the other is called the "diagram" representation.
In Modelica, the icon representation is the representation used when
viewing something from the "outside".  Generally, the icon includes
some distinctive visual representation along with additional
information about that entity added via :ref:`substitutions` (which we
will be covering shortly).

The "diagram" representation, on the other hand, is used to represent
the view of a component from the "inside".  The diagram representation
is generally used to include additional graphical documentation about
the Modelica component that would too details for the "icon" view.

A definition's graphical appearance in an "icon" layer is specified by
the ``Icon`` annotation (briefly touched on in our
:ref:`graphical-connectors` discussion earlier).  Not surprisingly, a
definition's graphical appearance in the "diagram" layer is specified
by the ``Diagram`` annotation.  Both of these are annotations that
appear directly in the definition and not associated with existing
elements like declarations or ``extends`` clauses.

Generally speaking, most definitions include an "icon" representation
but only a few bother to include a "diagram" representation.  However,
it turns out that despite being rendered in different contexts, the
specification of graphical appearance is identical between them.

.. topic:: Use of ``Icon`` in examples

    For the remainder of the book, we will show examples of graphical
    annotations using the ``Icon`` annotation.  These examples could
    equally be applied to a ``Diagram`` annotation but since the
    ``Icon`` annotation is more commonly all further examples
    regarding graphical annotations will appear exclusively in the
    context of the ``Icon`` annotation.

Coordinate System
-----------------

As we shall see shortly, the appearance of a entities defined in
Modelica is described by a list of drawing primitives.  But before we
can list the drawing primitives that should be used to represent an
entities graphical appearance, we must first define a coordinate
system in which to place these entities.

The coordinate system is specified as:


Each Modelica definition can define its graphical appearance from to
different perspectives.  The first perspective is the appearance of
that entity when viewed from the outside.  This is called the entity's
"icon".  It is used, for example, when dragging a model into a
schematic.  In that context, the model is one object (potentially
among many) in the schematic and its icon is rendered to represent it
in the schematic.

The other perspective is the entity's "diagram".  This representation
indicates how the 


* Graphical annotations (both Icon and Diagram)

* Point out this isn't really specific to connectors and that we'll be
  seeing more of this in the components section as well.

* Inheritance

.. _substitutions:

Substitutions
-------------
* Substitutions (%name)

