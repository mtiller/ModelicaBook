.. _func-annotations:

Function Annotations
====================

We've already discussed :ref:`annotations` in general.  Modelica
includes a number of standard annotations that are specifically used
in conjunction with functions.  These meaning of these annotations is
formally defined in the Modelica Specification.  In this section,
we'll talk about the three general categories of annotations for
functions and provide some discussion of why you need them and how to
use them.

Mathematical Annotations
------------------------

The first class of annotations are ones that provide additional
mathematical information about the function.  Because functions are
written using ``algorithm`` sections, it is not generally possible to
derive equations for the behavior of the function and many symbolic
manipulations are therefore not possible.  However, using the
annotations in this section allows us to augment the function
definition with such information.

``derivative``
~~~~~~~~~~~~~~

.. index:: ! annotations; standard annotations; derivative

As was saw in the ref:`polynomial-evaluation` example, there are
circumstances where we would like to inform the Modelica compiler how
to compute the derivative of a given function.  This is done by adding
the ``derivative`` annotation in the function.

Simple First Derivative
^^^^^^^^^^^^^^^^^^^^^^^

The basic use of the ``derivative`` annotation is to specify the name
of another Modelica function that computes the first derivative of the
function being annotated.  For example:

.. code-block:: modelica

    function f
      input Real x;
      input Real y;
      output Real z;
      annotation(derivative=df);   
    algorithm
      z := // some expression involving x and y
    end f;

    function df
      input Real x;
      input Real y;
      input Real dx;
      input Real dy;
      output Real dz;
    algorithm
      dz := // some expression involving x, y, dx and dy
    end df;

Note that the first arguments to the derivative function, ``df``, in
this case, are the same as for the original function, ``f``.  Those
arguments are then followed by the differential versions of the input
arguments to the original function.  Finally, the output(s) of the
derivative function are the differential versions of the output(s) of
the original function.  It sounds complicated, but hopefully the same
code conveys how simple the construction really is.

Given such a Modelica function, the Modelica compiler can use such a
function to compute various derivatives, *e.g.*,

.. math::

    \frac{\mathrm{d}f}{\mathrm{d}v}(x,y) = df(x, y, \frac{\partial
    x}{\partial v}, \frac{\partial y}{\partial v})

Insensitivity to Some Arguments
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Now consider a case where :math:`\frac{\partial y}{\partial v}` is
zero.  The derivative function will be passed this zero value or an
array of zero values, if the argument was an array.  That zero value
will then be used in several calculations inside the derivative
function. Most, if not all, of these will be multiplications and the
results of those calculations will therefore be zeros.  Those zeros
will then be added to the final result, but will have no impact.  In
other words, there are many calculations that could be skipped because
they won't have any impact on the result.

In such cases, Modelica offers a way to avoid these calculations.  If
the Modelica compiler knows *a priori* that one of the differentials
is zero, it can check (among the set of ``derivative`` annotations)
if there are any functions that compute the derivative for that case.
These cases are specified using the ``zeroDerivative`` argument to the
``derivative`` annotation.  So, in the case of our example function
``f``, we could add the following annotation:

.. code-block:: modelica

    function f
      input Real x;
      input Real y;
      output Real z;
      annotation(derivative=df, derivative(zeroDerivative=y)=df_onlyx);   
    algorithm
      z := // some expression involving x and y
    end f;

where ``df_onlyx`` would then be defined as:

.. code-block:: modelica

    function df_onlyx
      input Real x;
      input Real y;
      input Real dx;
      output Real dz;
    algorithm
      dz := // some expression involving x, y, dx
    end df_onlyx;

Note that the ``dy`` term is not included here.  This function is
specifically for cases where ``dy`` is zero.  Because ``dy`` doesn't
appear in the arguments, this function includes only those
calculations involving ``dx``.

Second Derivatives
^^^^^^^^^^^^^^^^^^

There are a few more variations worth covering here.  The first is how
to specify what the **second** derivative of a function is.  This is
done by adding an ``order`` argument.  Note that a function can have
multiple ``derivative`` annotations, *e.g.,*

