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
these variables are not arguments or return values, but are instead
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
      circumference := 3.14159*diameter;
    end Circumference;

Here we see how some intermediate result or common sub-expression can
be associated with an internal variable.

Default Input Arguments
-----------------------

In some cases, it makes sense to include default values for some input
arguments.  In these cases, it is possible to include a default value
in the declaration of the input variable.  Consider the following
function to compute the potential energy of a mass in a gravitational
field:

.. code-block:: modelica

    function PotentialEnergy
      input Real m "mass";
      input Real h "height";
      input Real g=9.81 "gravity";
      output Real pe "potential energy";
    algorithm
      pe := m*g*h;
    end PotentialEnergy;

By providing a default value for ``g``, we do not force users of this
function to provide a value for ``g`` each time.  Of course, this kind
of approach should only be used when there is a reasonable default
value for a given argument and it should never be used if you want to
force users to provide a value.

These default values have some important effects when
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
      circumference := 3.14159*diameter;
      area := 3.14159*radius^2;
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

.. code-block:: modelica

    f(z, t);

Here we see the typical syntax name of the function name followed by a
comma separated list of arguments surrounded by parentheses.  But
there are several interesting cases to discuss.

The syntax above is "positional".  That means that values in the
function call are assigned to arguments based on the order.  But since
Modelica function arguments have names, it is also possible to call functions
using named arguments.  Consider the following function for computing
the volume of a cube:

.. code-block:: modelica

    function CylinderVolume
      input Real radius;
      input Real length;
      output Real volume;
    algorithm
      volume = 3.14159*radius^2*length;
    end CylinderVolume;

When calling this function, it is important not to confuse the radius
and the volume.  To avoid any possible confusion regarding their
order, it is possible to call the function used named arguments.  In
that case, the function call would look something like:

.. code-block:: modelica

    CylinderVolume(radius=0.5, length=12.0);

Named arguments are particularly useful in conjunction with default
argument values.  Recall the ``PotentialEnergy`` function introduced
earlier.  It can be invoked in several ways:

.. code-block:: modelica

    PotentialEnergy(1.0, 0.5, 9.79)       // m=1.0, h=0.5, g=9.79
    PotentialEnergy(m=1.0, h=0.5, g=9.79) // m=1.0, h=0.5, g=9.79
    PotentialEnergy(h=0.5, m=1.0, g=9.79) // m=1.0, h=0.5, g=9.79
    PotentialEnergy(h=0.5, m=1.0)         // m=1.0, h=0.5, g=9.81
    PotentialEnergy(0.5, 1.0)             // m=0.5, h=1.0, g=9.81

The reason named arguments are so important for arguments with default
values is if a function has many arguments with default arguments, you
can selectively override values for those arguments by referring to
them by name.

Finally, we previously pointed out the fact that it is possible for a
function to have multiple return values.  But the question remains,
how do we address multiple return values?  To see how this is done in
practice, let us revisit the ``CircleProperties`` function we defined
earlier in this section.  The following statement shows how we can
reference both return values:

.. code-block:: modelica

    (c, a) := CircleProperties(radius);

In other words, the left hand side is a comma separated list of the
variables to be assigned to (or equated to, in the case of an
``equation`` section) wrapped by a pair of parentheses.

As this discussion demonstrates, there are many different ways to call
a function in Modelica.
      
Important Restrictions
----------------------

In general, we can perform the same kinds of calculations in functions
as we can in models.  But there are some important restrictions.

#. Input arguments are read only - You are not allowed to assign a
   value to a variable which is an input argument to the function.

#. You are not allowed to reference the global variable `time` from
   within a function.

#. No equations or when statements - A function can have no more than
   one ``algorithm`` section and it cannot contain ``when`` statements.

#. The following functions cannot be invoked from a function: ``der``,
   ``initial``, ``terminal``, ``sample``, ``pre``, ``edge``,
   ``change``, ``reinit``, ``delay``, ``cardinality``, ``inStream``,
   ``actualStream``

#. Arguments, results and intermediate (``protected``) variables
   cannot be models or blocks.

#. Array sizes are restricted - Arguments that are arrays can have
   :ref:`unspecd-dim` and the size will be implicitly determined by
   the context in which the function is invoked.  Results that are
   arrays must have their sizes specified in terms of constants or in
   relation to the sizes of input arguments.

One important thing to note is that functions are **not** restricted
in terms of recursion (*i.e.,* a function **is** allowed to call
itself).

.. todo:: According to Wikipedia 

	  "In computer science, a function or expression is said to
	  have a side effect if, in addition to returning a value, it
	  also modifies some state or has an observable interaction
	  with calling functions of the outside world".  "In computer
	  programming, a function may be described as a pure function
	  if both these statements about the function hold: The
	  function always evaluates the same result value given the
	  same argument value(s). The function result value cannot
	  depend on any hidden information or state that may change as
	  program execution proceeds or between different executions
	  of the program, nor can it depend on any external input from
	  I/O devices.  Evaluation of the result does not cause any
	  semantically observable side effect or output, such as
	  mutation of mutable objects or output to I/O devices".
	  Thus: side effects => the function is impure impure
	  functions do not => side effect e.g., a function whose
	  output is not a function of the inputs does not necessarily
	  g generate side effects

Side Effects
------------

In the :ref:`sil-controller` example, we introduced external functions
that had side effects.  This means that the value returned by the
function was not strictly a function of its arguments.  Such a
function is said to have "side effects".  Functions with
side effects, should be qualified with the ``impure`` keyword.  This
tells the Modelica compiler that these functions cannot be treated as
purely mathematical functions.

The use of ``impure`` functions is restricted.  They can only be
invoked from within a ``when`` statement or another ``impure``
function.

Function Template
-----------------

Taking all of this into account, the following can be considered a
generalized function definition:

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

