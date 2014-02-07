.. _importing_physical_types:

Importing Physical Types
------------------------

In the previous section, we learned how to reference types defined in
other packages.  This spares the developer from having to constantly
define things in their local model.  Instead, they can place
definitions in packages and then reference those packages.

However, references with long fully qualified names can be tedious to
type over and over again.  For that reason, Modelica includes an
``import`` statement that allows us to use a definition as if it were
defined locally.

Recall again, this example from a previous discussion on :ref:`physical-types`:

.. literalinclude:: /ModelicaByExample/BasicEquations/CoolingExample/NewtonCoolingWithTypes.mo
   :language: modelica
   :emphasize-lines: 3-8

The previous section described how we could avoid defining these types
locally by using types from the :ref:`msl`.  But we can also use the
``import`` command to import those types from the Modelica Standard
Library once and then use them without having to specify their fully
qualified names.  The resulting code would look something like:

.. literalinclude:: /ModelicaByExample/PackageExamples/NewtonCooling.mo
   :language: modelica
   :emphasize-lines: 11-16

Here we have replaced the type definitions with ``import`` statements.
Note how the highlighted lines are identical to the previous code.
Let's look at two of these import statements more closely to
understand what effect they have on the model.  Let's start with the
following import statement:

.. literalinclude:: /ModelicaByExample/PackageExamples/NewtonCooling.mo
   :language: modelica
   :lines: 4

This imports the type ``Modelica.SIunits.Temperature`` into the
current model.  By default, the name of this imported type will be the
last name in the fully qualified name, *i.e.,* ``Temperature``.  This
means that with this ``import`` statement present, we can simply use
the type name ``Temperature`` and that will automatically refer back
to ``Modelica.SIunits.Temperature``.

Now let's look at another ``import`` statement:

.. literalinclude:: /ModelicaByExample/PackageExamples/NewtonCooling.mo
   :language: modelica
   :lines: 7

The syntax here is a little bit different.  In this case, the type
that we are importing is
``Modelica.SIunits.CoefficientOfHeatTransfer``.  But instead of
creating a local type based on the last name in the fully qualified
name, *i.e.,* ``CoefficientOfHeatTransfer`` we are specifying that the
local type should be ``ConvectionCoefficient``.  In this case, this
allows us to use the name we originally used in our earliest examples.
In this way, we can avoid refactoring any code that used the
previous name.  Another reason for specifying an alternative name
(other than the default one that the Modelica compiler would normally
assign) would be to avoid name collision.  Imagine we wished to import
two types from two different packages, *e.g.,*

.. code-block:: modelica

    import Modelica.SIunits.Temperature; // Celsius
    import ImperialUnits.Temperature;    // Fahrenheit

This would leave us two types both named ``Temperature``.  By defining
an alternative name for the local alias, we could do something like
this:

.. code-block:: modelica

    import DegK = Modelica.SIunits.Temperature; // Kelvin
    import DegR = ImperialUnits.Temperature;    // Rankine

.. topic:: SI Units

    Note that this example imports imperial units just to demonstrate
    how a potential name clash might occur.  But it is very bad
    practice to do this in practice.  When using Modelica you should
    always use SI units and never use any other system of units.  If
    you want to enter data or display results in other units, please
    use the ``displayUnit`` attribute discussed previously in the
    section on :ref:`attributes`.

There is one last form of the ``import`` statement worth discussing
which is the wildcard import statement.  Importing units one unit at a
time can be tedious.  The wildcard import allows us to import **all**
types from a given package at once.  Recall the following earlier
example:

.. literalinclude:: /ModelicaByExample/BasicEquations/RotationalSMD/SecondOrderSystem.mo
   :language: modelica

We could replace these type definitions with import statements,
*e.g.*,

.. code-block:: modelica

    import Modelica.SIunits.Angle;
    import Modelica.SIunits.AngularVelocity;
    import Modelica.SIunits.Inertia;
    import Stiffness = Modelica.SIunits.RotationalSpringConstant;
    import Damping = Modelica.SIunits.RotationalDampingConstant;

However, the more types we bring in, the more import statements we
need to add.  Instead, we could write our model as follows:

.. literalinclude:: /ModelicaByExample/PackageExamples/SecondOrderSystem.mo
   :language: modelica
   :emphasize-lines: 4

Note the highlighted ``import`` statement.  This single (wildcard)
import statement imports all definitions from ``Modelica.SIunits``
into the current model.  With wildcard imports, there is no option to
"rename" the types.  They will have exactly the name locally as they
have in the named package.

Before using wildcard imports, be sure to read :ref:`this caveat
<wildcards-harmful>`.

In this chapter, we've seen how ``import`` statements can be used to
import types from other packages.  As it turns out, ``import``
statements are not always that useful.  When models are being
developed within a graphical modeling environment, tools generally use
the least ambiguous and most explicit method for reference types:
using fully qualified names.  After all, when using a graphical tool
the length of the name is not an issue because it doesn't need to be
typed.  This also avoids issues with name lookup, naming conflicts,
etc.

