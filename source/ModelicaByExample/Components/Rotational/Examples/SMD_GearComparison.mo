within ModelicaByExample.Components.Rotational.Examples;
model SMD_GearComparison "Use case using both grounded and ungrounded gears"

  Components.Ground ground annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={76,-70})));
  Components.Damper damper2(d=1)
    annotation (Placement(transformation(extent={{30,-60},{50,-40}})));
  Components.Spring spring2(c=5)
    annotation (Placement(transformation(extent={{28,-100},{48,-80}})));
  Components.Inertia inertia2(
    J=1,
    phi0(displayUnit="rad") = 0.2,
    w0=0)
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  Components.Inertia inertia1(
    J=0.4,
    w0(fixed=false) = 0,
    phi0(
      fixed=false,
      displayUnit="rad") = 0.2)
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  Components.GroundedGear grounded(ratio=2)
    annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));
  Components.Ground ground1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={76,0})));
  Components.Damper damper1(d=1)
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Components.Spring spring1(c=5)
    annotation (Placement(transformation(extent={{28,-30},{48,-10}})));
  Components.Inertia inertia3(
    J=1,
    phi0(displayUnit="rad") = 0.2,
    w0=0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Components.Inertia inertia4(
    J=0.4,
    w0(fixed=false) = 0,
    phi0(
      fixed=false,
      displayUnit="rad") = 0.2)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Components.UngroundedGear ungrounded(ratio=2)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Components.Ground ground2
    annotation (Placement(transformation(extent={{-50,-36},{-30,-16}})));
  Components.Ground ground3 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={76,70})));
  Components.Damper damper3(d=1)
    annotation (Placement(transformation(extent={{30,80},{50,100}})));
  Components.Spring spring3(c=5)
    annotation (Placement(transformation(extent={{28,40},{48,60}})));
  Components.Inertia inertia5(
    J=1,
    w0=0,
    phi0(displayUnit="rad") = 0.2)
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Components.Inertia inertia6(
    J=0.4,
    w0 = 0,
    phi0(displayUnit="rad") = 0.2)
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Components.UngroundedGear ungrounded1(ratio=2)
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  Components.Ground ground4 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-86,40})));
  Components.Spring mount_c(c=80)
    annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  Components.Damper mount_d(d=1)
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
equation
  connect(ground.flange_a, damper2.flange_b) annotation (Line(
      points={{70,-70},{60,-70},{60,-50},{50,-50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground.flange_a, spring2.flange_b) annotation (Line(
      points={{70,-70},{60,-70},{60,-90},{48,-90}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper2.flange_a, inertia2.flange_b) annotation (Line(
      points={{30,-50},{20,-50},{20,-70},{10,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(spring2.flange_a, inertia2.flange_b) annotation (Line(
      points={{28,-90},{20,-90},{20,-70},{10,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(grounded.flange_b, inertia2.flange_a) annotation (Line(
      points={{-30,-70},{-10,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(grounded.flange_a, inertia1.flange_b) annotation (Line(
      points={{-50,-70},{-70,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground1.flange_a, damper1.flange_b) annotation (Line(
      points={{70,3.67394e-016},{60,3.67394e-016},{60,20},{50,20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground1.flange_a, spring1.flange_b) annotation (Line(
      points={{70,3.67394e-016},{60,3.67394e-016},{60,-20},{48,-20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper1.flange_a, inertia3.flange_b) annotation (Line(
      points={{30,20},{20,20},{20,0},{10,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(spring1.flange_a, inertia3.flange_b) annotation (Line(
      points={{28,-20},{20,-20},{20,0},{10,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ungrounded.flange_b, inertia3.flange_a) annotation (Line(
      points={{-30,0},{-10,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ungrounded.flange_a, inertia4.flange_b) annotation (Line(
      points={{-50,0},{-70,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground2.flange_a, ungrounded.housing) annotation (Line(
      points={{-40,-20},{-40,-10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground3.flange_a, damper3.flange_b) annotation (Line(
      points={{70,70},{60,70},{60,90},{50,90}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground3.flange_a, spring3.flange_b) annotation (Line(
      points={{70,70},{60,70},{60,50},{48,50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper3.flange_a, inertia5.flange_b) annotation (Line(
      points={{30,90},{20,90},{20,70},{10,70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(spring3.flange_a, inertia5.flange_b) annotation (Line(
      points={{28,50},{20,50},{20,70},{10,70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ungrounded1.flange_b, inertia5.flange_a) annotation (Line(
      points={{-30,70},{-10,70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ungrounded1.flange_a, inertia6.flange_b) annotation (Line(
      points={{-50,70},{-70,70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(mount_d.flange_b, ungrounded1.housing) annotation (Line(
      points={{-50,30},{-40,30},{-40,60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(mount_c.flange_b, ungrounded1.housing) annotation (Line(
      points={{-50,50},{-40,50},{-40,60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground4.flange_a, mount_c.flange_a) annotation (Line(
      points={{-80,40},{-76,40},{-76,50},{-70,50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground4.flange_a, mount_d.flange_a) annotation (Line(
      points={{-80,40},{-76,40},{-76,30},{-70,30}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end SMD_GearComparison;
