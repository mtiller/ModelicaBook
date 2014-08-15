.. _state-space:

State Space
-----------

.. _abcd:

ABCD Form
^^^^^^^^^

.. index:: ABCD


Recall from our previous discussion on :ref:`odes` that we can express
differential equations in the following form:

.. math::

   \dot{\vec{x}}(t) &= \vec{f}(\vec{x}(t), \vec{u}(t), t) \\
   \vec{y}(t) &= \vec{g}(\vec{x}(t), \vec{u}(t), t)

In this form, :math:`x` represents the states in the system, :math:`u`
represents any externally specified inputs to the system and :math:`y`
represents the outputs of the system (*i.e.,* variables that are not
states, but can ultimately be computed from the values of the states
and inputs).

There is a particularly interesting special case of these equations
when the functions :math:`\vec{f}` and :math:`\vec{g}` depend linearly
on :math:`\vec{x}` and :math:`\vec{u}`.  In this case, the equations
can be rewritten as:

.. math::

   \dot{\vec{x}}(t) &= A(t) \vec{x}(t) + B(t) \vec{u}(t) \\
   \vec{y}(t) &= C(t) \vec{x}(t) + D(t) \vec{u}(t)

The matrices in this problem are the so-called "ABCD" matrices.  This
ABCD form is useful because there are several interesting
calculations that can be performed once a system is in this form.  For
example, using the :math:`A` matrix, we can compute the natural
frequencies of the system.  Using various combinations of these
matrices, we can determine several very important properties related
to control of the underlying system (*e.g.,* observability and
controllability).

Note that this ABCD form allows these matrices to vary with time.
There is a slightly more specialized form that, in addition to being
linear, is also time-invariant:

.. math::

   \dot{\vec{x}}(t) &= A \vec{x}(t) + B \vec{u}(t) \\
   \vec{y}(t) &= C \vec{x}(t) + D \vec{u}(t)

.. index:: FMI

This form is often called the "LTI" form.  The LTI form is important
because, in addition to having the same special properties as the
ABCD form, the LTI form can be used as a very simple form of
"model exchange".  Historically, when someone derived the behavior
equations for a given system (either by hand or using some modeling
tool), one way they could import those equations into other tools was
to put them in the LTI form.  This means that the model could be
exchanged, shared or published as a series of matrices with either
numbers or expressions in them.  Today, technologies like Modelica and
`FMI <http://fmi-standard.org>`_ provide much better options for
model exchange.

LTI Models
^^^^^^^^^^

If someone gave us a model in LTI form, how would we express that in
Modelica?  Here is one way we might choose to do it:

.. literalinclude:: /ModelicaByExample/ArrayEquations/StateSpace/LTI.mo
   :language: modelica
   :lines: 2-

The first step in this model is to declare the parameters ``nx``,
``nu`` and ``ny``.  These represent the number of states, inputs and
outputs, respectively.  Next, we define the matrices ``A``, ``B``,
``C`` and ``D``.  Because we are creating a model for a linear,
time-invariant representation all of these matrices can be parameters.
We know that ``A``, ``B``, ``C`` and ``D`` are arrays because their
declarations followed by ``[`` and ``]``.  We know they are matrices
because within the ``[]``\ s there are two dimensions given.  Finally,
we see declarations for ``x0``, ``x``, ``u`` and ``y``.  These are
also arrays.  But in this case, they are vectors, since they each have
only a single dimension.

Another thing to note about this model is that all parameters have
been given default values.  For ``nx``, ``nu`` and ``ny``, the
assumption is that the number of states, inputs and outputs is zero by
default.  For the matrices, we assume that they are filled with zeros
by default.  Similarly, for initial conditions we assume that all
states start the simulation with a value of zero unless otherwise
specified.  We shall see shortly how these assumptions make it
possible for us to write very simple models by simply overriding the
values for these parameters.

Vector Equations
^^^^^^^^^^^^^^^^

