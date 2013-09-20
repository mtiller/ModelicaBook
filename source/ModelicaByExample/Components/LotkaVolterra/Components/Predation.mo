within ModelicaByExample.Components.LotkaVolterra.Components;
model Predation "Model of predation"
  extends Interfaces.Interaction;
  parameter Real beta "Prey (Species A) consumed";
  parameter Real delta "Predators (Species B) fed";
equation
  b_growth = delta*a.population*b.population;
  a_decline = beta*a.population*b.population;
end Predation;
