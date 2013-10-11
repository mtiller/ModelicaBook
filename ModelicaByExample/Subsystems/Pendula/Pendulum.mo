within ModelicaByExample.Subsystems.Pendula;
model Pendulum "A single individual pendulum"
  parameter Modelica.SIunits.Position x;
  Modelica.Mechanics.MultiBody.Parts.Fixed ground(r={0,0,x}, animation=false)
                                                  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,60})));
  Modelica.Mechanics.MultiBody.Parts.PointMass ball(m=m, sphereDiameter=5*d)
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  parameter Modelica.SIunits.Mass m "Mass of mass point";
  Modelica.Mechanics.MultiBody.Parts.BodyCylinder string(
    density=0,
    r={0,L,0},
    diameter=d)
               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-30})));
  Modelica.Mechanics.MultiBody.Joints.Revolute revolute(phi(fixed=true, start=
          phi),
    cylinderDiameter=d/2,
    animation=false)                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,20})));
  parameter Modelica.SIunits.Angle phi "Initial angle";
  parameter Modelica.SIunits.Length L "String length";
  parameter Modelica.SIunits.Diameter d=0.01;
equation
  connect(string.frame_a, ball.frame_a) annotation (Line(
      points={{-6.12323e-016,-40},{0,-40},{0,-80}},
      color={95,95,95},
      thickness=0.5,
      smooth=Smooth.None));
  connect(revolute.frame_b, ground.frame_b) annotation (Line(
      points={{6.12323e-016,30},{6.12323e-016,40},{-1.83697e-015,40},{
          -1.83697e-015,50}},
      color={95,95,95},
      thickness=0.5,
      smooth=Smooth.None));
  connect(revolute.frame_a, string.frame_b) annotation (Line(
      points={{-6.12323e-016,10},{0,10},{0,-20},{6.12323e-016,-20}},
      color={95,95,95},
      thickness=0.5,
      smooth=Smooth.None));
end Pendulum;
