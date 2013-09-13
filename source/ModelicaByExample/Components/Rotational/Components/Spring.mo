within ModelicaByExample.Components.Rotational.Components;
model Spring "A rotational spring component"
  parameter Modelica.SIunits.RotationalSpringConstant c;
  extends ModelicaByExample.Components.Rotational.Interfaces.Compliant;
equation
  tau = c*phi_rel "Hooke's Law";
  annotation (Icon(graphics={
        Line(
          points={{-100,0},{-58,0},{-43,-30},{-13,30},{17,-30},{47,30},{62,0},{100,
              0}},
          color={0,0,0},
          pattern=LinePattern.Solid,
          thickness=0.25,
          arrow={Arrow.None,Arrow.None}),
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
          textString="c=%c")}));
end Spring;
