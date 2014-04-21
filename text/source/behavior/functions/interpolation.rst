.. _interpolation:

Interpolation
=============

In this chapter, we will example different ways of implementing a
simple one dimension interpolation scheme.  We'll start with an
approach that is written completely in Modelica and then show an
alternative implementation that combines Modelica with C.  The
advantages and disadvantages of each approach will then be discussed.

Modelica Implementation
-----------------------

Function Definition
~~~~~~~~~~~~~~~~~~~

For this example, we assume that we interpolate data in the
following form:

===============================  ===============================
Independent Variable, :math:`x`   Dependent Variable, :math:`y`
-------------------------------  -------------------------------
:math:`x_1`                      :math:`y_1`
:math:`x_2`                      :math:`y_2`
:math:`x_3`                      :math:`y_3`
...                              ...
:math:`x_n`                      :math:`y_n`
===============================  ===============================

where we assume that :math:`x_i<x_{i+1}`.

Given this data and the value for the independent variable :math:`x`
that we are interested in, our function should return an interpolated
value for :math:`y`.  Such a function could be implemented in Modelica
as follows:

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/InterpolateVector.mo
   :language: modelica
   :lines: 2-

Let's go through this function piece by piece to understand what is
going on.  We'll start with the argument declarations:

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/InterpolateVector.mo
   :language: modelica
   :lines: 3-5

The ``input`` argument ``x`` represents the value of the independent
variable we wish to use for interpolating our function, the ``input``
argument ``ybar`` represents the interpolation data and the ``output``
argument ``y`` represents the interpolated value.  The next part of
the function contains:

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/InterpolateVector.mo
   :language: modelica
   :lines: 6-9

The part of our function includes the declaration of various
``protected`` variables.  As we saw in our
:ref:`polynomial-evaluation` example, these are effectively
intermediate variables used internally by the function.  In this case,
``i`` is going to be used as an index variable, ``n`` is the number of
data points in our interpolation data and ``p`` represents a weight
used in our interpolation scheme.

With all the variable declarations out of the way, we can now
implement the ``algorithm`` section of our function:

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/InterpolateVector.mo
   :language: modelica
   :lines: 10-18

The first two statements are ``assert`` statements that verify that
the value of ``x`` is within the interval :math:`[x_1, x_n]`.  If not,
an error message will be generated explaining why the interpolation
failed.

The rest of the function searches for the value of ``i`` such that
:math:`x_i<=x<x_{i+1}`.  Once that value of ``i`` has been identified,
the interpolated value is computed as simply:

.. math::

    y = p\ \bar{y}_{i+1,2}+(1-p)\ \bar{y}_{i,2}

where

.. math::

    p = \frac{x-\bar{y}_{i,1}}{\bar{y}_{i+1,1}-\bar{y}_{i,1}]}

Test Case
~~~~~~~~~

Now, let's test this function by using it from within a model.  As a
simple test case, let's integrate the value returned by the
interpolation function.  We'll use the following data as the basis for
our function:

========== ============
:math:`x`   :math:`y`
---------- ------------
0          0
2          0
4          2
6          0
8          0
========== ============

If we plot this data, we see that our interpolated function looks like
this:

.. plot::

   import matplotlib.pyplot as plt
   import numpy as np
   x = [0, 2, 4, 6, 8]
   y = [0, 0, 2, 0, 0]
   plt.plot(x,y)
   plt.axis([0, 8, -1, 3])
   plt.title("Interpolated Function")
   plt.show()

In the following model, the independent variable ``x`` is set equal to
``time``.  The sample data is then used to interpolate a value for the
variable ``y``.  The value of ``y`` is then integrated to compute
``z``.

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/IntegrateInterpolatedVector.mo
   :language: modelica
   :lines: 2-

We can see the simulated results from this model in the following plot:

.. plot:: ../plots/IIV.py
   :class: interactive

