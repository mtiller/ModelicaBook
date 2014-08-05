.. _msl:

Modelica Standard Library
-------------------------

The power of packages in Modelica is the ability to take commonly
needed types, models, functions, *etc.* and organize them into
packages for reuse later by simply referencing them (rather than
repeating them).  But there is still a repetition problem if every
user is expected to make their own packages of commonly needed
definitions.  For this reason, the Modelica Association maintain a
package called the Modelica Standard Library.  This library includes
definitions that are generally useful to scientists and engineers.

In this section, we will provide an overview of the Modelica Standard
Library so readers are aware of what they can expect to find and
utilize from this library.  This is not an exhaustive tour and because
the Modelica Standard Library is constantly being updated and improved,
it may not reflect the latest version of the library.  But it covers
the basics and hopefully providers readers with an understanding of
how to locate useful definitions.

.. _constants:

Constants
^^^^^^^^^

The Modelica Standard Library contains definitions of some common
physical and machine constants.  The library is small enough that we
can include the source code for this package directly.  The following
represents the ``Modelica.Constants`` package from version 3.2.1 of
the Modelica Standard Library (with a few cosmetic changes):

.. code-block:: modelica

    within Modelica;
    package Constants
      "Library of mathematical constants and constants of nature (e.g., pi, eps, R, sigma)"

      import SI = Modelica.SIunits;
      import NonSI = Modelica.SIunits.Conversions.NonSIunits;

      // Mathematical constants
      final constant Real e=Modelica.Math.exp(1.0);
      final constant Real pi=2*Modelica.Math.asin(1.0); // 3.14159265358979;
      final constant Real D2R=pi/180 "Degree to Radian";
      final constant Real R2D=180/pi "Radian to Degree";
      final constant Real gamma=0.57721566490153286060
	"see http://en.wikipedia.org/wiki/Euler_constant";

      // Machine dependent constants
      final constant Real eps=ModelicaServices.Machine.eps
        "Biggest number such that 1.0 + eps = 1.0";
      final constant Real small=ModelicaServices.Machine.small
	"Smallest number such that small and -small are representable on the machine";
      final constant Real inf=ModelicaServices.Machine.inf
	"Biggest Real number such that inf and -inf are representable on the machine";
      final constant Integer Integer_inf=ModelicaServices.Machine.Integer_inf
	"Biggest Integer number such that Integer_inf and -Integer_inf are representable on the machine";

      // Constants of nature
      // (name, value, description from http://physics.nist.gov/cuu/Constants/)
      final constant SI.Velocity c=299792458 "Speed of light in vacuum";
      final constant SI.Acceleration g_n=9.80665
	"Standard acceleration of gravity on earth";
      final constant Real G(final unit="m3/(kg.s2)") = 6.6742e-11
	"Newtonian constant of gravitation";
      final constant SI.FaradayConstant F = 9.64853399e4 "Faraday constant, C/mol";
      final constant Real h(final unit="J.s") = 6.6260693e-34 "Planck constant";
      final constant Real k(final unit="J/K") = 1.3806505e-23 "Boltzmann constant";
      final constant Real R(final unit="J/(mol.K)") = 8.314472 "Molar gas constant";
      final constant Real sigma(final unit="W/(m2.K4)") = 5.670400e-8
	"Stefan-Boltzmann constant";
      final constant Real N_A(final unit="1/mol") = 6.0221415e23
	"Avogadro constant";
      final constant Real mue_0(final unit="N/A2") = 4*pi*1.e-7 "Magnetic constant";
      final constant Real epsilon_0(final unit="F/m") = 1/(mue_0*c*c)
	"Electric constant";
      final constant NonSI.Temperature_degC T_zero=-273.15
	"Absolute zero temperature";

Noteworthy definitions are those for ``pi``, ``e``, ``g_n`` and
``eps``.

The first two, ``pi`` and ``e``, are mathematical constants
representing :math:`pi` and :math:`e`, respectively.  Having these
constants available not only avoids having to provide your own numerical
value for these (irrational) constants, but by using the version
defined in the Modelica Standard Library, you get a value that has the
highest possible precision.

The next constant, ``g_n``, is a physical constant representing the
gravitational constant on earth (for computing things like potential
energy, *i.e.,* :math:`m g h`).

