.. _comp-annos:

Component Model Annotations
---------------------------

Several of the annotation that appeared in the examples from this
chapter have been explained previously (*e.g.,* in our discussions on
:ref:`graphical-annos` and :ref:`diagrams`).  Here we'll run through
those annotations that have not yet been explained and discuss their
purpose.

``defaultComponentName``
^^^^^^^^^^^^^^^^^^^^^^^^

**Type: Model Annotation**

The ``defaultComponentName`` annotation is used within a model
definition to define the default name that an instance of that model
should have.  This is used by graphical tools to assign an initial
name to components when they are dragged into a diagram.

``defaultComponentPrefixes``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Type: Model Annotation**

Where the ``defaultComponentName`` annotation defines the default name
used when a component is dragged into a diagram, the
``defaultComponentPrefixes`` defines any **qualifiers** that should
automatically be included in the declaration of the component.  The
value of this annotation should be a **string** that is a space
separated list of the qualifiers.

When a component is instantiated, graphical tools will find the
definition associated with that component and look if a value has been
provided for the ``defaultComponentPrefixes`` annotation.  If so, it
will extract the qualifiers listed in that string and immediately add
them as qualifiers to that components declaration.


``Dialog``
^^^^^^^^^^

**Type: Declaration Annotation**

The ``Dialog`` annotation is used to help organize variables
(typically ``parameters``) in the context of a graphical user
interface.  It provides additional information, beyond what is
necessary to compile the model, that instructs graphical tools what
content to include in component dialogs.

The structure of a ``Dialog`` annotation can be represented by the
following ``record`` definition:

.. code-block:: modelica

    record Dialog
      parameter String tab = "General";
      parameter String group = "Parameters";
      parameter Boolean enable = true;
      parameter Boolean showStartAttribute = false;
      parameter String groupImage = "";
      parameter Boolean connectorSizing = false;
    end Dialog; 

The ``tab`` field is a string that indicates the name of the tab that
this variable should be organized under.  The ``group`` field
specifies the name of a "group" **within the specified tab** in which
the variable should be placed.  The ``enable`` field should be given
an expression that indicates when the parameter should be shown.  The
``showStartAttribute`` field can be used to incorporate the ``start``
attributes value (for this variable) into the user interface so the
user can easily specify the value of the ``start`` attribute.  The
``groupImage`` field allows the user to specify an image to associate
with the group named by the ``group`` field.  Finally, the
``connectorSizing`` is only useful in declarations for integer
parameters that are used to specify the size of arrays of connectors.
In such circumstances, if the value of the ``connectorSizing`` field
is ``true``, the graphical environment **may** update the value of the
annotated parameter in response to any action that impacts the
necessary size of that connector.

``DynamicSelect``
^^^^^^^^^^^^^^^^^

.. todo:: Figure out if this is really standard

**Type: Declaration Annotation**

.. code-block:: modelica

    DynamicSelect(static_value, dynamic_value)

``preferredView``
^^^^^^^^^^^^^^^^^

.. todo:: Figure out if this is really standard

**Type: Model Annotation**

``unassignedMessage``
^^^^^^^^^^^^^^^^^^^^^

**Type: Declaration Annotation**

The value of the ``unassignedMessage`` annotation is a string.  If an
equation cannot be found to compute a value for the annotated
declaration, the string value given to the ``unassignedMessage``
annotation may be presented as a diagnostic message by the compiler.
