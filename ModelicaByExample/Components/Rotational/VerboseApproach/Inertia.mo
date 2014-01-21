within ModelicaByExample.Components.Rotational.VerboseApproach;
model Inertia "Rotational inertia without inheritance"
  parameter Modelica.SIunits.Inertia J;
  parameter Modelica.SIunits.RotationalDampingConstant d;
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
end Inertia;
