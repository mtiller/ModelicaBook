within ModelicaByExample.Components.Rotational.Components;
model ConfigurableGear
  "An ideal non-reversing gear which can be free or grounded"
  parameter Real ratio "Ratio of phi_a/phi_b";
  parameter Boolean grounded(start=false) "Set if housing should be grounded";
  extends Interfaces.TwoFlange;
  Modelica.Mechanics.Rotational.Interfaces.Flange_b housing(phi=housing_phi,
  tau = -flange_a.tau-flange_b.tau) if not grounded "Connection for housing"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
protected
  Modelica.SIunits.Angle housing_phi;
equation
  if grounded then
    housing_phi = 0;
  end if;
  (1-ratio)*housing_phi = flange_a.phi - ratio*flange_b.phi;
  flange_b.tau = -ratio*flange_a.tau;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,10},{-40,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-40,20},{-20,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-40,100},{-20,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-20,70},{20,50}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{20,80},{40,39}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{20,40},{40,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{40,10},{100,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="ratio=%ratio"),
        Text(
          extent={{-100,-40},{100,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end ConfigurableGear;
