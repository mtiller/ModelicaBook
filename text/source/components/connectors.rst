.. _connectors:

Connectors
**********

.. index: ! connector

Introduction
============

Component-Oriented Modeling
---------------------------

Before diving into some examples, there is a bit of background
required in order to understand what a ``connector`` in Modelica is,
why it is used and the mathematical basis for their formulations.
We'll cover these points first before proceeding.

So far, we've talked primarily about how to model behavior.  What we've
seen so far are models composed largely of textual equations.  But from
this point forward, we will be exploring how to create reusable
component models.  So instead of writing Ohm's law whenever we wish to
model a resistor, we'll instead add an instance of a **resistor**
component model to our system.

Until now, the models that we've shown have all been self contained.
All the behavior of our entire system was captured in a single model
and represented by textual equations.  But this approach does not
scale well.  What we really want is the ability to create reusable
component models.

But before we can dive into how to create these components, we need to
first discuss how we will be connecting them together.  The component
models that we will be building during the remainder of the book are
still represented by a ``model`` definition.  What sets them apart
from the models we have seen so far is that they will feature
**connectors**.

A ``connector`` is a way for one model to exchange information with
another model.  As we'll see, there are different ways that we may
wish to exchange this information and this chapter will focus on
explaining the various semantics that can be used to describe
connectors in Modelica.

.. _acausal-connections:

Acausal Connections
-------------------

In order to understand one specific class of connector semantics, it
is first necessary to understand a bit more about acausal formulations
of physical systems.  An acausal approach to physical modeling
identifies two distinct classes of variables.

The first class of variables we will discuss are "across" variables
(also called *potential* or *effort* variables).  Differences in the
values of across variables across a component are what trigger
components to react.  Typical examples of across variables, that we
will be discussing shortly, are temperature, voltage and pressure.
Differences in these quantities typically lead to dynamic behavior in
the system.

The second class of variables we will discuss are "through" variables
(also called *flow* variables).  Flow variables normally represent the
flow of some conserved quantity like mass, momentum, energy, charge,
*etc.*  These flows are usually the result of some difference in the
across variables across a component model.  For example, current
flowing through a resistor is in response to a voltage difference
across the two sides of the resistor.  As we will see in many of the
examples to come, there are many different types of relationships
between the through and across variables (Ohm's law being just one of
many).

.. topic:: Sign Conventions

    It is extremely important to know that Modelica follows a
    convention that a positive value for a through variable represents
    flow of the conserved quantity **into** a component.  We'll repeat
    this convention several times later in the book (especially once
    we begin our discussion of how to build models of
    :ref:`components`).

The next section will define through and across variables for a number
of basic engineering domains.

Examples
========

.. toctree::
   :maxdepth: 1

   connectors/simple_domains
   connectors/fluid_connectors
   connectors/block_connectors
   connectors/graphics

.. _connector-review:

Review
======

.. toctree::
   :maxdepth: 1

   connectors/connector_def
   connectors/annotations
