within ModelicaByExample.Components.SpeedMeasurement.Examples;
model Plant "The basic plant model"
  Modelica.Mechanics.Rotational.Components.Fixed fixed
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                          rotation=0, origin={60,-30})));
  Modelica.Mechanics.Rotational.Components.Damper damper(d=0.1)
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J=0.1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Rotational.Sources.Torque torque(useSupport=true)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=5, freqHz=1, phase=0,
    startTime=0, offset=0.5)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Components.IdealSensor idealSensor
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                          rotation=90, origin={-20,30})));
equation
  connect(damper.flange_b, fixed.flange) annotation (Line(
      points={{50,0},{60,0},{60,-30}}, color={0,0,0},
      pattern=LinePattern.None, smooth=Smooth.None));
  connect(inertia.flange_b, damper.flange_a) annotation (Line(
      points={{10,0},{30,0}}, color={0,0,0},
      pattern=LinePattern.None, smooth=Smooth.None));
  connect(torque.flange, inertia.flange_a) annotation (Line(
      points={{-30,0},{-10,0}}, color={0,0,0},
      pattern=LinePattern.None, smooth=Smooth.None));
  connect(torque.support, fixed.flange) annotation (Line(
      points={{-40,-10},{-40,-30},{60,-30}}, color={0,0,0},
      pattern=LinePattern.None, smooth=Smooth.None));
  connect(sine.y, torque.tau) annotation (Line(
      points={{-69,0},{-52,0}}, color={0,0,127},
      pattern=LinePattern.None, smooth=Smooth.None));
  connect(idealSensor.flange, inertia.flange_a) annotation (Line(
      points={{-20,20},{-20,0},{-10,0}}, color={0,0,0},
      pattern=LinePattern.None, smooth=Smooth.None));
  annotation(experiment(StopTime=10, Tolerance=1e-006));
end Plant;
