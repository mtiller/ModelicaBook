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
    phi(fixed=true, start=2),
    w(fixed=true, start=0))
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  Components.Inertia inertia1(J=1.4)
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  Components.GroundedGear grounded(ratio=2)
    annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));
  Components.Ground ground1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={76,0})));
  Components.Damper damper4(d=1)
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Components.Spring spring4(c=5)
    annotation (Placement(transformation(extent={{28,-30},{48,-10}})));
  Components.Inertia inertia4(
    J=1,
    w(fixed=true,start=0),
    phi(fixed=true, start=2))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Components.Inertia inertia3(J=1.4)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Components.UngroundedGear ungrounded(ratio=2)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Components.Ground ground2
    annotation (Placement(transformation(extent={{-50,-36},{-30,-16}})));
  Components.Ground ground3 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={76,70})));
  Components.Damper damper6(d=1)
    annotation (Placement(transformation(extent={{30,80},{50,100}})));
  Components.Spring spring6(c=5)
    annotation (Placement(transformation(extent={{28,40},{48,60}})));
  Components.Inertia inertia6(
    J=1,
    w(fixed=true, start=0),
    phi(fixed=true, start=2))
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Components.Inertia inertia5(
    J=1.4,
    w(fixed=true, start=0),
    phi(fixed=true, start=4))
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Components.UngroundedGear ungrounded1(ratio=2)
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  Components.Ground ground4 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-86,40})));
  Components.Spring mount_c(c=80)
    annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  Components.Damper mount_d(d=0.2)
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
  connect(ground1.flange_a,damper4. flange_b) annotation (Line(
      points={{70,0},{60,0},{60,20},{50,20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground1.flange_a,spring4. flange_b) annotation (Line(
      points={{70,0},{60,0},{60,-20},{48,-20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper4.flange_a,inertia4. flange_b) annotation (Line(
      points={{30,20},{20,20},{20,0},{10,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(spring4.flange_a,inertia4. flange_b) annotation (Line(
      points={{28,-20},{20,-20},{20,0},{10,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ungrounded.flange_b,inertia4. flange_a) annotation (Line(
      points={{-30,0},{-10,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ungrounded.flange_a, inertia3.flange_b) annotation (Line(
      points={{-50,0},{-70,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground2.flange_a, ungrounded.housing) annotation (Line(
      points={{-40,-20},{-40,-10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground3.flange_a,damper6. flange_b) annotation (Line(
      points={{70,70},{60,70},{60,90},{50,90}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground3.flange_a,spring6. flange_b) annotation (Line(
      points={{70,70},{60,70},{60,50},{48,50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper6.flange_a,inertia6. flange_b) annotation (Line(
      points={{30,90},{20,90},{20,70},{10,70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(spring6.flange_a,inertia6. flange_b) annotation (Line(
      points={{28,50},{20,50},{20,70},{10,70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ungrounded1.flange_b,inertia6. flange_a) annotation (Line(
      points={{-30,70},{-10,70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ungrounded1.flange_a, inertia5.flange_b) annotation (Line(
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
end SMD_GearComparison;
