.. _packages:

Packages
********

So far, we've presented all of the models without any real discussion
of how to properly organize them.  In some cases, like the
``NewtonCoolingWithTypes`` example in our discussion on :ref:`adding
physical type information <physical-types>`, it is awkward to
keep everything within a single model.  There are many cases where
the same information gets repeated in multiple models and this makes
maintaining those models very difficult.

The good news is that many of these previous examples can be greatly
improved by leveraging the ``package`` system in Modelica.  A
``package`` is conceptually like a directory.  It holds a collection
of Modelica entities.  These entities can then be referenced or
imported to avoid duplication.

This chapter provides several examples that demonstrate how to use the
package features in Modelica.  This chapter will conclude with a
discussion of the :ref:`msl`, which contains an enormous amount of
reusable content that is available to all Modelica tools.

Examples
========

.. toctree::
   :maxdepth: 1

   packages/organizing
   packages/fqn
   packages/nimport

Review
======

.. toctree::
   :maxdepth: 1

   packages/package_def
   packages/lookup
   packages/importing
   packages/msl

