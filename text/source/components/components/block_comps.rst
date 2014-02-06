.. _block-components:

Block Diagram Components
------------------------

So far, the focus of this chapter has been on acausal modeling.  But
Modelica also supports causal formalisms.  The main reason for the
emphasis on acausal modeling is that it lends itself very well to the
modeling of physical systems.  It enables models of physical systems
to be assembled schematically rather than mathematically while also
automatically formulating conservation equations to ensure proper
bookkeeping.

Block diagrams are a different way of approach modeling.  The emphasis
in block diagram is on creating component models that represent a wide
range of mathematical operations.  The operations are then performed
on (generally time-varying) signals and yield, in turn, other
signals.  In fact, we will introduce a special kind of ``model`` in
this section, called a ``block``, that is restricted to having only
``input`` and ``output`` signals.

In this section, we'll first look at how to construct causal blocks
representing some basic mathematical operations.  We'll then see how
those blocks can be used in two different ways.  The first way will be
to model a sample physical system.  We'll include some discussion
contrasting the causal and acausal approaches.  The second way to use
such blocks is to model control systems.  As we'll see, using blocks
to construct control systems is a much more natural fit for the block
diagram formalism.

Fortunately, Modelica allows both causal and acausal approaches and,
as we'll see shortly, even allows them to be mixed.  The result is
that Modelica allows the model developer to use whichever approach
works best in a given context.

Blocks
^^^^^^

Modelica Standard Library
~~~~~~~~~~~~~~~~~~~~~~~~~

In this section, we will leverage several definitions from the
Modelica Standard Library starting with the connectors:

.. code-block:: modelica

    connector RealInput = input Real "'input Real' as connector";
    connector RealOutput = output Real "'output Real' as connector";

As the names suggest, ``RealInput`` and ``RealOutput`` are connectors
for representing real valued input and output signals respectively.
When drawn in a diagram, the ``RealInput`` connector takes the form of
a blue solid triangle:

.. image:: ../../../docs-dir/Icons/Modelica.Blocks.Interfaces.RealInput.svg
   :height: 200px
   :align: center

The ``RealOutput`` connector is a blue triangle outline:

.. image:: ../../../docs-dir/Icons/Modelica.Blocks.Interfaces.RealOutput.svg
   :height: 200px
   :align: center

We will leverage the Modelica Standard Library for several different
``partial`` block definitions.  The first ``partial`` definition we'll
use is the ``SO``, or "single output", definition:

.. code-block:: modelica

    partial block SO "Single Output continuous control block"
      extends Modelica.Blocks.Icons.Block;

      RealOutput y "Connector of Real output signal" annotation (Placement(
            transformation(extent={{100,-10},{120,10}}, rotation=0)));
    end SO;

Obviously, this definition is used to blocks that have a single
output.  By convention, this output signal is named ``y``.  Another
definition we'll use is the ``SISO`` or "single input, single output"
block:

