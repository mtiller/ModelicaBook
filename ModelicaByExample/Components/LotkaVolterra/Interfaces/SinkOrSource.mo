within ModelicaByExample.Components.LotkaVolterra.Interfaces;
partial model SinkOrSource "Used to describe single species effects"

  Species species
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
protected
  Real growth "Growth in the population (if positive)";
  Real decline "Decline in the population (if positive)";
equation
  decline = -growth;
  species.rate = decline;
  annotation (Icon(graphics={Text(
          extent={{-100,-100},{100,-140}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end SinkOrSource;
