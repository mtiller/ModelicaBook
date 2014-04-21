.. _polynomial-evaluation:

Polynomial Evaluation
=====================

Our first example will center around using functions to evaluate
polynomials.  This will help use understand the basics of defining and
using functions.

Computing a Line
^^^^^^^^^^^^^^^^

Mathematical Background
~~~~~~~~~~~~~~~~~~~~~~~

Before diving until polynomials of arbitrary order, let's first
consider how we could use a function to evaluate points on a line.
Mathematically, what we'd like to define is a function that is applied
as follows:

.. math::

    y(x, x_0, y_0, x_1, y_1)

where :math:`x` is the independent variable, :math:`(x_0,y_0)` is one
point that defines the line and :math:`(x_1,y_1)` is the other point
that defines the line.  Mathematically, such a function could be
defined as follows:

.. math::

    y(x, x_0, y_0, x_1, y_1) = x\frac{y_1-y_0}{x_1-x_0}
    -\frac{x_1+x_0}{2(x_1-x_0)}\frac{y_1-y_0}{2}+\frac{y_1+y_0}{2}

To reduce the number of arguments, let's assume that combine
:math:`x_0` and :math:`y_0` into a single point represented by the
vector :math:`\vec{p_0}` and we combine :math:`x_1` and :math:`y_1`
into a single point represented by the vector :math:`\vec{p_1}` so
that the function is now invoked as:

.. math::

    \mathtt{Line}(x, \vec{p_0}, \vec{p_1})

Modelica Representation
~~~~~~~~~~~~~~~~~~~~~~~

The question now is how can we transform this mathematical
relationship into a function that we can invoke from within a Modelica
model.  To do this, we must define a new Modelica function.

It turns out that a function definition is very similar
(syntactically, at least) to a :ref:`model-definition`.  Here is the
definition of our ``Line`` function in Modelica:

.. literalinclude:: /ModelicaByExample/Functions/Polynomials/Line.mo
   :language: modelica
   :lines: 2-

.. index:: input
.. index:: function arguments
.. index:: algorithm; in a function

All the arguments to the function are prefixed with the ``input``
qualifier.  The result of the function has the ``output`` qualifier.
The body of the function is an ``algorithm`` section.  The value for
the return value (``y`` in this case) is computed by the ``algorithm``
section.

So in this case, the ``output`` value, ``y``, is computed in terms of
the ``input`` values ``x``, ``p0`` and ``p1``.  Note that there is no
``return`` statement in this function.  Whatever the value of the
``output`` variable is at the conclusion of the ``algorithm`` section
is automatically the value returned.

A couple of things to note that were discussed in previous chapters.
First, note the descriptive strings on both the function itself and
the arguments.  These are very useful in documenting the purpose of
the function and its arguments.  Also note how the points use arrays
to represent a two-dimensional vector and how those arrays are indexed
in this example.

One troubling aspect of the ``Line`` model is the length of the
expression used to compute ``y``.  It would be nice if we could break
that expression down.  

Intermediate Variables
~~~~~~~~~~~~~~~~~~~~~~

In order to simplify the expression for ``y``, we need to introduce
some intermediate variables.  We can already see that ``x``, ``p0``
and ``p1`` are variables that we can use from within the function.
We'd like to introduce additional variables, but they shouldn't be
arguments.  Instead, their values should be computed "internally" to
the function.  To achieve this, we create a collection of variables
that are ``protected``.  Such variables are assumed to be computed
internally by the function.  Here is an example that uses
``protected`` to declare and compute two internal variables:

.. literalinclude:: /ModelicaByExample/Functions/Polynomials/LineWithProtected.mo
   :language: modelica
   :emphasize-lines: 7-8
   :lines: 2-

This model introduces two new variables.  One variable, ``m``,
represents the slope of the line and the other, ``b``, represents the
return value for the condition when ``x=0``.  Having computed these
two intermediate variables, the expression to evaluate ``y`` becomes
the more easily recognized form ``y := m*x+b``.

Computing a Polynomial
^^^^^^^^^^^^^^^^^^^^^^

Mathematical Definition
~~~~~~~~~~~~~~~~~~~~~~~

Of course, our goal for this section is to create a function that can
compute arbitrary polynomials.  So now that we've seen a few basic
functions, let us proceed with our ultimate goal.  We will formulate a
function that is invoked as follows:

.. math::

    p(x, \vec{c})

