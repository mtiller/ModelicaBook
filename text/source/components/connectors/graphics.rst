.. _graphical-connectors:

Graphical Connectors
====================

Text vs. Graphics
-----------------

Until now, we've discussed Modelica as a purely textual language.  But
the reality is that Modelica models are primarily built
**graphically**.  From this point on, graphics will play a greater and
greater role in the way we visualize complex Modelica models.

This visualization starts with the connectors.  The textual component
of the Modelica models will always be present.  Variables and
equations will always be declared as we've shown already, in textual
form.  But as we will repeatedly see as we move forward, the
``annotation`` feature in Modelica can be used to associate a
graphical appearance with many different entities in Modelica.

The first kind of graphical association we will introduce will be the
graphics associated with a ``connector``.  More specifically, we'll
introduce how to associate graphics with the definition of a
``connector``.  These graphics will then be used whenever the
connector is instantiated in a diagram (something we'll discuss in
greater detail when we discuss :ref:`components`).

Icon Annotations
----------------

.. index:: annotations; Icon
.. index:: icons; associating with definitions

When we associate an annotation with a definition, we place it in the
definition, but do not associate it with any declarations or other
entities in the definition.  Instead, it is just another element of
the definition.  To demonstrate this, consider the following
electrical pin connector definitions:

.. literalinclude:: /ModelicaByExample/Connectors/Graphics.mo
   :language: modelica

Note the length of each of these definitions.  The length is due
almost entirely to the annotations present in these definitions.
Apart from the annotations, the ``PositivePin`` and ``NegativePin``
definitions are are identical to the ``Electrical`` connector
definition presented in the discussion on :ref:`simple-domains`.

The reason we've chosen to define two electrical pin connectors is so
that they can be made graphically distinct.  An instance of the
``PositivePin`` connector looks like:

.. figure:: ../../_static/Icons/ModelicaByExample.Connectors.Graphics.PositivePin.*
   :width: 30%
   :align: center
   :alt: Icon of Positive Pin
   :figclass: align-center icon

while an instance of ``NegativePin`` looks like:

.. figure:: ../../_static/Icons/ModelicaByExample.Connectors.Graphics.NegativePin.*
   :width: 30%
   :align: center
   :alt: Icon of Negative Pin
   :figclass: align-center icon

Let's look in greater detail at the ``Icon`` annotation in the
``PositivePin`` definition:

.. literalinclude:: /ModelicaByExample/Connectors/Graphics.mo
   :language: modelica
   :lines: 7-29

We will be discussing :ref:`graphical-annos` shortly.  But let's take a
quick look at what is going on in these definitions.  We can see that
the ``Icon`` annotation contains another variable ``graphics``.  The
``graphics`` variable is assigned a vector of graphical elements.  We
see that this vector graphical elements includes an ``Ellipse`` (used
to render the circle in the icon), two ``Rectangle`` elements (used to
render the "+" sign) and a ``Text`` element.  Note the ``textString``
field in the ``Text`` element contains ``"%name"``.  There are a
number of substitution patterns that can appear in a graphical
annotation.  This particular one will be filled in with the instance
name whenever a variable is declared with the type ``PositivePin``.
So, for example, the following declarations:

.. code-block:: modelica

    PositivePin p;

would be rendered graphically with ``%name`` replaced with ``p``.  In
this way, the textual names assigned to connectors in a diagram always
match the name of the underlying connector declarations in a model.

:ref:`graphical-annos` will be reviewed in detail later in this
chapter and we will see many more uses of them as we transition from
strictly textual representations of models to implementations that
incorporate graphical rendering as well.
