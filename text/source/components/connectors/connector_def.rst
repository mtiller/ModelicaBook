.. _connector-def:

Connector Definitions
=====================

Syntax
------

.. index:: ! connector

As we have seen several times already, Modelica definitions share a
considerable amount of syntactic similarity.  This is just as true
with ``connector`` definitions.

The general syntax for a connector definition is:

.. code-block:: modelica

    connector ConnectorName "Description of the connector"
      // Declarations for connector variables
    end ConnectorName;

Unlike a ``model`` or ``function``, a ``connector`` is not allowed to
include any behavior.  So there can never be an ``equation`` or
``algorithm`` section present in a ``connector``.

.. _connector-vars:

Variables
---------

Causal Variables
^^^^^^^^^^^^^^^^

In our previous discussion of :ref:`block-connectors`, we showed that
variables within a Modelica ``connector`` definition can have a
causality associated with them.  If the signal is expected to be
computed externally, then the variable should have the ``input``
qualifier associated with it.  If, on the other hand, a signal is
expected to be computed internally (and then transmitted to other
components), it should have the ``output`` qualifier associated with
it.

.. _acausal-vars:

Acausal Variables
^^^^^^^^^^^^^^^^^

In our discussion of :ref:`simple-domains` and
:ref:`fluid-connectors`, we saw numerous examples of ``connector``
definitions that included through and across variables.  These
variables always occurred in pairs with the through variable being
prefixed by the ``flow`` qualifier while the across variable had not
qualifier associated with it.

As we will see in the coming chapters, such connector definitions are
very convenient when modeling physical systems because they enable the
Modelica compiler to automatically generate conservation equations for
networks of components.  Furthermore, they allow quantities like,
mass, momentum, energy, charge, species and so on to flow
**bi-directionally** through a network.

Parameters
^^^^^^^^^^

A variable in a ``connector`` definition can also have the
``parameter`` qualifier associated with it.  This qualifier means the
same thing that it meant when we first discussed :ref:`parameters`,
*i.e.,* the value of the variable cannot change during a simulation.
A ``parameter`` variable is frequently used in connector definitions
to indicate the size of an array contained in the connector.

.. todo::

   Figure out what to do about stream qualified variables.

Final Remarks
^^^^^^^^^^^^^

It should be noted that a ``connector`` definition can mix causal,
acausal and parameter variables all in the same connector.  In fact, a
variable in a connector **can itself be a connector** as well.  This
richness of expressiveness in Modelica allows users to model a range
of different types of interactions and choose, on a variable by
variable basis, the semantics that make the most sense for each
potential interaction.

