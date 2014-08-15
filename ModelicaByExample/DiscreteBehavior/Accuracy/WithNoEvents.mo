within ModelicaByExample.DiscreteBehavior.Accuracy;
model WithNoEvents "Integrate without events"
  parameter Real freq = 1.0;
  Real x(start=0);
  Real y = time;
equation
  der(x) = noEvent(if sin(2*Modelica.Constants.pi*freq*time)>0 then 2.0 else 0.0);
end WithNoEvents;