where :math:`x` is again the independent variable and :math:`\vec{c}`
is a vector of coefficients such that our polynomial is evaluated as:

.. math::

    p(x, \vec{c}) = \sum_{i=1}^{N} c_i x^{N-i}

where ``N`` is the number of coefficients passed to the function.
There are two important things to note at this point.  First, **the
first element in** :math:`\vec{c}` **corresponds to the highest order term
in the polynomial**.  Second, we are using a notation that assumes
that the elements in :math:`\vec{c}` are numbered **starting from 1**
to make the transition to Modelica code (where arrays are indexed
starting from 1) easier.

Note that the definition for :math:`p` above is easy to read and
understand.  But when working with floating point numbers with finite
precision, it is more efficient and more accurate to use a recursive
approach for evaluating the polynomial.  For a :math:`4^{th}` order
polynomial, the evaluation would be:

.. math::

    p(x, \vec{c}) = ((c_1 x + c_2) x + c_3) x +c_4

This is more efficient because it relies on simple multiplication and
addition operations and avoids performing exponentiation operations,
which are more expensive,  It is more accurate because exponentiation
can easily trigger round-off or truncation errors in finite precision
floating point representations.

Modelica Definition
~~~~~~~~~~~~~~~~~~~

Now that we've defined precisely what computations we want the
function to perform, we are just left with the task of defining the
function in Modelica.  In this case, our polynomial evaluation
function can be represented in Modelica as:

.. literalinclude:: /ModelicaByExample/Functions/Polynomials/Polynomial.mo
   :language: modelica
   :lines: 2-

Again, all the arguments to the function have the ``input`` qualifier
and the return value has the ``output`` qualifier.  As with the
previous example, we've defined an intermediate variable, ``n``, as a
convenient way to refer to the length of the coefficient vector.  We
also see how a ``for`` loop can be used to represent the recursive
evaluation of our polynomial for any arbitrary order.

To verify that this function is working properly, let's use it in a
model.  Consider the following Modelica model:

.. literalinclude:: /ModelicaByExample/Functions/Polynomials/EvaluationTest1.mo
   :language: modelica
   :lines: 2-

Remember that the first element in ``c`` corresponds to the highest
order term.  If we compare a direct evaluation of the polynomial,
``yp``, with one computed by our function, ``yf``, we see they are identical:

.. plot:: ../plots/Eval1.py
   :class: interactive

Differentiation
~~~~~~~~~~~~~~~

It is completely plausible that this polynomial evaluation might be
used to represent a quantity that was ultimately differentiated by the
Modelica compiler.  The following examples is admittedly contrived, but
it demonstrates how such a polynomial might come to be differentiated
in a model:

.. literalinclude:: /ModelicaByExample/Functions/Polynomials/Differentiation1.mo
   :language: modelica
   :lines: 2-

Here we have the same equations for ``yf``, evaluated using
``Polynomial``, and ``yp``, evaluated directly as a polynomial.  But
we've added two additional variables, ``d_yf`` and ``d_yp``
representing the derivative of ``yf`` and ``yp``, respectively.  If we
attempt to compile this model the compiler is very likely to throw an
error related to the equation for ``d_yf``.  The reason is that it has
no way to compute the derivative of ``yf``.  This is because, unlike
``yp`` which is computed with a simple expression, we've hidden the
details of how ``yf`` is computed behind the function ``Polynomial``.
In general, Modelica tools do not look at the implementations of
functions to compute derivatives and, even if they did, determining
the derivative of an arbitrary algorithm is not an easy thing to do.

.. index:: annotation
.. index:: annotation; derivative
.. index:: functions; differentiating

So the next question is how can we deal with this situation?  Won't
this make it difficult to use our functions within models?
Fortunately, Modelica gives us a way to specify how to evaluate the
derivative of a function.  This is done by adding something called an
``annotation`` to the function definition.

.. topic:: Annotations

    An annotation is a piece of metadata that doesn't describe the
    behavior of the function directly (*i.e.,* it doesn't affect the
    value the function returns).  Instead, annotations are used by
    Modelica compilers to give them "hints" about how to deal with
    certain situations.  Annotations are always "optional" information
    which means tools are not required to use the information when
    provided.  The Modelica specification defines a number of standard
    annotations so that they are interpreted consistently across
    Modelica tools.

In this case, what we need is the ``derivative`` annotation because it
will allow us to communicate information to the Modelica compiler on
how to evaluate the derivative of our function.  To do this, we define
a new evaluation function, ``PolynomialWithDerivative``, as follows:

