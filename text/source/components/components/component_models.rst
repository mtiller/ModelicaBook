.. _model-comps:

Component Models
----------------

In this section, we'll summarize how component models are different
from the previous models we've created.  This discussion will be
broken into two parts.  The first part will focus on acausal modeling
and how it provides a framework for schematic-based,
component-oriented modeling where conservation equations are
automatically generated and enforced.  The second part will provide an
overview of how the topics in this chapter impact, mostly
syntactically, the definition of component models.

Acausal Modeling
^^^^^^^^^^^^^^^^

We'll start with a discussion about acausal modeling.  We touched on
this topic very briefly in the chapter on :ref:`connectors`.  Here we
will provide a more comprehensive discussion about acausal modeling.

Composibility
~~~~~~~~~~~~~

There are two very big advantages to acausal modeling.  The first is
composability.  In this context, composability means the ability to
drag, drop and connect component instances in nearly any configuration
we wish without having to concern ourselves with "compatibility".
This is because acausal connectors are designed around the idea of
physical compatibility, not causal compatibility.  This is possible
because acausal connector definitions focus on physical information
exchanged, not the direction that information flows. The result is
that we can create component models around the idea of physical
interactions without requiring any *a priori* knowledge about the
nature (*i.e.,* directionality) of the information exchange.

But there are other implications to this composability.  Not only can
we easily create systems by dragging, dropping and connecting
components.  This kind of acausal composability also makes it easy to
reconfigure systems.  Replacing a voltage source in an electrical
circuit with a current source can have a profound impact on the
mathematical representation of that system (*e.g.,* if the system is
represented as a block diagram).  But such a change has no significant
impact when using an acausal approach.  Although the underlying
mathematical representation still changes, sometimes profoundly,
because that representation is generated automatically as part of the
compilation process there is no impact on the user.

.. todo:: I really need to include one of the typical examples here.

Finally, another aspect of composability is in the support for
multi-domain systems.  In fact, Modelica not only supports different
engineering domains (electrical, thermal, hydraulic), it supports
multiple modeling formalisms.  Model developers have created libraries
for block diagrams, state charts, petri nets, *etc.* Instead of
requiring special tools or editors in each case, all of these
different domains and formalisms can be freely combined in Modelica as
appropriate.

Accounting
~~~~~~~~~~

The other advantage of acausal modeling is the amount of automatic
"accounting" performed with acausal modeling.  To understand exactly
what accounting is performed, let's consider the following electrical
``connector``:

.. literalinclude:: /ModelicaByExample/Connectors/SimpleDomains.mo
   :language: modelica
   :lines: 3-6

As we've discussed previously, an acausal connector includes two
different types of variables, across variables and through variables.
The through variable is indicated by the presence of the ``flow``
qualifier.

* connection sets

* generated equations


.. _flow-signs:

Sign Conventions for ``flow`` Variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _default-flow:

Default ``flow`` Equations
^^^^^^^^^^^^^^^^^^^^^^^^^^

* Sign convention

* Number of equations per component

Component Definitions
^^^^^^^^^^^^^^^^^^^^^

* Discuss input, output, record, model, block

* assertions and model boundaries

* Conditional components
