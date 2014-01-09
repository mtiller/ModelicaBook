.. _func-def:

Function Definitions
====================

As we've already seen, Modelica includes many useful functions for
describing mathematical behavior.  But, inevitably, it is necessary to
create new functions for specific purposes.  Defining such functions
is similar, syntactically, to a :ref:`model-definition`.

Basic Syntax
------------

A basic Modelica function includes one or more arguments, a return
value and an ``algorithm`` section to compute the return value in
terms of the arguments.  The arguments to the function are preceded by
the ``input`` qualifier and the return value is preceded by the
``output`` qualifier.  For example, consider the following simple
function that squares its input argument:

.. code-block:: modelica

    function Square
      input Real x;
      output Real y;
    algorithm
      y := x*x;
    end Square;

Here the input argument ``x`` has the type ``Real``.  The output
variable ``y`` also has the ``Real`` type.  Arguments and return
values can be scalars or arrays (or even records, although we won't
introduce records until :ref:`later <components>`).

Intermediate Variables
----------------------

For complex calculations, it is sometimes useful to define variables
to hold intermediate results.  Such variables must be clearly
distinguished from arguments and return values.  To declare such
intermediate variables, make their declarations ``protected``.  Making
the variables ``protected`` indicates to the Modelica compiler that
these variables are not arguments or return values but are instead
used internally by the function.  For example, if we wished to write a
function to compute the circumference of a circle, we might utilize an
intermediate variable to store the diameter:

.. code-block:: modelica

    function Circumference
      input Real radius;
      output Real circumference;
    protected
      Real diameter := radius*2;
    algorithm
      circumference := 3.1415*diameter;
    end Circumference;

Here we see how some intermediate result or common sub-expression can
be associated with an internal variable.

Default Input Arguments
-----------------------

In some cases, it makes sense to include default values for some input
arguments.  In these cases, it is possible to include a default value
in the declaration of the input variable.  This has consequences for
:ref:`calling-functions` that we shall discuss shortly.

Multiple Return Values
----------------------

Note that a function can have multiple return values (*i.e.,* multiple
declarations with the ``output`` qualifier).  For example, to consider
a function that computes both the circumference and area of a circle:

.. code-block:: modelica

    function CircleProperties
      input Real radius;
      output Real circumference;
      output Real area;
    protected
      Real diameter := radius*2;
    algorithm
      circumference := 3.1415*diameter;
      area := 3.1415*radius^2;
    end CircleProperties;

Our upcoming discussion on :ref:`calling-functions` will cover how to
address multiple return values.

.. _calling-functions:

Calling Functions
-----------------

So far, we've covered how to define new functions.  But it is also
worth spending some time discussing the various ways of calling
functions.  In general, functions are invoked in a way that would be
expected by both mathematicians and programmers, *e.g.,*

.. code-block::

    f(z, t);

Here we see the typical syntax name of the function name followed by a
comma separated list of arguments surrounded by parentheses.  But
there are several interesting cases to discuss.

The syntax above is "positional".  That means that values in the
function call are assigned to arguments based on the order.  But since
Modelica functions have names, it is also possible to call functions
using named arguments.  Consider the following function for computing
the volume of a cube:

.. code-block::

    function CylinderVolume
      input Real radius;
      input Real length;
      output Real volume;
    algorithm
      volume = 3.1415*radius^2*length;
    end CylinderVolume;

When calling this function, it is important not to confuse the radius
and the volume.  To avoid any possible confusion regarding their
order, it is possible to call the function used named arguments.  In
that case, the function call would look something like:

.. code-block::

    CylinderVolume(radius=0.5, length=12.0);

Named arguments are particularly useful in conjunction with default
argument values.  Consider the following function to compute the
potential energy of a mass in a gravitational field:

.. code-block::

    function PotentialEnergy
      input Real m "mass";
      input Real h "height";
      input Real g=9.81 "gravity";
      output Real pe "potential energy";
    algorithm
      pe := m*g*h;
    end PotentialEnergy;

This function could be invoked in several ways:

.. code-block::

    PotentialEnergy(1.0, 0.5, 9.79)       // m=1.0, h=0.5, g=9.79
    PotentialEnergy(m=1.0, h=0.5, g=9.79) // m=1.0, h=0.5, g=9.79
    PotentialEnergy(h=0.5, m=1.0, g=9.79) // m=1.0, h=0.5, g=9.79
    PotentialEnergy(h=0.5, m=1.0)         // m=1.0, h=0.5, g=9.81
    PotentialEnergy(0.5, 1.0)             // m=1.0, h=0.5, g=9.81

The reason named arguments are so important for arguments with default
values is if a function has many arguments with default arguments, you
can selectively override values for those arguments by referring to
them by name.
      
* multiple return

Important Restrictions
----------------------

* Input arguments are read only

* Can't use time

* No equations or when statements

* No der, initial, terminal, sample, pre, edge, change, reinit,
  delay, cardinality, inStream, actualStream

* No models or blocks

* Array sizes

* recursive

Function Template
-----------------

.. code-block:: modelica

    function FunctionName "A description of the function"
      input InputType1 argName1 "description of argument1";
      ...
      input InputTypeN argNameN := defaultValueN "description of argumentN";
      output OutputType1 returnName1 "description of return value 1";
      ...
      output OutputTypeN returnNameN "description of return value N";
    protected
      InterType1 intermedVarName1 "description of intermediate variable 1";
      ...
      InterTypeN intermedVarNameN "description of intermediate variable N";
      annotation(key1=value1,key2=value2);     
    algorithm
      // Statements that use the values of argName1..argNameN
      // to compute intermedVarName1..intermedVarNameN
      // and ultimately returnName1..returnNameN
    end FunctionName;

