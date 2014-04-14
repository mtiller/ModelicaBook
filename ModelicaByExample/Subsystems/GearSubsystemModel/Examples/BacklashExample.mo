within ModelicaByExample.Subsystems.GearSubsystemModel.Examples;
model BacklashExample "An example demonstrating the GearWithBacklash model"
  Components.GearWithBacklash gearWithBacklash(
    c=1000,
    d=2,
    ratio=4,
    J_a=0.01,
    J_b=0.02,
    useSupport=true,
    b=0.17453292519943)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Modelica.Mechanics.Rotational.Components.Fixed fixed
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
  Modelica.Mechanics.Rotational.Sources.Torque torque(useSupport=true)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J=0.1)
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Modelica.Mechanics.Rotational.Components.Damper load(d=2)
    annotation (Placement(transformation(extent={{32,-30},{52,-10}})));
  Modelica.Blocks.Sources.Trapezoid torque_profile(
    amplitude=2,
    offset=-1,
    period=0.8,
    width=0.4) "Torque signal to apply to system"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  connect(torque.flange, gearWithBacklash.flange_a) annotation (Line(
      points={{-10,0},{10,0}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(gearWithBacklash.flange_b, inertia.flange_a) annotation (Line(
      points={{30,0},{50,0}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(inertia.flange_b, load.flange_b) annotation (Line(
      points={{70,0},{80,0},{80,-20},{52,-20}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(torque.support, fixed.flange) annotation (Line(
      points={{-20,-10},{-20,-30}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(load.flange_a, fixed.flange) annotation (Line(
      points={{32,-20},{-20,-20},{-20,-30}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(gearWithBacklash.support, fixed.flange) annotation (Line(
      points={{20,-10},{20,-20},{-20,-20},{-20,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(torque_profile.y, torque.tau) annotation (Line(
      points={{-59,0},{-32,0}},
      color={0,0,127},
      smooth=Smooth.None));
end BacklashExample;
