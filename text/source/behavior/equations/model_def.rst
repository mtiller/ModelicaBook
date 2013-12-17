Model Definition
----------------

Syntax of a Model Definition
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. index:: ! model

As we saw throughout this chapter, a model definition starts with the
``model`` keyword and is followed by a model name (and optionally a
model description).  The name of the model must start with a letter
and can be followed by any collection of letters, numbers or
underscores (``_``).

.. index:: camel case

.. topic:: Naming conventions

   Although not strictly required by the language.  It is a convention
   that **model names start with an upper case letter**.  Most model
   developers use the so-called "camel case" convention where the
   first letter of each word in the model name is upper case.

The model definition can contain variables and equations (to be
discussed shortly).  The end of the model is indicated by the presence
of the ``end`` keyword followed by a repetition of the model name.
Any text appearing after the sequence ``//`` and until the end of the
line or between the delimeters ``/*`` and ``*/`` is considered a
comment.

In summary, a model definition has the following general form:

.. code-block:: modelica

   model SomeModelName "An optional description"
     // By convention, variables are listed at the start
   equation
     /* And equations are listed at the end */
   end SomeModelName;

Inheritance
^^^^^^^^^^^

.. index:: ! inheritance
.. index:: ! extends

As we in the section on :ref:`avoiding-repetition`, we can reuse code
from other models by adding and ``extends`` clause to the model.  It
is worth noting that a model definition can include multiple
``extends`` clauses.

Each ``extends`` clause must include the name of the model being
extended from and can be optionally followed by modifications that are
applied to the contents of the model being extended from.  In the case
of a model definition that inherits from other model definitions, you
can think of the general syntax as looking something like this:

.. code-block:: modelica

   model SpecializedModelName "An optional description"
     extends Model1; // No modifications
     extends Model2(n=5); // Including modification
     // By convention, variables are listed at the start
   equation
     /* And equations are listed at the end */
  end SpecializedModelName;

By convention, ``extends`` clauses are normally listed at the very
top of the model definition, before any variables.

In later chapters, we will show how this same syntax can be used to
define other entities besides models.  But for now, we will focus
primarily on models
