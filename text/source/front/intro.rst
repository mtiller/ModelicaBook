Introduction
============

If, for some reason, you are coming upon this book without any
previous knowledge of Modelica, there are probably a couple of
questions you have.  Let me attempt to address these questions in the
hope that they will intrigue you and cause you to dig deeper.

What is Modelica?
-----------------

Modelica is a high-level declarative language for describing
mathematical behavior.  It is typically applied to engineering systems
and can be used to easily describe the behavior of different types of
engineering components (*e.g.,* springs, resistors, clutches,
*etc.*).  These components can then be combined into subsystems,
systems or even architectures.

Why Modelica?
-------------

Modelica is compelling for several reasons.  First and foremost, it is
technically very capable.  By using complex algorithms behind the
scenes, Modelica compilers allow engineers to focus on high-level
mathematical descriptions of component behavior and get high
performance simulation capability in return without having to be
deeply knowledgeable about complex topics like differential-algebraic
equations, symbolic manipulation, numeric solvers, code generation,
post-processing, *etc.*.

The key to Modelica's technical success is its support for a wide
range of modeling formalisms that allow the description of both
continuous and discrete behavior framed in the context of hybrid
differential-algebraic equations.  The language supports both causal
(often used for control system design) and acausal (often used in
creating schematic oriented physical designs) approaches *within the
same model*.

Finally, another compelling aspect of Modelica is the fact that it was
designed from the start as an open language.  The specification is
freely available and tool vendors are encouraged to support the
import and export of Modelica (without being compelled to pay any
royalty of any kind).

What Modelica allows me to do
-----------------------------

Modelica is really an ideal language for modeling the behavior of
engineering systems in nearly any engineering domain.  It seamlessly
supports both physical design and control design in a single language.
It is also multi-domain so it doesn't impose any artificial boundaries
that restrict its use to select engineering domains or systems.  The
result is that it provides a complete set of capabilities for building
lumped system models of nearly any engineering system.
