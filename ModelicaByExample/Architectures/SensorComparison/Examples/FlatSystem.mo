within ModelicaByExample.Architectures.SensorComparison.Examples;
model FlatSystem "A rotational system with no architecture"
  Modelica.Mechanics.Rotational.Components.Fixed fixed
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J=0.1)
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(J=0.3)
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Modelica.Mechanics.Rotational.Sources.Torque torque(useSupport=true)
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Mechanics.Rotational.Components.SpringDamper springDamper(c=100, d=3)
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Modelica.Mechanics.Rotational.Components.Damper damper(d=4)
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}}, rotation=90, origin={70,0})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={70,40})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(period=1.0)
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Modelica.Blocks.Math.Gain gain(k=20) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180, origin={-30,40})));
equation
  connect(springDamper.flange_a, inertia.flange_b) annotation (Line(
      points={{10,-40},{0,-40}},
      color={0,0,0}, smooth=Smooth.None));
  connect(springDamper.flange_b, inertia1.flange_a) annotation (Line(
      points={{30,-40},{40,-40}},
      color={0,0,0}, smooth=Smooth.None));
  connect(torque.support, fixed.flange) annotation (Line(
      points={{-50,-50},{-50,-70},{20,-70},{20,-80}},
      color={0,0,0}, smooth=Smooth.None));
  connect(damper.flange_b, inertia1.flange_b) annotation (Line(
      points={{60,-70},{70,-70},{70,-40},{60,-40}},
      color={0,0,0}, smooth=Smooth.None));
  connect(damper.flange_a, fixed.flange) annotation (Line(
      points={{40,-70},{20,-70},{20,-80}},
      color={0,0,0}, smooth=Smooth.None));
  connect(torque.flange, inertia.flange_a) annotation (Line(
      points={{-40,-40},{-20,-40}},
      color={0,0,0}, smooth=Smooth.None));
  connect(speedSensor.flange, inertia1.flange_b) annotation (Line(
      points={{70,-10},{70,-40},{60,-40}},
      color={0,0,0}, smooth=Smooth.None));
  connect(feedback.y, gain.u) annotation (Line(
      points={{61,40},{-18,40}},
      color={0,0,127}, smooth=Smooth.None));
  connect(gain.y, torque.tau) annotation (Line(
      points={{-41,40},{-80,40},{-80,-40},{-62,-40}},
      color={0,0,127}, smooth=Smooth.None));
  connect(trapezoid.y, feedback.u1) annotation (Line(
      points={{61,80},{90,80},{90,40},{78,40}},
      color={0,0,127}, smooth=Smooth.None));
  connect(speedSensor.w, feedback.u2) annotation (Line(
      points={{70,11},{70,32}},
      color={0,0,127}, smooth=Smooth.None));
  annotation (
    Diagram(graphics={
        Rectangle(
          extent={{-52,60},{94,20}}, lineColor={0,128,255},
          pattern=LinePattern.Dash, lineThickness=0.5),
        Rectangle(
          extent={{54,16},{84,-18}}, lineColor={128,255,0},
          pattern=LinePattern.Dash, lineThickness=0.5),
        Rectangle(
          extent={{-66,-22},{-36,-56}}, lineColor={255,0,128},
          pattern=LinePattern.Dash, lineThickness=0.5),
        Rectangle(
          extent={{-26,-22},{88,-98}}, lineColor={170,85,255},
          pattern=LinePattern.Dash, lineThickness=0.5)}),
    experiment(StopTime=4));
end FlatSystem;
