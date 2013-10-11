within ModelicaByExample.Components.LotkaVolterra.Interfaces;
partial model Interaction "Used to describe interactions between two species"
  Species a "Species A"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Species b "Species B"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  Real a_growth "Growth in population of species A (if positive)";
  Real a_decline "Decline in population of species A (if positive)";
  Real b_growth "Growth in population of species B (if positive)";
  Real b_decline "Decline in population of species B (if positive)";
equation
  a_decline = -a_growth;
  a.rate = a_decline;
  b_decline = -b_growth;
  b.rate = b_decline;
  annotation (Icon(graphics={Text(
          extent={{-100,-100},{100,-140}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end Interaction;