Finally, ``eps`` is a machine constant that represents a "small
number" for whatever computing platform is being used.

SI Units
^^^^^^^^

As we discussed previously, the use of units not only makes your code
easier to understand by associating concrete units with parameters
and variables, it also allows unit consistency checking to be
performed by the Modelica compiler.  For this reason it is very useful
to associate physical types with parameters and variables whenever
possible.

The ``Modelica.SIunits`` package is very large and full of physical
units that are rarely used.  They are included for completeness in
adhering to the ``ISO 31-1992`` specification.  The following are
examples of how common physical units are defined in the ``SIunits`` package:

.. code-block:: modelica

    type Length = Real (final quantity="Length", final unit="m");
    type Radius = Length(min=0);
    ...
    type Velocity = Real (final quantity="Velocity", final unit="m/s");
    type AngularVelocity = Real(final quantity="AngularVelocity",
                                final unit="rad/s");
    ...
    type Mass = Real(quantity="Mass", final unit="kg", min=0);
    type Density = Real(final quantity="Density", final unit="kg/m3",
                        displayUnit="g/cm3", min=0.0);
    type MomentOfInertia = Real(final quantity="MomentOfInertia",
                                final unit="kg.m2");
    ...
    type Pressure = Real(final quantity="Pressure", final unit="Pa",
                         displayUnit="bar");
    ...
    type ThermodynamicTemperature = Real(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      min = 0.0,
      start = 288.15,
      nominal = 300,
      displayUnit="degC")
    "Absolute temperature (use type TemperatureDifference for relative temperatures)";
    type Temperature = ThermodynamicTemperature;
    type TemperatureDifference = Real(final quantity="ThermodynamicTemperature",
                                      final unit="K");

Models
^^^^^^

The Modelica Standard Library includes many different domain specific
libraries inside of it.  This section provides an overview of each of
these domains and discusses how models in each domain are organized.

Blocks
~~~~~~

The Modelica Standard Library includes a collection of models for
building causal, block-diagram models.  The definitions for these
models can be found in the ``Modelica.Blocks`` package.  Examples of
components that can be found in this library include:

  * Input connectors (``Real``, ``Integer`` and ``Boolean``)
  * Output connectors (``Real``, ``Integer`` and ``Boolean``)
  * Gain block, summation blocks, product blocks
  * Integration and differentiation blocks
  * Deadband and hyteresis blocks
  * Logic and relational operation blocks
  * Mux and demux blocks

The ``Blocks`` package contains a wide variety of blocks for
performing operations on signals.  Such blocks are typically used for
describing the function of control systems and strategies.

Electrical
~~~~~~~~~~

The ``Modelica.Electrical`` package contains sub-packages specifically
related to analog, digital and multi-phase electrical systems.  It
also includes a library of basic electrical machines as well.  In this
library you will find components like:

  * Resistors, capacitors, inductors
  * Voltage and current actuators
  * Voltage and current sensors
  * Transistor and other semiconductor related models
  * Diodes and switches
  * Logic gates
  * Star and Delta connections (multi-phase)
  * Synchronous and Asynchronous machines
  * Motor models (DC, permanent magnet, *etc.*)
  * Spice3 models

Mechanical
~~~~~~~~~~

The ``Modelica.Mechanics`` library contains three main libraries.

``Translational``
=================

The translational library contains component models used for modeling
one-dimensional translational motion.  This library contains
components like:

  * Springs, dampers and backlashes
  * Masses
  * Sensors and actuators
  * Friction

``Rotational``
==============

The rotational library contains component models used for modeling
one-dimensional rotational motion.  This library contains components
like:

  * Springs, dampers and backlashes
  * Inertias
  * Clutches and Brakes
  * Gears
  * Sensors and Actuators

``MultiBody``
=============

The multibody library contains component models used for modeling
three-dimensional mechanical systems.  This library contains components
like:

  * Bodies (including associated inertia tensors and 3D CAD geometry)
  * Joints (*e.g.,* prismatic, revolute, universal)
  * Sensors and Actuators

Fluids and Media
~~~~~~~~~~~~~~~~

