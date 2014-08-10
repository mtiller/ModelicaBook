.. _discrete-behavior:

Discrete Behavior
*****************

So far, all the examples we've seen have been of a purely continuous
nature.  This means that there have been no abrupt disturbances in the
system.  In this chapter, we'll focus on how to express what we call
"discrete behavior".  There are a wide variety of different
engineering use cases for describing such behavior and we'll explore
these through the various examples presented in this chapter.

Normally, when we talk about discrete behavior we often refer to
"events".  An event is something that occurs in our system that
triggers some kind of discontinuity.  Differential equations normally
result in continuous solutions.  But when events occur, they can
introduce various kinds of discontinuities.

.. index:: ! time events

The simplest types of events are ones that happen at a particular
time.  These are, not surprisingly, called "time events".  Because
these events are tied to time, we know what time they will occur even
before they happen.  Examples of time events would be things like
changes triggered by some kind of digital clock that is activated at
some specified frequency.

.. index:: ! state events

The other type of event we will encounter are so-called "state
events".  These kinds of events are much trickier to handle.  The
reason is that we do not know *a priori* when these events will
occur.  Unlike time events, we have to actually wait for some signal
in our system to cross some specified threshold.  Generally speaking,
we don't know when that crossing will occur.  Furthermore, determining
the precise moment when the event occurs is somewhat expensive.

In this chapter, we'll look at examples of both of these kinds of
events and the various Modelica language features that can be used to
describe when these events occur and how we describe responses to them.

Examples
========

.. toctree::
   :maxdepth: 1

   discrete/cooling
   discrete/bouncing
   discrete/decay
   discrete/switching
   discrete/measuring
   discrete/hysteresis
   discrete/sampling

Review
======

.. toctree::
   :maxdepth: 1

   discrete/events
   discrete/if
   discrete/when