There are a couple of drawbacks to this approach.  The first is that
the data needs to be passed around anywhere the function is used.
Also, for higher dimensional interpolation schemes, the data required
can be both complex (for irregular grids) and large.  So it is not
necessarily convenient to store the data in the Modelica source code.
For example, it might be preferable to store the data in an external
file.  However, to populate the interpolation data from a source other
than the Modelica source code, we will need to use an
``ExternalObject``.

Using an ``ExternalObject``
---------------------------

.. index:: ExternalObject

The ``ExternalObject`` type is a special type used to refer to
information that is not (necessarily) represented in the Modelica
source code.  The main use of the ``ExternalObject`` type is to
represent data or state that is maintained outside the Modelica source
code.  This might be interpolation data, as we will see in a moment,
or it might represent some other software system that maintains its
own state.

Test Case
~~~~~~~~~

For this example, we will flip things around and start with the test
case.  This will provide some useful context about how an
``ExternalObject`` is used.  The Modelica source code for our test
case is:

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/IntegrateInterpolatedExternalVector.mo
   :language: modelica
   :lines: 2-

Here the main difference between this and our previous test case is
the fact that we don't pass our data directly into the interpolation
function.  Instead, we create a special variable ``vector`` whose type
is ``VectorTable``.  We'll discuss exactly what a ``VectorTable`` is
in a moment.  But for now think of it as something that represents
(only) our interpolation data.  Other than the creation of the
``vector`` object, the rest of the model is virtually identical to the
previous case except that we use the ``InterpolateExternalVector``
function to perform our interpolation and we pass the ``vector``
variable into that function in place of our raw interpolation data.

Simulating this model, we see that the results are exactly what we
would expect when compared to our previous test case:

.. plot:: ../plots/IIEV.py
   :class: interactive

Defining an ``ExternalObject``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To see how this most recent test case is implemented, we'll first look
at how the ``VectorTable`` type is implemented.  As mentioned
previously, the ``VectorTable`` is an ``ExternalObject`` type.  This
is a special type in Modelica that is used to represent what is often
called an "opaque" pointer.  This means that the ``ExternalObject``
represents some data that is not directly accessible (from Modelica).

In our case, we implement our ``VectorTable`` type as:

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/VectorTable.mo
   :language: modelica
   :lines: 2-

Note that the ``VectorTable`` inherits from the ``ExternalObject``
type.  An ``ExternalObject`` can have two special functions
implemented inside its definition, the ``constructor`` function and
the ``destructor`` function.  Both of these functions are seen here.

Constructor
^^^^^^^^^^^

The ``constructor`` function is invoked when an instance of a
``VectorTable`` is created (*e.g.,* the declaration of the ``vector``
variable in our test case).  This ``constructor`` function is used to
initialize our opaque pointer.  Whatever data is required as part of
that initialization process should be passed as argument to the
``constructor`` function.  That same data should be present during
instantiation (*.e.g,* the ``data`` argument in our declaration of the
``vector`` variable).

The definition of the ``constructor`` function is unusual because,
unlike our previous examples, it does not include an ``algorithm``
section.  The ``algorithm`` section is normally used to compute the
return value of the function.  Instead, the ``constructor`` function
has an ``external`` clause.  This indicates that the function is
implemented in some other language besides Modelica.  In this case,
that other language is C (as indicated by the ``"C"`` following the
``external`` keyword).  This tells use that the ``table`` variable
(which is the ``output`` of this function and represents the opaque
pointer) is returned by a C function named ``createVectorTable`` which
is passed the contents and size of the ``ybar`` variable.

Following the call to ``createVectorTable`` is an ``annotation``.
This annotation tells the Modelica compiler where to find the source
code for this external C function.

The essential point here is that from the point of view of the
Modelica compiler, a ``VectorTable`` is just an opaque pointer
returned by ``createVectorTable``.  It is not possible to access the
data behind this pointer from Modelica.  But this pointer can be
passed to other functions, as we shall see in a minute, that are also
implemented in C and which do know how to access the data represented
by the ``VectorTable``.

Destructor
^^^^^^^^^^

