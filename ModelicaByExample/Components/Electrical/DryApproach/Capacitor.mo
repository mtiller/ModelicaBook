within ModelicaByExample.Components.Electrical.DryApproach;
model Capacitor "A DRY capacitor model"
  parameter Modelica.SIunits.Capacitance C;
  extends TwoPin;
equation
  C*der(v) = i;
  annotation (Icon(graphics={
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
