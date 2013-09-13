within ModelicaByExample.Components.Rotational.Components;
model Damper "A rotational damper"
  parameter Modelica.SIunits.RotationalDampingConstant d;
  extends ModelicaByExample.Components.Rotational.Interfaces.Compliant;
equation
  tau = d*der(phi_rel) "Damping relationship";
  annotation (Icon(graphics={
        Line(points={{-100,0},{-70,0}},color={0,0,0}),
        Rectangle(
          extent={{-70,30},{20,-30}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-70,30},{50,30}}, color={0,0,0}),
        Line(points={{20,0},{80,0}}, color={0,0,0}),
        Line(points={{-70,-30},{50,-30}}, color={0,0,0}),
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
          textString="d=%d")}));
end Damper;
