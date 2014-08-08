within ModelicaByExample.DiscreteBehavior.Accuracy;
model WithEvents "Integrate with events"
  parameter Real freq = 5.0;
  Real x(start=0);
  Real y = 0;
  Boolean active;
equation
  active = sin(2*Modelica.Constants.pi*freq*time)>0;
  der(x) = if active then 2.0 else -2.0;
end WithEvents;
