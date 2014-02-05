within ModelicaByExample.Components.Rotational.Components;
model UngroundedGear "An ideal non-reversing gear with a free housing"
  parameter Real ratio "Ratio of phi_a/phi_b";
  extends Interfaces.TwoFlange;
  Modelica.Mechanics.Rotational.Interfaces.Flange_b housing
    "Connection for housing"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
equation
  (1-ratio)*housing.phi = flange_a.phi - ratio*flange_b.phi;
  flange_b.tau = -ratio*flange_a.tau;
  housing.tau = -(1-ratio)*flange_a.tau;
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
end UngroundedGear;
