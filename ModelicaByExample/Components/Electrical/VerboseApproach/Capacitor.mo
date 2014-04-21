within ModelicaByExample.Components.Electrical.VerboseApproach;
model Capacitor "A capacitor model"
  parameter Modelica.SIunits.Capacitance C;
  Modelica.Electrical.Analog.Interfaces.PositivePin p
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  Modelica.SIunits.Voltage v = p.v-n.v;
equation
  p.i + n.i = 0 "Conservation of charge";
  C*der(v) = p.i;
  annotation ( Icon(graphics={
        Text(
          extent={{-100,-40},{100,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-100,80},{100,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="C=%C"),
        Line(points={{-90,0},{-14,0}}, color={0,0,255}),
        Line(
          points={{-14,28},{-14,-28}},
          thickness=0.5,
          color={0,0,255}),
        Line(
          points={{14,28},{14,-28}},
          thickness=0.5,
          color={0,0,255}),
        Line(points={{14,0},{90,0}}, color={0,0,255})}));
end Capacitor;
