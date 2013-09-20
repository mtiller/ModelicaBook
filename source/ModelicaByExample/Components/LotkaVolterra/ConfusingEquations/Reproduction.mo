within ModelicaByExample.Components.LotkaVolterra.ConfusingEquations;
model Reproduction "A model of reproduction"
  Interfaces.Species species
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  parameter Real alpha "Birth rate";
equation
  species.rate = -alpha*species.population;
end Reproduction;
