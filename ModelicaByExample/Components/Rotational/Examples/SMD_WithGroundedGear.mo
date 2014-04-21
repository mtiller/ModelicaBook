within ModelicaByExample.Components.Rotational.Examples;
model SMD_WithGroundedGear
  "Spring mass damper system with coupled inertias and a grounded gear"

  Components.Ground ground annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={76,40})));
  Components.Damper damper2(d=1)
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Components.Spring spring2(c=5)
    annotation (Placement(transformation(extent={{28,10},{48,30}})));
  Components.Inertia inertia2(
    J=1,
    w(fixed=true, start=0),
    phi(displayUnit="rad", start=1, fixed=true))
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Components.Inertia inertia1(
    J=0.4,
    w(fixed=false, start=0),
    phi(fixed=false, start=0))
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Components.GroundedGear gear(ratio=2)
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Components.Ground ground1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={76,-40})));
  Components.Damper damper3(d=1)
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Components.Spring spring3(c=5)
    annotation (Placement(transformation(extent={{28,-70},{48,-50}})));
  Components.Inertia inertia3(
    w(fixed=true, start=0),
    phi(displayUnit="rad", fixed=true, start=1),
    J=1.6) annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(ground.flange_a, damper2.flange_b) annotation (Line(
      points={{70,40},{60,40},{60,60},{50,60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground.flange_a, spring2.flange_b) annotation (Line(
      points={{70,40},{60,40},{60,20},{48,20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper2.flange_a, inertia2.flange_b) annotation (Line(
      points={{30,60},{20,60},{20,40},{10,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(spring2.flange_a, inertia2.flange_b) annotation (Line(
      points={{28,20},{20,20},{20,40},{10,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(gear.flange_b, inertia2.flange_a) annotation (Line(
      points={{-30,40},{-10,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(gear.flange_a, inertia1.flange_b) annotation (Line(
      points={{-50,40},{-70,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground1.flange_a, damper3.flange_b) annotation (Line(
      points={{70,-40},{60,-40},{60,-20},{50,-20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground1.flange_a, spring3.flange_b) annotation (Line(
      points={{70,-40},{60,-40},{60,-60},{48,-60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper3.flange_a, inertia3.flange_b) annotation (Line(
      points={{30,-20},{20,-20},{20,-40},{10,-40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(spring3.flange_a, inertia3.flange_b) annotation (Line(
      points={{28,-60},{20,-60},{20,-40},{10,-40}},
      color={0,0,0},
      smooth=Smooth.None));
end SMD_WithGroundedGear;
