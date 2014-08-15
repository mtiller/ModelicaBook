.. _arrays-of-components:

Arrays of Component
-------------------

.. index:: arrays; of components

Several of the examples in this chapter used arrays of components.
Arrays of components are useful when the user might want to "scale"
the number of components used using a parameter (as we saw in our
discussions of both :ref:`distributed-heat-transfer` and
:ref:`harmonic-motion`).

Creating an array of components is really no different from creating
an array of scalar variables like we did in our previous discussion on
:ref:`vectors-and-arrays`.  As we can see in this example,

.. literalinclude:: /ModelicaByExample/Subsystems/HeatTransfer/Components/Rod.mo
   :language: modelica
   :lines: 23-32

the syntax for creating an array of components is identical to the
syntax used for other types.  All that is required is to follow the
name of the variable being declared by a set of dimensions.

However, unlike scalars, components have other declarations inside
them.  So whenever an array of components is created, the structure of
that component is replicated for each component in the array.
Modelica imposes a restriction that in every array, every element must
be the same type.  This may seem obvious, but that is partly because
we haven't discussed ``replaceable`` components yet.  We'll learn more
about ``replaceable`` components in the next chapter when we talk
about Modelica's :ref:`configuration-management` features.  But for
now we will simply point out that it is not possible to ``redeclare``
only one element in an array.

.. index:: ! slicing

As we touched on briefly in our discussion of :ref:`harmonic-motion`,
when we make :ref:`sub-modifications` to arrays of components, each
variable inside the component is implicitly treated as an array.  For
example, consider the following ``record`` definition:

.. code-block:: modelica

    record Point
      Real x;
      Real y;
      Real z;
    end Point;

If we were to declare an array of ``Point`` components, *e.g.,*
``Point p[5]``, any reference to ``p.x`` is treated as an array of 5
``Real`` variables, *i.e.,* ``p[1].x``, ``p[2].x``, ``p[3].x``,
``p[4].x`` and ``p[5].x``.  This is called *slicing*.  The bottom line
is that if we leave off a subscript (*e.g.,* ``p.x``), it gets "pushed
to the end" (or more technically, it is left "unbound" and can be
"bound" later).  Also, if a subscript is supplied as a range (*e.g.,*
``:``, ``1:end``, ``2:3``), then the expression resolves to a subset of
the array corresponding to the indices in the range.  All of this
holds even for arrays of components containing arrays of components
and so on.

The following example, demonstrates some of the more common cases:

.. code-block:: modelica

    record Vector3D
      Real x[3];
    end Vector3D;

    model ArrayExample
      Point p[2];
      Point q[2,3];
      Vector3D v[4];
    equation
      p.x = {1, 2}; // p[1].x = 1, p[2].x = 2
      q[:,3].y = {4, 5}; // q[1,3].y = 4, q[2, 3].y = 5;
      q.x = [1, 2, 3; 4, 5, 6] // q[1,1].x = 1,
                               // q[1,2].x = 2,
			       // q[2,3].x = 6
      v.x[1] = {1, 2, 3, 4}; // v[1].x[1] = 1, v[2].x[1] = 2,
                             // v[3].x[1] = 3, v[4].x[1] = 4
      v[:].x[1] = {1, 2, 3, 4}; // v[1].x[1] = 1, v[2].x[1] = 2,
                                // v[3].x[1] = 3, v[4].x[1] = 4
      v[2:3].x[1] = {2, 3}; // v[2].x[1] = 2, v[3].x[1] = 3
      v[1].x = {1, 2, 3};   // v[1].x[1] = 1, v[1].x[2] = 2,
                            // v[1].x[3] = 3
    end ArrayExample;

