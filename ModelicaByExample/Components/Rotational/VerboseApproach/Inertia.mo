within ModelicaByExample.Components.Rotational.VerboseApproach;
model Inertia "Rotational inertia without inheritance"
  parameter Modelica.SIunits.Inertia J;
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  Modelica.SIunits.Angle phi_rel;
  Modelica.SIunits.Torque tau;
  Modelica.SIunits.AngularVelocity w;
equation
  // Variables
  phi_rel = flange_a.phi-flange_b.phi;
  tau = flange_a.tau;
  w = der(flange_a.phi);

  // Conserviation of angular momentum (includes storage)
  J*der(w) = flange_a.tau + flange_b.tau;

  // Kinematic constraint (inertia is rigid)
  phi_rel = 0;
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
