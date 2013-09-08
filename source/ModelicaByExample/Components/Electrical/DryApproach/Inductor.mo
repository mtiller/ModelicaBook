within ModelicaByExample.Components.Electrical.DryApproach;
model Inductor "A DRY inductor model"
  parameter Modelica.SIunits.Inductance L;
  extends TwoPin;
equation
  L*der(i) = v;
  annotation (Icon(graphics={
        Text(
          extent={{-100,80},{100,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="L=%L"),
        Ellipse(extent={{-60,-15},{-30,15}}, lineColor={0,0,255}),
        Ellipse(extent={{-30,-15},{0,15}}, lineColor={0,0,255}),
        Ellipse(extent={{0,-15},{30,15}}, lineColor={0,0,255}),
        Ellipse(extent={{30,-15},{60,15}}, lineColor={0,0,255}),
        Rectangle(
          extent={{-60,-30},{60,0}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{60,0},{90,0}}, color={0,0,255}),
        Line(points={{-90,0},{-60,0}}, color={0,0,255})}));
end Inductor;
