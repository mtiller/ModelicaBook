.. _graphical-annos:

Graphical Annotations
=====================

Although this section appears in the chapter on :ref:`connectors`,
this topic applies to graphical annotations associated with model
definitions in general.  So the information presented here will be a
useful reference with respect to many aspects of Modelica.

Graphical Layers
----------------

When describing the appearance of a Modelica entity, there are two
different representations to choose from.  One is called the "icon"
representation and the other is called the "diagram" representation.
In Modelica, the icon representation is used when
viewing something from the "outside".  Generally, the icon includes
some distinctive visual representation along with additional
information about that entity added via :ref:`substitutions` (which we
will be covering shortly).

The "diagram" representation, on the other hand, is used to represent
the view of a component from the "inside".  The diagram representation
is generally used to include additional graphical documentation about
the Modelica component that would be too detailed for the "icon" view.

A definition's graphical appearance in an "icon" layer is specified by
the ``Icon`` annotation (briefly touched on in our
:ref:`graphical-connectors` discussion earlier).  Not surprisingly, a
definition's graphical appearance in the "diagram" layer is specified
by the ``Diagram`` annotation.  Both of these are annotations that
appear directly in the definition and are not associated with existing
elements like declarations or ``extends`` clauses.

Generally speaking, most definitions include an "icon" representation,
but only a few bother to include a "diagram" representation.  However,
it turns out that despite being rendered in different contexts, the
specification of graphical appearance is identical between them.

.. topic:: Use of ``Icon`` in examples

    For the remainder of the book, we will show examples of graphical
    annotations using the ``Icon`` annotation.  These examples could
    equally be applied to a ``Diagram`` annotation, but since the
    ``Icon`` annotation is more common, all further examples
    regarding graphical annotations will appear exclusively in the
    context of the ``Icon`` annotation.

Common Graphical Definitions
----------------------------

The following definitions will be referenced throughout this section:

.. code-block:: modelica

    type DrawingUnit = Real(final unit="mm");
    type Point = DrawingUnit[2] "{x, y}";
    type Extent = Point[2]
      "Defines a rectangular area {{x1, y1}, {x2, y2}}"; 
    type Color = Integer[3](min=0, max=255) "RGB representation";
    constant Color Black = zeros(3);
    type LinePattern = enumeration(None, Solid, Dash, Dot, DashDot, DashDotDot);
    type FillPattern = enumeration(None, Solid, Horizontal, Vertical,
                                   Cross, Forward, Backward,
				   CrossDiag, HorizontalCylinder,
				   VerticalCylinder, Sphere);
    type BorderPattern = enumeration(None, Raised, Sunken, Engraved);
    type Smooth = enumeration(None, Bezier); 
    type Arrow = enumeration(None, Open, Filled, Half);
    type TextStyle = enumeration(Bold, Italic, UnderLine);
    type TextAlignment = enumeration(Left, Center, Right);

    record FilledShape "Style attributes for filled shapes"
      Color lineColor = Black "Color of border line";
      Color fillColor = Black "Interior fill color";
      LinePattern pattern = LinePattern.Solid "Border line pattern";
      FillPattern fillPattern = FillPattern.None "Interior fill pattern";
      DrawingUnit lineThickness = 0.25 "Line thickness";
    end FilledShape; 

In addition, many of the annotations we will be discussing include a
set of common elements represented by the following ``record``
definition:

.. code-block:: modelica

    partial record GraphicItem
      Boolean visible = true;
      Point origin = {0, 0};
      Real rotation(quantity="angle", unit="deg")=0;
    end GraphicItem; 

For annotations representing graphical elements, we will extend from
this ``GraphicItem`` to make the presence of these common elements
explicitly clear.

``Icon`` and ``Diagram`` Annotations
------------------------------------

The elements that should appear in the icon layer of a model are
described by the following data:

.. code-block:: modelica

    record Icon "Representation of the icon layer"
      CoordinateSystem coordinateSystem(extent = {{-100, -100}, {100, 100}});
      GraphicItem[:] graphics;
    end Icon;

where the coordinate system data is defined as:

.. code-block:: modelica

    record CoordinateSystem
      Extent extent;
      Boolean preserveAspectRatio=true;
      Real initialScale = 0.1;
      DrawingUnit grid[2];
    end CoordinateSystem; 

In other words, the ``Icon`` annotation includes information about the
coordinate system contained in the definition of ``coordinateSystem``
and it also includes a list of graphical items stored in
``graphics``.  The definition of the ``Diagram`` annotation is identical:

