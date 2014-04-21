within ModelicaByExample.Architectures.ThermalControl.Architectures;
partial model ExpandableArchitecture
  "A thermal architecture using an expandable bus"

  replaceable Interfaces.PlantModel plant
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable Interfaces.Actuator_WithExpandableBus actuator
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  replaceable Interfaces.ControlSystem_WithExpandableBus controller
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  replaceable Interfaces.Sensor_WithExpandableBus sensor
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
equation
  connect(actuator.furnace, plant.furnace) annotation (Line(
      points={{-30,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(controller.bus, actuator.bus) annotation (Line(
      points={{0,50},{0,28},{-60,28},{-60,0},{-50,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sensor.room, plant.room) annotation (Line(
      points={{30,0},{10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sensor.bus, controller.bus) annotation (Line(
      points={{50,0},{60,0},{60,28},{0,28},{0,50}},
      color={0,0,0},
      smooth=Smooth.None));
end ExpandableArchitecture;
