within ModelicaByExample.Components.Rotational.Examples;
model SMD_ConfigurableGear
  "Use case using configurable gear in two different ways"

  Components.Ground ground annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={76,-40})));
  Components.Damper damper2(d=1)
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Components.Spring spring2(c=5)
    annotation (Placement(transformation(extent={{28,-70},{48,-50}})));
  Components.Inertia inertia2(
    J=1,
    phi(fixed=true,start=0.2),
    w(fixed=true,start=0))
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Components.Inertia inertia1(J=0.4)
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Components.Ground ground1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={76,40})));
  Components.Damper damper3(d=1)
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Components.Spring spring3(c=5)
    annotation (Placement(transformation(extent={{28,10},{48,30}})));
  Components.Inertia inertia3(
    J=1, phi(start=0.2, fixed=true),
    w(fixed=true,start=0))
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Components.Inertia inertia4(J=0.4)
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Components.ConfigurableGear no_housing(ratio=2, grounded=true)
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Components.ConfigurableGear housing(ratio=2, grounded=false)
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Components.Ground ground2
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
equation
  connect(ground.flange_a, damper2.flange_b) annotation (Line(
      points={{70,-40},{60,-40},{60,-20},{50,-20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground.flange_a, spring2.flange_b) annotation (Line(
      points={{70,-40},{60,-40},{60,-60},{48,-60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper2.flange_a, inertia2.flange_b) annotation (Line(
      points={{30,-20},{20,-20},{20,-40},{10,-40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(spring2.flange_a, inertia2.flange_b) annotation (Line(
      points={{28,-60},{20,-60},{20,-40},{10,-40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground1.flange_a,damper3. flange_b) annotation (Line(
      points={{70,40},{60,40},{60,60},{50,60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground1.flange_a,spring3. flange_b) annotation (Line(
      points={{70,40},{60,40},{60,20},{48,20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper3.flange_a, inertia3.flange_b) annotation (Line(
      points={{30,60},{20,60},{20,40},{10,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(spring3.flange_a, inertia3.flange_b) annotation (Line(
      points={{28,20},{20,20},{20,40},{10,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ground2.flange_a, housing.housing) annotation (Line(
      points={{-40,16},{-40,30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(housing.flange_a, inertia4.flange_b) annotation (Line(
      points={{-50,40},{-70,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(housing.flange_b, inertia3.flange_a) annotation (Line(
      points={{-30,40},{-10,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(no_housing.flange_a, inertia1.flange_b) annotation (Line(
      points={{-50,-40},{-70,-40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(no_housing.flange_b, inertia2.flange_a) annotation (Line(
      points={{-30,-40},{-20,-40},{-20,-40},{-10,-40}},
      color={0,0,0},
      smooth=Smooth.None));
end SMD_ConfigurableGear;