.. code-block:: modelica

    function f
      input Real x;
      input Real y;
      output Real z;
      annotation(derivative=df, derivative(order=2)=ddf);
    algorithm
      z := // some expression involving x and y
    end f;

    function df
      ...
    end df;

    function ddf
      input Real x;
      input Real y;
      input Real dx;
      input Real dy;
      input Real ddx;
      input Real ddy;
      output Real ddz;
    algorithm
      ddz := // some expression involving x, y, dx, dy,
            // ddx and ddz
    end ddf;

Hopefully there are no real surprises here.  In order to compute the
second derivative, it is necessary to add an additional annotation
``derivative`` annotation to the original function, *i.e.,*

.. code-block:: modelica

    annotation(derivative=df, derivative(order=2)=ddf);

This additional annotation has an additional argument ``order`` which
indicates which derivative that function computes.

Non-Real Arguments
^^^^^^^^^^^^^^^^^^

There is one additional complication to discuss.  What if the function has
arguments that don't represent real numbers, *e.g.*,

.. code-block:: modelica

    function g
      input Real x;
      input Integer y;
      output Real z;
    algorithm
      z := // some expression involving x and y
    end g;

Here, it makes no sense to take the derivative of this function with
respect to the ``y`` argument, since it is an integer.  Any non-real
argument can be ignored when formulating the derivative.  So, if we
wished to compute the derivative of this function, we would do it as
follows:

.. code-block:: modelica

    function g
      input Real x;
      input Integer y;
      output Real z;
      annotation(derivative=dg);
    algorithm
      z := // some expression involving x and y
    end g;

    function dg
      input Real x;
      input Integer y;
      input Real dx;
      output Real dz;
    algorithm
      dz := // some expression involving x, y and dx
    end dg;

In other words, the differential arguments only apply to arguments
that are real.


``inverse``
~~~~~~~~~~~

.. index:: ! annotations; standard annotations; inverse

During our discussion on :ref:`nonlinearities`, we showed how the
``inverse`` annotation can be used to tell the Modelica compiler how
to compute the inverse of a function.  The goal of an inverse function
is to solve explicitly for one of the current function's input
arguments.  As such, the ``inverse`` annotation contains an explicit
equation involving the input and output variables of the current
function, but used in conjunction with another function to explicitly
compute one of the input arguments.

For example, for a Modelica function defined as follows:

.. code-block:: modelica

    function h
      input Real a;
      input Real b;
      output Real c;
      annotation(inverse(b = h_inv_b(a, c)));
   algorithm
      c := // some calculation involving a and b
   end h;

we see that ``b`` can be computed by passing ``a`` and ``c`` as
arguments to the function ``h_inv_b`` which would be defined as
follows:

.. code-block:: modelica

    function h_inv_b
      input Real a;
      input Real c;
      output Real b;
   algorithm
      b := // some calculation involving a and c
   end h_inv_b;


Code Generation
---------------

The next class of annotations are related to how function definitions
are translated into code for simulation.  These annotations allow the
model developer to provide hints to the Modelica compiler on how the
code generation process should be done.

.. _inline-anno:

``Inline``
~~~~~~~~~~

.. index:: ! annotations; standard annotations; Inline

The ``Inline`` annotation is a hint to the Modelica compiler that the
statements in the function should be "inlined".  The value of the
annotation is used to suggest whether inlining should be done.  The
default value (if no ``Inline`` annotation is present) is ``false``.
The following is a function that uses the ``Inline`` annotation:

.. code-block:: modelica

    function SimpleCalculation
      input Real x;
      input Real y;
      output Real z;
      annotation(Inline=true);
    algorithm
      z := 2*x-y;
    end SimpleCalculation;

Here we see that the ``Inline`` annotation suggests that the Modelica
compiler should inline the ``SimpleCalculation`` function.  The
function is inlined by replacing invocations of the function
with the statements in the function that compute the output result.
This is useful for functions that perform very simple calculations.
In those cases, the "cost" (in CPU time) of calling the function is on
the same order of magnitude as the cost of the work performed by the
function.  By inlining the function, the cost of the function call can
be eliminated while still preserving the purpose of the function.