.. code-block:: modelica

    partial block SISO "Single Input Single Output continuous control block"
      extends Modelica.Blocks.Icons.Block;

      RealInput u "Connector of Real input signal" annotation (Placement(
            transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
      RealOutput y "Connector of Real output signal" annotation (Placement(
            transformation(extent={{100,-10},{120,10}}, rotation=0)));
    end SISO;

This model adds an input signal, ``u``, in addition to the output
signal, ``y``.  Finally, for blocks with multiple inputs, the ``MISO``
block defines the input signal, ``u``, as a vector:

.. code-block:: modelica

    partial block MISO "Multiple Input Single Output continuous control block"
      extends Modelica.Blocks.Icons.Block;
      parameter Integer nin=1 "Number of inputs";
      RealInput u[nin] "Connector of Real input signals" annotation (Placement(
            transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
      RealOutput y "Connector of Real output signal" annotation (Placement(
            transformation(extent={{100,-10},{120,10}}, rotation=0)));
    end MISO;

The parameter ``nin`` is used to specify the number of inputs to the block.

``Constant``
~~~~~~~~~~~~

Probably the simplest block we can imagine is one that simply outputs
a constant value.  Since this model has a single output, it extends
from the ``SO`` block:

.. literalinclude:: /ModelicaByExample/Components/BlockDiagrams/Components/Constant.mo
   :language: modelica
   :lines: 1-7,16

When rendered, the block looks like this:

.. figure:: /ModelicaByExample/Components/BlockDiagrams/Components/Constant.svg
   :width: 100%
   :align: center
   :alt: Gain Block
   :figclass: align-center

``Gain``
~~~~~~~~

Another simple ``block`` is a "gain block" which multiplies an input
signal by a constant to compute its output signal.  Such a block will
have a single input signal and a single output signal.  As such, it
extends from the ``SISO`` model as follows:

.. literalinclude:: /ModelicaByExample/Components/BlockDiagrams/Components/Gain.mo
   :language: modelica
   :lines: 1-6,18

When rendered, the block looks like this:

.. figure:: /ModelicaByExample/Components/BlockDiagrams/Components/Gain.svg
   :width: 100%
   :align: center
   :alt: Gain Block
   :figclass: align-center

``Sum``
~~~~~~~

The ``Sum`` block can operate on an arbitrary number of input
signals.  For this reason, it extends from the ``MISO`` block:

.. literalinclude:: /ModelicaByExample/Components/BlockDiagrams/Components/Sum.mo
   :language: modelica
   :lines: 1-5,19

The ``Sum`` block uses the :ref:`sum-func` function to compute the sum
over the array of input signals, ``u``, to compute the output signal
``y``.

When rendered, the block looks like this:

.. figure:: /ModelicaByExample/Components/BlockDiagrams/Components/Sum.svg
   :width: 100%
   :align: center
   :alt: Gain Block
   :figclass: align-center

``Product``
~~~~~~~~~~~

The ``Product`` block is nearly identical to the ``Sum`` block except
that it uses the :ref:`product-func` function:

.. literalinclude:: /ModelicaByExample/Components/BlockDiagrams/Components/Product.mo
   :language: modelica
   :lines: 1-5,25

When rendered, the block looks like this:

.. figure:: /ModelicaByExample/Components/BlockDiagrams/Components/Product.svg
   :width: 100%
   :align: center
   :alt: Gain Block
   :figclass: align-center


``Feedback``
~~~~~~~~~~~~

The ``Feedback`` block differs from the previous blocks because it
doesn't extend from any definitions in the Modelica Standard Library.
Instead, it explicitly declares all of the connectors it uses:

.. literalinclude:: /ModelicaByExample/Components/BlockDiagrams/Components/Feedback.mo
   :language: modelica
   :lines: 1-12,46

The output of the ``Feedback`` block is the difference between the two
``input`` signals ``u1`` and ``u2``.

When rendered, the block looks like this:

.. figure:: /ModelicaByExample/Components/BlockDiagrams/Components/Feedback.svg
   :width: 100%
   :align: center
   :alt: Gain Block
   :figclass: align-center

``Integrator``
~~~~~~~~~~~~~~

The ``Integrator`` block is another ``SISO`` block that integrates the
input signal, ``u``, to compute the output signal, ``y``.  Since this
``block`` performs an integral, it requires an initial condition which
is specified using the parameter ``y0``:

.. literalinclude:: /ModelicaByExample/Components/BlockDiagrams/Components/Integrator.mo
   :language: modelica
   :lines: 1-9,33

When rendered, the block looks like this:

.. figure:: /ModelicaByExample/Components/BlockDiagrams/Components/Integrator.svg
   :width: 100%
   :align: center
   :alt: Gain Block
   :figclass: align-center

Systems
^^^^^^^

Now that we've created this assortment of blocks, we'll explore how
they can be used to model a couple of example systems.  As we'll see,
the suitability of causal ``block`` components varies from application
to application.

Cooling Example
~~~~~~~~~~~~~~~

The first system that we will model using our ``block`` definitions is
the heat transfer example we presented :ref:`earlier in this chapter
<heat-transfer-components>`.  However this time, instead of using
acausal components to build our model, we'll build it up in terms of
the mathematical operations associated with our ``block`` definitions.

Since these blocks represent mathematical operations, let us first
revisit the equation associated with this example:

.. math:: m c_p \dot{T} = h (T_{\infty}-T)

The following block diagram will solve for the temperature profile,
:math:`T`:

.. figure:: /ModelicaByExample/Components/BlockDiagrams/Examples/NewtonCooling.svg
   :width: 100%
   :align: center
   :alt: Gain Block
   :figclass: align-center

The Modelica source code for this example is:

.. literalinclude:: /ModelicaByExample/Components/BlockDiagrams/Examples/NewtonCooling.mo
   :language: modelica

The temperature, :math:`T`, is represented in this model by the
variable ``T.y``.  Simulating this system, we get the following
solution for the temperature:

.. plot:: ../plots/BNC.py
   :include-source: no