.. code-block:: modelica

    record Diagram "Representation of the diagram layer"
      CoordinateSystem coordinateSystem(extent = {{-100, -100}, {100, 100}});
      GraphicItem[:] graphics;
    end Diagram; 

Graphical Items
---------------

There are a number of different graphical items that are defined in
the specification that can be used in constructing the ``graphics``
vector associated with either the ``Icon`` or ``Diagram``
annotations.  Their definitions are presented here for reference.

.. _line-anno:

``Line``
^^^^^^^^

.. code-block:: modelica

    record Line
      extends GraphicItem;
      Point points[:];
      Color color = Black;
      LinePattern pattern = LinePattern.Solid;
      DrawingUnit thickness = 0.25;
      Arrow arrow[2] = {Arrow.None, Arrow.None} "{start arrow, end arrow}";
      DrawingUnit arrowSize=3;
      Smooth smooth = Smooth.None "Spline";
    end Line; 

.. _polygon-anno:

``Polygon``
^^^^^^^^^^^

.. code-block:: modelica

    record Polygon
      extends GraphicItem;
      extends FilledShape;
      Point points[:];
      Smooth smooth = Smooth.None "Spline outline";
    end Polygon; 

.. _rect-anno:

``Rectangle``
^^^^^^^^^^^^^

.. code-block:: modelica

    record Rectangle
      extends GraphicItem;
      extends FilledShape;
      BorderPattern borderPattern = BorderPattern.None;
      Extent extent;
      DrawingUnit radius = 0 "Corner radius";
    end Rectangle;

.. _ellipse-anno:

``Ellipse``
^^^^^^^^^^^

.. code-block:: modelica

    record Ellipse
      extends GraphicItem;
      extends FilledShape;
      Extent extent;
      Real startAngle(quantity="angle", unit="deg")=0;
      Real endAngle(quantity="angle", unit="deg")=360;
    end Ellipse; 

.. _text-anno:

``Text``
^^^^^^^^

.. code-block:: modelica

    record Text
      extends GraphicItem;
      extends FilledShape;
      Extent extent;
      String textString;
      Real fontSize = 0 "unit pt";
      String fontName;
      TextStyle textStyle[:];
      Color textColor=lineColor;
      TextAlignment horizontalAlignment = TextAlignment.Center;
    end Text; 

.. _bitmap-anno:

``Bitmap``
^^^^^^^^^^

.. code-block:: modelica

    record Bitmap
      extends GraphicItem;
      Extent extent;
      String fileName "Name of bitmap file";
      String imageSource "Base64 representation of bitmap";
    end Bitmap; 

Inheriting Graphical Annotations
--------------------------------

When one model definition inherits from another, the graphical
annotations are inherited by default.  However, this behavior can be
controlled by annotating the ``extends`` clause with the following
data (for the icon and diagram layers, respectively):

.. code-block:: modelica

    record IconMap
      Extent extent = {{0, 0}, {0, 0}};
      Boolean primitivesVisible = true;
    end IconMap;

    record DiagramMap
      Extent extent = {{0, 0}, {0, 0}};
      Boolean primitivesVisible = true;
    end DiagramMap; 

In both cases, the ``extent`` data allows the location of the
inherited graphical elements to be adjusted.  Setting
``primitivesVisible`` to ``false`` will suppress the rendering of
inherited graphical elements.

.. _substitutions:

Substitutions
-------------

When working with the :ref:`text-anno` annotation, the ``textString``
field can contain substitution patterns.  The following substitution
patterns are supported:

    * ``%name`` - This pattern will be replaced by the name of the
      instance of the given definition.
    * ``%class`` - This pattern will be replaced by the name of this
      definition.
    * ``%<name>`` where ``<name>`` is a parameter name - This pattern
      will be replaced by the **value** of the named parameter.
    * ``%%`` - This pattern will be replaced by ``%``.

Putting It All Together
-----------------------

Having discussed all these aspects of graphical annotations, let us
review the icon definitions presented during our discussion of
:ref:`graphical-connectors`.

.. literalinclude:: /ModelicaByExample/Connectors/Graphics.mo
   :language: modelica
   :lines: 7-29

Here we see the ``annotation`` associated with the ``PositivePin``
definition is a model annotation.  Furthermore, we can see the
``Icon`` data associated with this annotation includes a list of
graphical items.  The first graphical item is an :ref:`ellipse-anno`
annotation.  That is followed by two :ref:`rect-anno` annotations and
finally a :ref:`text-anno` (which also makes use of the
:ref:`substitutions` we discussed earlier).

Note how the data being presented in this ``annotation`` lines up with
the data described in the record definitions we discussed earlier.