.. literalinclude:: /ModelicaByExample/Functions/Polynomials/PolynomialWithDerivative.mo
   :language: modelica
   :emphasize-lines: 13
   :lines: 2-

Note that this function is identical except for the highlighted line.
In other words, all we needed to do was add the line:

.. literalinclude:: /ModelicaByExample/Functions/Polynomials/PolynomialWithDerivative.mo
   :language: modelica
   :lines: 14

to our function in order to explain to the Modelica compiler how to
evaluate the derivative of this function.  What it indicates is that
the function ``PolynomialFirstDerivative`` should be used to evaluate
the derivative of ``PolynomialWithDerivative``.

Before discussing the implementation of the
``PolynomialFirstDerivative`` function, let's first understand,
mathematically, what is required.  Recall our original definition of
our polynomial interpolation function:

.. math::

    p(x, \vec{c}) = \sum_{i=1}^{N} c_i x^{N-i}

Note that :math:`p` takes two arguments.  If we wish to differentiate
:math:`p` by some arbitrary variable :math:`z`, we can use the
chain rule to express the total derivative of :math:`p` with respect
to :math:`z` as:

.. math::

   \frac{\mathrm{d}p(x, \vec{c})}{\mathrm{d}z} =
   \frac{\partial p}{\partial x} \frac{\mathrm{d}x}{\mathrm{d}z} + 
   \frac{\partial p}{\partial \vec{c}}
   \frac{\mathrm{d}\vec{c}}{\mathrm{d}z}

We can derive the following relations from our original definition of
:math:`p`.  First, for the partial derivative of :math:`p` with
respect to :math:`x` we get:

.. math::

    \frac{\partial p}{\partial x} = p(x, c')

where :math:`c'` is defined as:

.. math::

    c'_i = (N-i)c_i

Second, for the partial derivative of :math:`p` with respect to
:math:`\vec{c}` we get:

.. math::

    \frac{\partial p}{\partial c_i} = p(x, \vec{d_i})

where the **vector** :math:`\vec{d_i}` is the :math:`i^{th}` column of
an :math:`NxN` identity matrix.

It turns out that for efficiency reasons, it is better for the
Modelica compiler to give us :math:`\frac{\mathrm{d}x}{\mathrm{d}z}`
and :math:`\frac{\mathrm{d}\vec{c}}{\mathrm{d}z}` than to
provide functions to evaluate :math:`\frac{\partial p}{\partial x}`
and :math:`\frac{\partial p}{\partial c_i}`.  So, mathematically
speaking, what the Modelica compiler needs is a new function that is
invoked with the following arguments:

.. math::

    df(x, \vec{c}, \frac{\mathrm{d}x}{\mathrm{d}z}, \frac{\mathrm{d}\vec{c}}{\mathrm{d}z})

such that:

.. math::

    df(x, \vec{c}, \frac{\mathrm{d}x}{\mathrm{d}z},
    \frac{\mathrm{d}\vec{c}}{\mathrm{d}z}) =
    \frac{\mathrm{d}f}{\mathrm{d}z}

For this reason, the ``derivative`` annotation should point to a
function that takes the same arguments as :math:`df`.  In our case,
that function, ``PolynomialFirstDerivative`` would be defined as
follows:

.. literalinclude:: /ModelicaByExample/Functions/Polynomials/PolynomialFirstDerivative.mo
   :language: modelica
   :lines: 2-

Note how the arguments of our original function are repeated to create
twice as many arguments (as we would expect).  The second set of
arguments represent the :math:`\frac{\mathrm{d}x}{\mathrm{d}z}` and
:math:`\frac{\mathrm{d}\vec{c}}{\mathrm{d}z}` quantities,
respectively.  Note that the assumption is that :math:`z` is a scalar
so the types of the input arguments are the same.  Exploiting our
knowledge about the partial derivatives of a polynomial, the
calculation of the derivatives is done by leveraging our polynomial
evaluation function.

We can exercise all of these functions using the following model:

.. literalinclude:: /ModelicaByExample/Functions/Polynomials/Differentiation2.mo
   :language: modelica
   :lines: 2-

Simulating this model and comparing results, we see agreement between
``yf`` and ``yp`` as well as ``d_yf`` and ``d_yp``:

.. todo:: Yikes, OpenModelica computes the derivative incorrectly!

.. plot:: ../plots/Diff2.py
   :class: interactive

