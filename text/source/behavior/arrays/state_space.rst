.. _state_space:

State Space
-----------

Recall from our previous discussion on :ref:`odes` that we can express
differential equations in the following form:

.. math::
   :nowrap:

   \begin{align}
   \dot{\vec{x}}(t) &= \vec{f}(\vec{x}(t), \vec{u}(t), t) \\
   \vec{y}(t) &= \vec{g}(\vec{x}(t), \vec{u}(t), t)
   \end{align}

There is a particularly interesting special case of these equation
when the functions :math:`\vec{f}` and :math:`\vec{g}` depend linearly
on :math:`\vec{x}` and :math:`\vec{u}`.  In this case, the equations
can be rewritten as:

.. math::
   :nowrap:

   \begin{align}
   \dot{\vec{x}}(t) &= A(t) \vec{x}(t) + B(t) \vec{u}(t) \\
   \vec{y}(t) &= C(t) \vec{x}(t) + D(t) \vec{u}(t)
   \end{align}

The matrices in this problem are the so-called "ABCD" matrices.  This
special linear version of the state space equations represents a
canonical form that that can represent all linear differential
equations.

Up until now, the models we have developed have involved only scalar
variables.  But in order to create a Modelica representation of our
canonical ABCD form, we are going to need to represent the matrices
and vectors.  To indicate that a variable is a vector, matrix or
higher dimension array, we just need to add subscripts that indicate
the number of dimensions along with the size of each dimension.  For
example, we can represent the canonical ABCD form in Modelica as:

.. literalinclude:: /ModelicaByExample/ArrayEquations/StateSpace/ABCD.mo
   :language: modelica
   :lines: 2-

The model starts be specifying the size of the :math:`\vec{x}`,
:math:`\vec{y}` and :math:`\vec{u}` vectors as ``nx``, ``ny`` and
``nu``, respectively.  Then we define the matrices ``A``, ``B``, ``C``
and ``D`` to represent the :math:`A`, :math:`B`, :math:`C` and
:math:`D` matrices in our canonical form.  Finally, we introduce the
variables ``x``, ``y`` and ``u`` to represent the vectors in our
canonical form.

Note how the declarations for the matrices include subscripts of the
form ``[_,_]``.  This syntax indicates that the variable being
declared is a matrix (has two dimensions).  The two expressions
included inside the subscripts indicate the size of each dimension.
Similarly, declarations for vectors have similar syntax but with only
one dimension (and dimension size).

.. note:: The size of arrays cannot change at run time.  For this
	  reason, the sizes of all dimensions must have "parameter"
	  variability (see our previous discussion on
	  :ref:`variability` for more details).

The declarations are the complex part of the model.  But the equations
are quite simple and intuitive.  There is a general rule that any
operation that can be applied to a scalar can also be applied to an
array by simply applying that function to each element in the array.
That is what we see in the expression ``der(x)``.  In all of our
previous examples, the operator to ``der`` was a scalar.  But if we
apply ``der`` to a vector, it is simply applied element wise to ``x``
to produce a vector of derivatives.

For some operations, an element wise application wouldn't make sense.
In particular, the use of the ``*`` operator in the expression
``Amat*x``.  In this case, there is a special definition of ``*`` when
it is applied to a matrix or a vector.  Modelica follows the usual
conventions (which will be detailed later in this chapter) regarding
``+``, ``-`` and ``*`` when applied to matrices and vectors.  This
allows the Modelica form of these equations to closely approximate the
normal mathematical notation used to express our canonical form.

Note that our ``ABCD`` model cannot be simulated.  This is because we
haven't specified any values for ``Amat``, ``Bmat``, ``Cmat`` or
``Dmat``.  The observant reader will also not the first use of the
``partial`` keyword.  We aren't going to discuss the detailed
implications of the ``partial`` keyword's presence yet, but it
basically implies that this model is lacking a sufficient number of
equations to be regarded as complete (which is clearly true).

So if we can't simulate this model, what is the point of even defining
it?  Before we can address that question, let us first consider how we
would model a closely related type of problem.  Imagine we assumed
that the :math:`A`, :math:`B`, :math:`C` and :math:`D` matrices were
time-invariant (*i.e.,* had no dependence on time).  In that case, we
would have a slight more specialized form:

.. math::
   :nowrap:

   \begin{align}
   \dot{\vec{x}}(t) &= A \vec{x}(t) + B \vec{u}(t) \\
   \vec{y}(t) &= C \vec{x}(t) + D \vec{u}(t)
   \end{align}

We could model this type of system using the following model:

.. literalinclude:: /ModelicaByExample/ArrayEquations/StateSpace/LTI.mo
   :language: modelica
   :lines: 2-

Unlike our ``ABCD`` model, the ``LIT`` model qualifies all the
matrices by the ``parameter`` keyword.  In doing so, it clearly
indicates that these matrices do not vary with time.  But the
troubling part here is how remarkably similar our ``ABCD`` and ``LTI``
models are.  There are may variables and equations that are common
between these two models.

So the question is, is there a way for us to exploit this commonality?
The answer is "yes".  Furthermore, this is related to the previous
question of what value is the ``ABCD`` model if it doesn't have enough
equations.

The answers to both of these questions can be seen in the following
example:

.. literalinclude:: /ModelicaByExample/ArrayEquations/StateSpace/LTI_Inheritance.mo
   :language: modelica
   :lines: 2-

Of particular importance is the line:

.. code-block:: modelica

    extends ABCD;

This statement indicates that the ``LTI_Inheritance`` model inherits
from the ``ABCD`` model.  Recall our previous discussion on
:ref:`inheritance` from the first chapter.  There we learned that by
using ``extends`` we can avoid repeating code across models.  Instead,
we can put common code in one model and then reuse.  Often times, this
common model is incomplete.  For that reason, we add the ``partial``
keyword to make it clear to the Modelica compiler that we know that
this model is incomplete and we will not attempt to use it directly
but rather to use it only as a starting point for other models.
