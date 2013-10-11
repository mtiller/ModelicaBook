within ModelicaByExample.Components.LotkaVolterra.ConfusingEquations;
model Predation "Model of predation between two species"
  parameter Real beta "Prey consume";
  parameter Real delta "Predators fed";
  Interfaces.Species prey
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.Species predator
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  prey.rate = beta*prey.population*predator.population;
  predator.rate = -delta*prey.population*predator.population;
end Predation;
