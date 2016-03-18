within ModelicaByExample.Components.Rotational.Components;
model Backlash "A rotational backlash model"
  parameter Modelica.SIunits.RotationalSpringConstant c "Torsional stiffness";
  parameter Modelica.SIunits.Angle b(final min=0) "Total lash";
  extends ModelicaByExample.Components.Rotational.Interfaces.Compliant;
equation
  if phi_rel>b/2 then
    tau = c*(phi_rel-b/2);
  elseif phi_rel<-b/2 then
    tau = c*(phi_rel+b/2);
  else
    tau = 0 "In the lash region";
  end if;
  annotation (Icon(graphics={
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
          textString="c=%c"),
        Line(
          points={{-100,-80},{-40,0},{40,0},{100,80}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-100,40},{100,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="b=%b")}));
end Backlash;
