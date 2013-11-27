
.. _bouncing-ball:

Bouncing Ball
-------------

In the :ref:`previous example <cooling-revisited>`, we saw how some
events are related to time.  These so-called time events are just one
type of event.  In this section, we'll examine the other type of
event, the state event.  A state event is an event that depends on the
solution trajectory.

State events are much more complicated to handle.  Unlike time events,
where the time of the event is known *a priori*, a state event depends
on the solution trajectory.  So we cannot entirely avoid the
"searching" for the point at which the event occurs.  
