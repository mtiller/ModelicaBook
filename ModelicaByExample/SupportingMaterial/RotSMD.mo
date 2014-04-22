within ModelicaByExample.SupportingMaterial;
model RotSMD
  Modelica.Mechanics.Rotational.Components.Fixed ground annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,0})));
  Modelica.Mechanics.Rotational.Components.Spring spring2(c=5)
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Modelica.Mechanics.Rotational.Components.Damper damper2(d=1)
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Modelica.Mechanics.Rotational.Components.Inertia J2(
    J=1,
    stateSelect=StateSelect.prefer,
    phi(
      fixed=true,
      displayUnit="rad",
      start=1))
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Mechanics.Rotational.Components.Inertia J1(
    stateSelect=StateSelect.prefer,
    phi(
      displayUnit="rad",
      start=0,
      fixed=true),
    J=0.4) annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Mechanics.Rotational.Components.Spring spring1(c=11)
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Modelica.Mechanics.Rotational.Components.Damper damper1(d=0.2)
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
equation
  connect(J2.flange_b, spring2.flange_a) annotation (Line(
      points={{0,0},{10,0},{10,20},{20,20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(spring2.flange_b, ground.flange) annotation (Line(
      points={{40,20},{50,20},{50,0},{60,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper2.flange_a, J2.flange_b) annotation (Line(
      points={{20,-20},{10,-20},{10,0},{0,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper2.flange_b, ground.flange) annotation (Line(
      points={{40,-20},{50,-20},{50,0},{60,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(J2.flange_a, spring1.flange_b) annotation (Line(
      points={{-20,0},{-26,0},{-26,20},{-30,20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(J1.flange_b, spring1.flange_a) annotation (Line(
      points={{-60,0},{-56,0},{-56,20},{-50,20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper1.flange_b, J2.flange_a) annotation (Line(
      points={{-30,-20},{-26,-20},{-26,0},{-20,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper1.flange_a, J1.flange_b) annotation (Line(
      points={{-50,-20},{-56,-20},{-56,0},{-60,0}},
      color={0,0,0},
      smooth=Smooth.None));
end RotSMD;