The rest of the model should look pretty familiar by now.  One thing
that is important to point out is the fact that the equations in this
model are all **vector** equations.  An equation in Modelica can
involve scalars or arrays.  The only requirement is that both side of
the equation have the same number of dimensions and the same size for
each dimension.  So in the case of the ``LTI`` model, we have the
following initial equation:

.. literalinclude:: /ModelicaByExample/ArrayEquations/StateSpace/LTI.mo
   :language: modelica
   :lines: 15-16

This equation is a vector equation that expresses the fact that each
element in ``x`` has the corresponding value in ``x0`` at the start of a
simulation.  In practice, what happens is that each element in these
vectors is automatically expanded into a series of scalar equations.

Another thing that helps keep these equations readable is that
Modelica has some special rules regarding :ref:`vectorization` of
functions.  In a nutshell, these rules say that if you have a function
that works with scalars, you can automatically use it with vectors as
well.  If you do, Modelica will automatically apply the function to
each element in the vector.  So, for example, the expression
``der(x)`` in the ``LTI`` model is a vector where each element in the
vector represents the derivative of the respective element of ``x``.

Finally, many of the typical algebraic operators like ``+``, ``-`` and
``*`` have special meanings when applied to vectors and matrices.
These definitions are designed so that they correspond with
conventional mathematical notation.  So in the ``LTI`` model, the
expression ``A*x`` corresponds to a matrix-vector product.

LTI Examples
^^^^^^^^^^^^

With all this in mind, let's revisit several of our previous examples
to see how they can be represented in LTI form using our ``LTI``
model.  Note that we will again use inheritance (via the ``extends``
keyword) to reuse the code in the ``LTI`` model.

Let's start with the :ref:`first-order` we presented earlier.  Using
the ``LTI`` model, we can write this model as:

.. literalinclude:: /ModelicaByExample/ArrayEquations/StateSpace/Examples/FirstOrder.mo
   :language: modelica
   :lines: 2-

When we extend from ``LTI``, we only need to specify the parameter
values that are different from the default values.  In this case, we
specify that there is one state and one input.  Then we specify `A`
and `B` as 1x1 matrices.  Finally, since we have an input, we need to
provide an equation for it.  The input can, in general, be
time-varying so we don't represent it as a parameter, but rather with
an equation.  Note that in the equation:

.. code-block:: modelica

    u = {1};

the expression ``{1}`` is a vector literal.  This means that we are
building a vector as a list of its components.  In this case, the
vector has only one component, ``1``.  But we can build longer vectors
using a comma separated list of expressions, *e.g.,*

.. code-block:: modelica

    v = {1, 2, 3*4, 5*sin(time)};

.. index: modifications

It is worth noting that, in addition to setting parameter values, we
also can include equations in the ``extends`` statement.  So, we could
have avoided the ``equation`` section altogether and written the model
more compactly as:

.. literalinclude:: /ModelicaByExample/ArrayEquations/StateSpace/Examples/FirstOrder_Compact.mo
   :language: modelica
   :lines: 2-

In general, including the ``equation`` section makes the code a bit
more readable for others.  But there are some circumstances where it
is more convenient to include the equation as a modification in the
``extends`` statement.

Now let's turn our attention to the :ref:`cooling <getting-physical>`
we also discussed earlier.  In LTI form, we could have written the
model as:

.. literalinclude:: /ModelicaByExample/ArrayEquations/StateSpace/Examples/NewtonCooling.mo
   :language: modelica
   :lines: 2-

This model is very similar to the previous one.  However, in this case,
instead of putting numbers into our matrices, we've put expressions
involving other parameters like ``m``, ``c_p`` and so on.  In this way,
if those physical parameters are changed, the values for ``A`` and
``B`` will change accordingly.

We can take a similar approach in reformulating our previous
:ref:`mechanical example <mech-example>` into LTI form:

.. literalinclude:: /ModelicaByExample/ArrayEquations/StateSpace/Examples/RotationalSMD.mo
   :language: modelica
   :lines: 2-

Again, we compute ``A`` from physical parameters.  One thing to note
about this example is the construction of ``A``.  Mathematically, the
:math:`A` matrix is defined as:

.. math::

   A &= \left|
   \begin{array}{cccc}
   0 & 0 & 1 & 0 \\
   0 & 0 & 0 & 1 \\
   -\frac{k_1}{J_1} & \frac{k_1}{J_1} & -\frac{d_1}{J_1} &
   \frac{d_1}{J_1} \\
   \frac{k_1}{J_2} & -\frac{k_1}{J_2}-\frac{k_2}{J_2} &
   \frac{d_1}{J_2} & -\frac{d_1}{J_2}-\frac{d_2}{J_2} \\
   \end{array}
   \right|

One thing we can note about this construction of :math:`A` is that the
first two rows might be easier to express as a matrix of zeros and an
identity matrix.  In other words, it might be simpler to construct the
matrix as a set of sub-matrices, *i.e.,*

.. math::

   A &= \left|
   \begin{array}{cc}
     \left|
     \begin{array}{cc}
     0 & 0 \\
     0 & 0
     \end{array}
     \right|
     ~
     \left|
     \begin{array}{cc}
     1 & 0 \\
     0 & 1
     \end{array}
     \right| \\
     \left|
     \begin{array}{cc}
     -\frac{k_1}{J_1} & \frac{k_1}{J_1} \\
     \frac{k_1}{J_2} & -\frac{k_1}{J_2}-\frac{k_2}{J_2}
     \end{array}
     \right|
     \left|
     \begin{array}{cc}
     -\frac{d_1}{J_1} & \frac{d_1}{J_1} \\
     \frac{d_1}{J_2} & -\frac{d_1}{J_2}-\frac{d_2}{J_2}
     \end{array}
     \right|
   \end{array}
   \right|

In Modelica, we can construct our ``A`` matrix from sub-matrices in
this way:

.. literalinclude:: /ModelicaByExample/ArrayEquations/StateSpace/Examples/RotationalSMD_Concat.mo
   :language: modelica
   :lines: 2-

In the section above we do not include a representation of the
Lotka-Volterra equations in LTI form.  This is because the
Lotka-Volterra equations, while being time-invariant, are not linear.
It is worth pointing out that Modelica does not directly enforce
either of these properties when using the ``LTI`` model.  So it is
possible to represent non-linear or time-variant models using this
approach.  But it would be confusing since the term LTI implies that
the equations are both linear and time-invariant.

Using Components
^^^^^^^^^^^^^^^^

In all of these examples so far, we've used inheritance (via
``extends``) to reuse the equations from the ``LTI`` model.  In
general, there is a **much better** way to reuse these equations which
is to **treat them as sub-components**.  To see how this is done, we
will recast our previous :ref:`electrical examples <elec-example>` in
LTI form.  But this time, we'll create a named instance of the ``LTI``
model:

.. literalinclude:: /ModelicaByExample/ArrayEquations/StateSpace/Examples/RLC.mo
   :language: modelica
   :lines: 2-

Note that this time we do not use ``extends`` or inheritance of any
kind.  Instead, we actually declare a variable called ``rlc_comp``
that is of type ``LTI``.  Once we have finished covering all the
basics of how to describe different kinds of behavior in Modelica,
we'll turn our attention to how to organize all these equations into
reusable :ref:`components`.  But for now, this is just a "sneak peak"
of (big) things to come.

What we see in this `RLC` example is that we now have a variable
called ``rlc_comp`` and this component, in turn, has all the
parameters and variables of the ``LTI`` model inside it.  So, for
example, we see that our equation to specify the input, ``u``, is
written as:

.. code-block:: modelica

    rlc_comp.u = {Vb};

Note that this equation means that we are providing an equation for
the variable ``u`` that is **inside** the variable ``rlc_comp``.  As
we will see later, we can use hierarchy to manage a considerable
amount of complexity that arises from complex system descriptions.
The use of the ``.`` operation here is how we can reference variables
that are organized in this hierarchical manner.  Again, this will be
discussed thoroughly when we introduce :ref:`components`.
