within ModelicaByExample.Components.Rotational.Components;
model Inertia "A rotational inertia model"
  parameter Modelica.SIunits.Inertia J;
  extends ModelicaByExample.Components.Rotational.Interfaces.TwoFlange;
  Modelica.SIunits.AngularVelocity w "Angular Velocity"
    annotation(Dialog(group="Initialization", showStartAttribute=true));
  Modelica.SIunits.Angle phi "Angle"
    annotation(Dialog(group="Initialization", showStartAttribute=true));
equation
  phi = flange_a.phi;
  w = der(flange_a.phi) "velocity of inertia";
  phi_rel = 0 "inertia is rigid";
  J*der(w) = flange_a.tau + flange_b.tau
    "Conservation of angular momentum with storage";
  annotation ( Icon(graphics={
        Rectangle(
          extent={{-100,10},{-50,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-50,50},{50,-50}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{50,10},{100,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Text(
          extent={{-100,-50},{100,-90}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-100,90},{100,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="J=%J")}));
end Inertia;
