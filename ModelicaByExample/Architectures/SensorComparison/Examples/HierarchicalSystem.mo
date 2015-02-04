within ModelicaByExample.Architectures.SensorComparison.Examples;
model HierarchicalSystem "Organzing components into subsystems"
  Implementation.BasicPlant plant
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Implementation.IdealActuator actuator
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Implementation.IdealSensor sensor
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Implementation.ProportionalController controller
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Trapezoid setpoint(period=1.0)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
equation
  connect(actuator.shaft, plant.flange_a) annotation (Line(
      points={{-30,-30},{-10,-30}},
      color={0,0,0},
      pattern=LinePattern.None));
  connect(actuator.housing, plant.housing) annotation (Line(
      points={{-30,-36},{-10,-36}},
      color={0,0,0},
      pattern=LinePattern.None));
  connect(plant.flange_b, sensor.shaft) annotation (Line(
      points={{10,-30},{20,-30}},
      color={0,0,0},
      pattern=LinePattern.None));
  connect(controller.command, actuator.tau) annotation (Line(
      points={{-11,0},{-70,0},{-70,-30},{-52,-30}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(sensor.w, controller.measured) annotation (Line(
      points={{41,-30},{60,-30},{60,0},{10,0}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(setpoint.y, controller.setpoint) annotation (Line(
      points={{-29,30},{0,30},{0,12}},
      color={0,0,127},
      pattern=LinePattern.None));
end HierarchicalSystem;
