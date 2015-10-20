.. _external-functions:

External Functions
==================

``external``
------------

.. index:: !external

As we saw with the ``InterpolateExternalVector`` function in our
:ref:`interpolation` related examples, it is possible to call
functions not written in Modelica.  Typically, such functions are
written in C or Fortran.  A function implemented outside Modelica does
not contain an ``algorithm`` section.  Instead, it should include an
``external`` statement that provides information about the external
function and how to pass information to and from the function.

The minimal requirement for an externally implemented function is to
include just the ``external`` keyword, *e.g.,*

.. code-block:: modelica

    external;

In this case, it is assumed that the function is implemented in C,
that the name of the function matches the name of the Modelica
"wrapper" function and that the arguments are passed in the same order
as the ``input`` arguments to the Modelica function.

Let's consider a slightly more complex case like the one found in our
``VectorTable`` type shown in the :ref:`interpolation` examples:

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/VectorTable.mo
   :language: modelica
   :lines: 12-17

Here we see that the implementation language of the function has been
explicitly specified as ``"C"``.  There are two other possible values
for the implementation language, ``"FORTRAN 77"`` and ``"builtin"``.
The use of ``"builtin"`` is mainly of interest to Modelica tool
vendors.

We also see that the name of the function has been explicitly
specified.  The portion of the ``external`` statement that reads
``destroyVectorTable(table)`` specifies what data should be passed to
the external function and in what order.

In some cases, it may be necessary to specify some of the
values passed to the external function and to specify how the results
of the function call map to the output variables.  We can see this
kind of information in the following ``function``:

.. literalinclude:: /ModelicaByExample/Functions/Interpolation/VectorTable.mo
   :language: modelica
   :lines: 4-10

Here, the external function needs to know the size of the ``ybar``
array since that information is not passed directly to the function.
It also indicates that the result from ``createVectorTable`` should be
assigned to the ``output`` variable ``table``.  It might seem obvious
that the return value of the C function should be treated as the
return value from the Modelica function, but there are cases where the
``output`` variables should be passed as arguments to the function.
As we will see shortly, in such cases pointers are used so that the
external function can assign values to these variables.

Data Mapping
------------

C
~~~~~

The following table shows how Modelica types map into native C types
when passing data **into** external functions.

=================  ============================================  =================================================
Modelica            C (input arguments)                           C (output arguments)
-----------------  --------------------------------------------  -------------------------------------------------
``Real``            ``double``                                    ``double *``
``Integer``         ``int``                                       ``int *``
``Boolean``         ``int``                                       ``int *``
``String``          ``const char *``                              ``const char **``
``T[d1]``           ``T' *``, ``size_t d1``                       ``T' *``, ``size_t d1``
``T[d1,d2]``        ``T' *``, ``size_t d1``, ``size_t d2``        ``T' *``, ``size_t d1``, ``size_t d2``
``T[d1,...,dn]``    ``T' *``, ``size_t d1``, ..., ``size_t dn``   ``T' *``, ``size_t d1``, ..., ``size_t dn``
``size(...)``       ``size_t``                                    N/A
``enumeration``     ``int``                                       ``int *``
``record``          ``struct *``                                  ``struct *``
=================  ============================================  =================================================

A few additional comments about this table.  First, it is assumed that
all strings are null (``\0``) terminated.  Also, in the case of arrays
the type ``T'`` indicates the C type that the Modelica type ``T`` would
be mapped to (using this same table).  Finally, a ``record`` is mapped
to a ``struct`` in C where the members of the C structure correspond
in order to the members of the Modelica ``record``.  Types of members
in ``records`` are mapped using the second column of this table
(*i.e.,* as if they were input arguments).

For data returned by a C function, the following mapping applies:

=================  =============================================
Modelica            C
-----------------  ---------------------------------------------
``Real``            ``double``
``Integer``         ``int``
``Boolean``         ``int``
``String``          ``const char *``
``T[d1]``           ``T' *``, ``size_t``
``T[d1,d2]``        ``T' *``, ``size_t d1``, ``size_t d2``
``T[d1,...,dn]``    ``T' *``, ``size_t d1``, ..., ``size_t dn``
``size(...)``       ``size_t``
``enumeration``     ``int``
``record``          ``struct *``
=================  =============================================

Fortran
~~~~~~~

If you need to work with Fortran functions or subroutines, the
following type mappings apply:

=================  =============================================
Modelica            Fortran 
-----------------  ---------------------------------------------
``Real``            ``DOUBLE PRECISION``
``Integer``         ``INTEGER``
``Boolean``         ``LOGICAL``
``T[d1]``           ``T'``, ``INTEGER``
``T[d1,d2]``        ``T'``, ``INTEGER d1``, ``INTEGER d2``
``T[d1,...,dn]``    ``T'``, ``INTEGER d1``, ..., ``INTEGER dn``
``size(...)``       ``INTEGER``
``enumeration``     ``INTEGER``
=================  =============================================

Two important things to note about this table.  First, there is no
mapping for strings or records.  Second, since Fortran uses pass by
reference semantics, all variables passed into and out of these
functions are assumed to be pointers.  For this reason, there is no
distinction made whether the variable is an input or an output of the
Modelica function.

Special Functions
-----------------

There are a number of functions that can be called **from** external
functions to interact with the Modelica runtime.  For each function,
the name of the function, its prototype and an explanation of the
functions purpose are described.

``ModelicaVFormatMessage``
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: c

    void ModelicaVFormatMessage(const char*string, va_list);

Output the message under the same format control as the C-function
``vprintf``.

.. _modelica-error:

``ModelicaError``
~~~~~~~~~~~~~~~~~

.. code-block:: c

    void ModelicaError(const char* string);

Output the error message string (no format control). This function
never returns to the calling function, but handles the error similarly
to an assert in the Modelica code.

``ModelicaFormatError``
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: c

    void ModelicaFormatError(const char* string, ...);

Output the error message under the same format control as the
C-function ``printf``. This function never returns to the calling
function, but handles the error similarly to an assert in the Modelica
code.

.. _modelica-format-error:

``ModelicaVFormatError``
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: c

    void ModelicaVFormatError(const char* string, va_list);

Output the error message under the same format control as the
C-function ``vprintf``. This function never returns to the calling
function, but handles the error similarly to an assert in the Modelica
code.

.. _modelica-allocate-string:

``ModelicaAllocateString``
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: c

    char* ModelicaAllocateString(size_t len);

Allocate memory for a Modelica string which is used as return argument
of an external Modelica function. Note, that the storage for string
arrays (= pointer to string array) is still provided by the calling
program, as for any other array. If an error occurs, this function
does not return, but calls :ref:`modelica-error`.

``ModelicaAllocateStringWithErrorReturn``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: c

    char* ModelicaAllocateStringWithErrorReturn(size_t len);

Same as :ref:`modelica-allocate-string`, except that in case of error,
the function returns 0. This allows the external function to close
files and free other open resources in case of error. After cleaning
up resources, use :ref:`modelica-error` or :ref:`modelica-format-error`
to signal the error.
