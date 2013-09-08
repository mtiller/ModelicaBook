within ModelicaByExample.Components.Electrical.DryApproach;
model StepVoltage "A DRY step voltage source"
  parameter Modelica.SIunits.Voltage V0;
  parameter Modelica.SIunits.Voltage Vf;
  parameter Modelica.SIunits.Time stepTime;
  extends TwoPin;
equation
  v = if time>=stepTime then Vf else V0;
  annotation (Icon(graphics={
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-40,0},{-90,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{90,0},{40,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-60,24},{-60,16}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-64,20},{-56,20}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{56,20},{64,20}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-20,-20},{0,-20},{0,20},{20,20}},
          color={0,0,255},
          smooth=Smooth.None)}));
end StepVoltage;
