within ModelicaByExample.Components.LotkaVolterra.Components;
model Starvation "Model of starvation"
  extends Interfaces.SinkOrSource;
  parameter Real gamma "Starvation coefficient";
equation
  decline = gamma*species.population
    "Decline is proporational to population (competition)";
end Starvation;
