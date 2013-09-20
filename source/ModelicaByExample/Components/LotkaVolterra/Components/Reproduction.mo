within ModelicaByExample.Components.LotkaVolterra.Components;
model Reproduction "Model of reproduction"
  extends Interfaces.SinkOrSource;
  parameter Real alpha "Birth rate";
equation
  growth = alpha*species.population "Growth is proporational to population";
end Reproduction;
