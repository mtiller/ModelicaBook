within ModelicaByExample.Architectures.SensorComparison.Examples;
partial model SystemArchitecture_WithDefaults
  "A system architecture including default implementations"

  replaceable Implementation.BasicPlant plant constrainedby Interfaces.Plant
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-10,-50},{10,-30}})));
  replaceable Implementation.IdealActuator actuator constrainedby
    Interfaces.Actuator
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-50,-50},{-30,-30}})));
  replaceable Implementation.IdealSensor sensor constrainedby Interfaces.Sensor
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{30,-50},{50,-30}})));
  replaceable Implementation.ProportionalController controller constrainedby
    Interfaces.Controller
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable Modelica.Blocks.Sources.Trapezoid setpoint(period=1.0) constrainedby
    Modelica.Blocks.Interfaces.SO
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-60,30},{-40,50}})));
equation
  connect(actuator.shaft, plant.flange_a) annotation (Line(
      points={{-30,-40},{-10,-40}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(actuator.housing, plant.housing) annotation (Line(
      points={{-30,-46},{-10,-46}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(plant.flange_b, sensor.shaft) annotation (Line(
      points={{10,-40},{30,-40}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(controller.measured, sensor.w) annotation (Line(
      points={{10,0},{70,0},{70,-40},{51,-40}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(controller.command, actuator.tau) annotation (Line(
      points={{-11,0},{-70,0},{-70,-40},{-52,-40}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(setpoint.y, controller.setpoint) annotation (Line(
      points={{-39,40},{0,40},{0,12}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
end SystemArchitecture_WithDefaults;