The ``destructor`` function is invoked whenever the ``ExternalObject``
is no longer needed.  This allows the Modelica runtime to clean up any
memory consumed by the ``ExternalObject``.  An ``ExternalObject``
instantiated in a model will generally persist until the end of the
simulation.  But an ``ExternalObject`` declared as a ``protected``
variable in a function, for example, may be created and destroyed in
the course of a single expression evaluation.  For that reason, it is
important to make sure that any memory allocated by the
``ExternalObject`` is released.

In general, the ``destructor`` function is also implemented as an
external function.  In this case, calling the ``destructor`` function
from Modelica invokes the C function ``destroyVectorTable`` which is
passed a ``VectorTable`` instance as an argument.  Any memory
associated with that ``VectorTable`` instance should be freed by the
call to ``destructor``.  Again, we see the same types of annotations
used to inform the Modelica compiler where to find the source code for
the ``destoryVectorTable`` function.

External C Code
^^^^^^^^^^^^^^^

These external C functions are implemented as follows:

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/source/VectorTable.c
   :language: c

This is not a book on the C programming language so an exhaustive
review of this code and exactly how it functions is beyond the scope
of the book.  But we can summarize the contents of this file as
follows.

First, the ``struct`` called ``VectorTable`` is the data associated
wit the ``VectorTable`` type in Modelica.  This includes not just the
interpolation data (in the form of the ``x`` and ``y`` members), but
also the number of data points, ``npoints``, and a cached value for
the last used index, ``lastIndex``.

Next, we see the ``createVectorTable`` function which allocates an
instance of the ``VectorTable`` structure and initializes all the data
inside it.  That instance is then returned to the Modelica runtime.
Following the definition of ``createVectorTable`` is the definition of
``destroyVectorTable`` which effectively undoes what was done by
``createVectorTable``.

Finally, we see the function ``interpolateVectorTable``.  This is a C
function that is passed an instance of the ``VectorTable`` structure
and a value for the independent variable and returns the interpolated
value for the dependent variable.  This function performs almost
exactly the same function as the ``InterpolateVector`` function
presented earlier.  The Modelica runtime provides functions like
``ModelicaFormatError`` so that external C code can report errors.  In
the case of ``interpolateVectorTable``, these functions are used to
implement the assertions we saw previously in ``InterpolateVector``.
The lookup of ``i`` is basically the same except that instead of
starting from 1 each time, it starts from the value of ``i`` found in
the last call to ``interpolateVectorTable``.

Interpolation
^^^^^^^^^^^^^

We've seen how ``interpolateVectorTable`` is defined, but so far we
haven't seen where it is used.  We mentioned that performs very much
the same role as ``InterpolateVector``, but using a ``VectorTable``
object to represent the interpolation data.  To invoke
``interpolateVectorTable`` from Modelica, we simple need to define a
Modelica function as follows:

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/InterpolateExternalVector.mo
   :language: modelica
   :lines: 2-

We mentioned previously that ``VectorTable`` is opaque and that
Modelica code cannot access the data contained in the
``VectorTable``.  The Modelica function ``InterpolateExternalVector``
invokes its C counterpart ``interpolateVectorTable`` which **can**
access the interpolation data and, therefore, perform the interpolation.

Discussion
----------

As was discussed previously, the initial interpolation approach
required us to pass around large amounts of unwieldy data.  By
implementing the ``VectorTable``, we were able to represent that data
by a single variable.

An important thing to note about the ``ExternalObject`` approach,
which isn't adequately explored in our example, is that the
initialization data can be completely external to the Modelica source
code.  For simplicity, the example code shown in this section
initializes the ``VectorTable`` using an array of data.  **But it
could just as easily have passed a file name** to the initialization
code.  That file could then have been read by the
``createVectorTable`` function and the contents of the ``VectorTable``
structure could have been initialized using the data from that file.
In many cases, this approach not only makes managing the data easier,
but leveraging C allows more complex (new or existing) algorithms to
be used.

The :ref:`next section <sil-controller>` includes another example of
how external C code can be called from Modelica.
