.. _architectures:

Architectures
*************

At the start of this book, we looked at how to write equations and
transform those into simulations.  That, by itself, is very
interesting because we were able to avoid having to worry about how we
would solve the resulting linear and non-linear systems of equations
or how to integrate the resulting differential equations.  However,
writing complex systems in terms of individual equations does not
scale well.

So, we then explored the features of Modelica that allow us to create
component models so that we could reuse these equations without having
to take the time to write them out in every context where they would
be used.  Not only did this allow us to compose systems from
pre-defined (and presumably tested) component models, it also allowed
us, through the use of Modelica's standard graphical annotations, to
compose and represent systems graphically.

This too has scalability issues because building complex models
strictly from components requires a great deal of dragging, dropping
and connecting of components.  Furthermore, system models can become
large and complex without any kind of hierarchy.  This is yet another
limitation to scalability.  To address this issue, we examined how to
define reusable subsystem models that, instead of containing equations
to be reused, contained reusable assemblies of components and other
subsystems.  In this way, we could drag, drop and connect common
assemblies of components into reusable assemblies.  This minimized the
amount of dragging, dropping and connecting that was required to build
complex system models.

Each step in this progression has shown how to reduce the amount of
tedious, time consuming and potentially error prone work we need to
perform in order to build system models.  This chapter represents the
last step along this progression.  Here, we will learn about
architectures.  Architectures are models where a collection of
subsystems have been **pre-connected** and the composition of the
system is done by simply selecting specific implementations (models)
for each subsystem in our system.  In this way, not only do we not
need to supply equations, we don't even need to drag, drop and connect
components or subsystems.  Instead, we only need to choose the
specific model to use for each particular subsystem.

Examples
========

.. toctree::
   :maxdepth: 1

   architectures/sensor_comparison
   architectures/sensor_comparison_ad
   architectures/thermal_control

Review
======

.. toctree::
   :maxdepth: 1

   architectures/int_vs_imp
   architectures/replaceable
   architectures/expandable
