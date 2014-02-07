.. _comp-annos:

Component Model Annotations
---------------------------

Several of the annotation that appeared in the examples from this
chapter have been explained previously (*e.g.,* in our discussions on
:ref:`graphical-annos` and :ref:`diagrams`).  Here we'll run through
those annotations that have not yet been explained and discuss their
purpose.

.. _choices-all-matching:

``choices``
^^^^^^^^^^^

``choicesAllMatching``
^^^^^^^^^^^^^^^^^^^^^^

``enable``
^^^^^^^^^^

``Dialog``
^^^^^^^^^^

.. code-block:: modelica

    record Dialog
      parameter String tab = "General";
      parameter String group = "Parameters";
      parameter Boolean enable = true;
      parameter Boolean showStartAttribute = false;
      parameter String groupImage = "";
      parameter Boolean connectorSizing = false;
    end Dialog; 

``DynamicSelect``
^^^^^^^^^^^^^^^^^

``defaultComponentName``
^^^^^^^^^^^^^^^^^^^^^^^^

``defaultComponentPrefixes``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``preferredView``
^^^^^^^^^^^^^^^^^

``unassignedMessage``
^^^^^^^^^^^^^^^^^^^^^
