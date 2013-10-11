within ModelicaByExample.Components.Electrical.DryApproach;
model Resistor "A DRY resistor model"
  parameter Modelica.SIunits.Resistance R;
  extends TwoPin;
equation
  v = i*R "Ohm's law";
  annotation (Icon(graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Line(points={{-96,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{96,0}}, color={0,0,255}),
        Text(
          extent={{-100,80},{100,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="R=%R")}));
end Resistor;
