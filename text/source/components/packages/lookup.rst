.. _lookup-rules:

Lookup Rules
------------

Recall the following example from our discussion on
:ref:`organizing-content`:

.. literalinclude:: /ModelicaByExample/PackageExamples/NestedPackages.mo
   :language: modelica

When we discussed :ref:`ref-pkg-contents`, the example that was
presented used fully qualified names for all the types it referenced.
But the example above doesn't.  We see, from the ``LotkaVolterra``
model that the ``Wolves`` type is referenced as:

.. code-block:: modelica

    parameter Types.Wolves y0=10;

And not as:

.. code-block:: modelica

    parameter ModelicaByExample.PackageExamples.NestedPackages.Types.Wolves y0=10;

In other words, we didn't use the fully qualified name.  But the
``LotkaVolterra`` model compiles just fine.  So how is it that the
Modelica compiler knows which definition of ``Wolves`` to use?

.. index:: encapsulated

The answer involves "name lookup" in Modelica.  Name lookup in
Modelica involves searching for the named definition.  Type names in
Modelica are generally qualified (although not necessarily **fully**
qualified) names.  This means they may contain a ``.`` in them,
*e.g.,* ``Modelica.SIunits.Voltage``.  In order to locate the matching
definition associated with a name, the Modelica compiler starts by
looking for the **first** name in the qualified name, *e.g.,*
``Modelica``.  It searches for a matching definition in the following order:

  #. Look for a matching name among builtin types
  #. Look in the current definition for a nested definition with a
     matching name (include inherited definitions)
  #. Look in the current definition for an imported definition with a
     matching name (do not include inherited imports)
  #. Look in the parent package of the current definition for a nested
     definition with a matching name (including inherited definitions)
  #. Look in the parent package for an imported definition with a
     matching name (not including inherited imports)
  #. Look in each successive parent (using the same approach) until
     either:

       * The parent package has the ``encapsulated`` qualifier, in which
         case the search terminates.
       * There are no more parent packages, in which case you search for
         a match among root level packages.

If the given name cannot be found after searching all these locations,
then the search fails and the type cannot be resolved.  If the search
succeeds, then we've located the definition of the **first name** in
the qualified name.  If the name is not qualified (*i.e.,* it does not
have a ``.`` in the name), then we are done.  However, if it does have
other components in the name, these must be nested definitions
contained within the definition returned by the search.  If nested
definitions cannot be found for all remaining components in a
qualified name, then the search fails and the type cannot be resolved.

At first, this might sound very complicated.  However, most of the
time these rules are not very important.  The reason is that, as we
discussed previously, most graphical Modelica environments will use
fully qualified names.  Most type names in Modelica code will either
reference local definitions or will be specified with fully qualified
names.

.. topic:: Duplicate Names

    You should always avoid having nested packages with the same name
    as a top-level package.  The reason this is a problem is that the
    lookup rules search up through the package hierarchy.  As a
    result, they will find the nested definition before the root level
    one.  This means that lookup of fully qualified names (ones that
    are referenced relative to the root of the package tree) will fail
    because they will find the nested definition first.

