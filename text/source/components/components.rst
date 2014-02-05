.. _components:

Components
**********

When most people think of Modelica, they think of the
component-oriented approach that it enables.  As such, how to build
such component models is probably the single most important topic to
cover in this book.

Until now, we've focused primarily on how to describe the mathematical
behavior (both continuous and discrete).  Now it is time to understand
how that behavior can be wrapped up into reusable component models.
The fact that these component models are reusable means that, once
written and tested, the same code can be used over and over.  This
kind of reuse saves development time, avoids errors and simplifies
maintenance.

Examples
========

.. toctree::
   :maxdepth: 1

   components/heat_transfer
   components/elec_comps
   components/rot_comps_basic
   components/rot_comps_adv
   components/population
   components/speed_comps
   components/block_comps
   components/chem_comps

Review
======

.. toctree::
   :maxdepth: 1

   components/component_models
   components/system_models
   components/comp_annos