There are two packages within the Modelica Standard Library associated
with modeling fluid systems.  The first is ``Modelica.Media`` which is
a library of property models for various media like:

  * Ideal gases (based on NASA Glenn coefficient data)
  * Air (dry, reference, moist)
  * Water (simple, salt, two-phase)
  * Generic incompressible fluids
  * R134a (tetrafluoroethane) refrigerant

These property models provide functions for computing fluid properties
like enthalpy, density and specific heat ratios for a variety of pure
fluids and mixtures.

In addition to these medium models, the Modelica Standard Library also
includes the ``Modelica.Fluid`` library which is a library of
components to describe fluid devices, for example:

  * Volumes, tanks and junctions
  * Pipes
  * Pumps
  * Valves
  * Pressure losses
  * Heat exchangers
  * Sources and ambient conditions

Magnetics
~~~~~~~~~

The ``Modelica.Magnetic`` library contains two sub-packages.  The
first is the ``FluxTubes`` package which is used to construct models
of lumped networks of magnetic components.  This includes components
to represent the magnetic characteristics of basic cylindrical and
prismatic geometries as well as sensors and actuators.  The other is
the ``FundamentalWave`` library which is used to model electrical
fields in rotating electrical machinery.

Thermal
~~~~~~~

The ``Modelica.Thermal`` package has two sub-packages:

``HeatTransfer``
================

The ``HeatTransfer`` is for modeling heat transfer in lumped solids.
Models in this library can be used to build lumped thermal network
models using components like:

  * Lumped thermal capacitances
  * Conduction
  * Convection
  * Radiation
  * Ambient conditions
  * Sensors

``FluidHeatFlow``
=================

Normally, the ``Modelica.Fluid`` and ``Modelica.Media`` libraries
should be used to model thermo-fluid systems because they are capable
of handling a wide range of problems involving complex media and
multiple phases.  However, for a certain class of simpler problems,
the ``FluidHeatFlow`` library can be used to build simple flow
networks of thermo-fluid systems.

Utilities
^^^^^^^^^

The ``Utilities`` library provides support functionality to other
libraries and model developers.  It includes several sub-packages for
dealing with non-mathematical aspects of modeling.

``Files``
~~~~~~~~~

The ``Modelica.Utilities.Files`` library provides functions for
accessing and manipulating a computers file system.  The following
functions are provided by the ``Files`` package:

  * ``list`` - List contents of a file or directory
  * ``copy`` - Copy a file or directory
  * ``move`` - Move a file or directory
  * ``remove`` - Remove a file or directory
  * ``createDirectory`` - Create a directory
  * ``exist`` - Test whether a given file or directory already exists
  * ``fullPathName`` - Determine the full path to a named file or directory
  * ``splitPathName`` - Split a file name by path
  * ``temporaryFileName`` - Return the name of a temporary file that
    does not already exist.
  * ``loadResource`` - Convert a :ref:`Modelica URL <modelica-urls>`
    into an absolute file system path (for use with functions that
    don't accept Modelica URLs).


``Streams``
~~~~~~~~~~~

The ``Streams`` package is used reading and writing data to and from
the terminal or files.  It includes the following functions:

  * ``print`` - Writes data to either the terminal or a file.
  * ``readFile`` - Reads data from a file and return a vector
    of strings representing the lines in the file.
  * ``readLine`` - Reads a single line of text from a file.
  * ``countLines`` - Returns the number of lines in a file.
  * ``error`` - Used to print an error message.
  * ``close`` - Closes a file.

``Strings``
~~~~~~~~~~~

The ``Strings`` package contains functions that operate on strings.
The general capabilities of this library include:

  * Find the length of a string
  * Constructing and extracting strings
  * Comparing strings
  * Parsing and searching strings

``System``
~~~~~~~~~~

The ``System`` package is used to interact with the underlying
operating system.  It includes the following functions:

  * ``getWorkingDirectory`` - Get the current working directory.
  * ``setWorkingDirectory`` - Set the current working directory.
  * ``getEnvironmentVariable`` - Get the value of an environment
    variable.
  * ``setEnvironmentVariable`` - Set the value of an environment variable.
  * ``command`` - Pass a command to the operating system to execute.
  * ``exit`` - Terminate execution.