The ``Inline`` function is merely a hint to the Modelica compiler.
The compiler is not obligated to inline the function.  Also, the
compiler's ability to inline the function will depend on the
complexity of the function.  It is not necessary possible (or even
desirable) to inline a function in general.

``LateInline``
~~~~~~~~~~~~~~

.. index:: ! annotations; standard annotations; LateInline

Much like the :ref:`inline-anno` annotation, the ``LateInline``
function tells the Modelica compiler that it would be more efficient
to inline the function.  The ``LateInline`` annotation is also
assigned a ``Boolean`` value to specify whether the function should be
inlined or not.  The difference between the ``Inline`` and
``LateInline`` annotations is that ``LateInline`` indicates that
inlining should be performed after symbolic manipulation has been
performed.  A full discussion of the potential interactions between
inlining and other symbolic manipulations is beyond the scope of this
book.

It should be noted that the ``LateInline`` annotation takes precedence
over the ``Inline`` annotation if they are both applied to a function,
*i.e.,*

================  ==================  =========================
``Inline``        ``LateInline``      Interpretation
----------------  ------------------  -------------------------
``false``         ``false``           ``Inline=false``
``true``          ``false``           ``Inline=true``
``false``         ``true``            ``LateInline=true``
``true``          ``true``            ``LateInline=true``
================  ==================  =========================

.. _ext-functions:

External Functions
------------------

The final class of annotations are related to functions that are
defined as ``external``.  Such functions often depend on external
include files or libraries.  These annotations inform the Modelica
compiler of these dependencies and where to locate them.

.. _include-anno:

``Include``
~~~~~~~~~~~

.. index:: ! annotations; standard annotations; Include

The ``Include`` annotations is used whenever the code generated by a
Modelica compiler requires an include statement.  Typically this is
required when external libraries are being referenced.  The value of
the ``Include`` annotation should be the string that should be
inserted into the generated code, *e.g.,*

.. code-block:: modelica

    annotation(Include="#include \"mydefs.h\"");

.. todo:: is escaping discussed or is there an example?

.. note:: The value of the ``Include`` annotation is a string.  If it
	  included embedded strings, they need to be escaped.

.. _include-directory-anno:

``IncludeDirectory``
~~~~~~~~~~~~~~~~~~~~

.. index:: ! annotations; standard annotations; IncludeDirectory

As already discussed, the :ref:`include-anno` annotation allows
include directives to be inserted into generated code.  The
``IncludeDirectory`` annotation specifies what directory should be
searched to find the content specified with the ``Include``
annotation.

The value of this annotation is a string.  The string can represent a
directory or it can be a URL.  For example, the default
value for the ``IncludeDirectory`` annotation is:

.. code-block:: modelica

    IncludeDirectory=modelica://LibraryName/Resources/Include

We'll explain the meaning of these :ref:`modelica-urls` shortly.

``Library``
~~~~~~~~~~~

.. index:: ! annotations; standard annotations; Library

The ``Library`` annotation is used to specify any compiled libraries
that a function might depend on.  The value of library can be either a
simple string, representing the name of the library, or an array of
such strings, *i.e.,*

.. code-block:: modelica

    annotation(Library="somelib");

or

.. code-block:: modelica

    annotation(Library={"onelib","anotherlib"});

The Modelica compiler will then use this information during the
"linking" of the generated code.

``LibraryDirectory``
~~~~~~~~~~~~~~~~~~~~

.. index:: ! annotations; standard annotations; LibraryDirectory

We have the same issue with ``Library`` that we have with ``Include``.
The ``Library`` annotation tells us what we need to add, but not where
to find it.  In this way, the ``LibraryDirectory`` annotation serves
the same role as the :ref:`include-directory-anno` annotation.  Like
the ``IncludeDirectory`` annotation, it can also be a URL.  It's
default value is:

.. code-block:: modelica

    LibraryDirectory=modelica://LibraryName/Resources/Library
