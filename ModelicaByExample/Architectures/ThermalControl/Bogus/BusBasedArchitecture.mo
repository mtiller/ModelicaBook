within ModelicaByExample.Architectures.ThermalControl.Bogus;
partial model BusBasedArchitecture
  "A thermal architecture with bus connectivity"
  replaceable Interfaces.PlantModel plant
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable
    ModelicaByExample.Architectures.ThermalControl.Bogus.ControlSystem_WithBus
    controller annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  replaceable
    ModelicaByExample.Architectures.ThermalControl.Bogus.Actuator_WithBus
    actuator annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  replaceable
    ModelicaByExample.Architectures.ThermalControl.Bogus.Sensor_WithBus sensor
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
equation
  connect(actuator.furnace, plant.furnace) annotation (Line(
      points={{-30,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(plant.room, sensor.room) annotation (Line(
      points={{10,0},{30,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(actuator.basicBus, controller.basicBus) annotation (Line(
      points={{-50,0},{-60,0},{-60,28},{0,28},{0,50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sensor.basicBus, controller.basicBus) annotation (Line(
      points={{50,0},{60,0},{60,28},{0,28},{0,50}},
      color={0,0,0},
      smooth=Smooth.None));
end BusBasedArchitecture;
