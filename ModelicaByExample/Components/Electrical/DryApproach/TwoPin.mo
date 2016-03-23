within ModelicaByExample.Components.Electrical.DryApproach;
partial model TwoPin "Common elements of two pin electrical components"
  Modelica.Electrical.Analog.Interfaces.PositivePin p
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.SIunits.Voltage v = p.v-n.v;
  Modelica.SIunits.Current i = p.i;
equation
  p.i + n.i = 0 "Conservation of charge";
  annotation (Icon(graphics={
        Text(
          extent={{-100,-40},{100,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end TwoPin;
