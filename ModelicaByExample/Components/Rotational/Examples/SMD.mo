within ModelicaByExample.Components.Rotational.Examples;
model SMD
  Components.Ground ground annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={76,0})));
  Components.Damper damper2(d=1)
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Components.Spring spring2(c=5)
    annotation (Placement(transformation(extent={{28,-30},{48,-10}})));
  Components.Inertia inertia2(
    J=1,
    phi(fixed=true, start=1),
    w(fixed=true, start=0))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Components.Damper damper1(d=0.2)
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Components.Spring spring1(c=11)
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Components.Inertia inertia1(
    J=0.4,
    phi(fixed=true, start=0),
    w(fixed=true, start=0))
          annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
equation
  connect(ground.flange_a, damper2.flange_b) annotation (Line(
      points={{70,0},{66,0},{66,0},{60,0},{60,20},{50,20}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(ground.flange_a, spring2.flange_b) annotation (Line(
      points={{70,0},{60,0},{60,-20},{48,-20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper2.flange_a, inertia2.flange_b) annotation (Line(
      points={{30,20},{20,20},{20,0},{10,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(spring2.flange_a, inertia2.flange_b) annotation (Line(
      points={{28,-20},{20,-20},{20,0},{10,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(inertia2.flange_a, damper1.flange_b) annotation (Line(
      points={{-10,0},{-20,0},{-20,20},{-30,20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(inertia2.flange_a, spring1.flange_b) annotation (Line(
      points={{-10,0},{-20,0},{-20,-20},{-30,-20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper1.flange_a, inertia1.flange_b) annotation (Line(
      points={{-50,20},{-60,20},{-60,0},{-70,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(spring1.flange_a, inertia1.flange_b) annotation (Line(
      points={{-50,-20},{-60,-20},{-60,0},{-70,0}},
      color={0,0,0},
      smooth=Smooth.None));
end SMD;
