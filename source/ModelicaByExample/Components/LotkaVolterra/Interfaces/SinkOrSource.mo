within ModelicaByExample.Components.LotkaVolterra.Interfaces;
partial model SinkOrSource "Used to describe single species effects"

  Species species
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
protected
  Real growth "Growth in the population (if positive)";
  Real decline "Decline in the population (if positive)";
equation
  decline = -growth;
  species.rate = decline;
end SinkOrSource;
