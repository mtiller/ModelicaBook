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
the Modelica Standard Library is constantly be updated and improved,
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
constants available not only avoids having provide your own numerical
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
easier to understand, by associating concrete units with parameters
and variables, it also allows unit consistency checking to be
performed by the Modelica compiler.  For this reason it is very useful
to associate physical types with parameters and variables whenever
possible.

The ``Modelica.SIunits`` package is very large and full of physical
units that are rarely used.  They are included for completeness in
adhering to the ```ISO 31-1992`` specification.  The following are
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

Blocks
~~~~~~

Electrical
~~~~~~~~~~

Mechanical
~~~~~~~~~~

Fluids and Media
~~~~~~~~~~~~~~~~

Magnetics
~~~~~~~~~

Thermal
~~~~~~~

Utilities
^^^^^^^^^

Files
~~~~~

Streams
~~~~~~~

Strings
~~~~~~~

System
~~~~~~

