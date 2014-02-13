within ModelicaByExample.Architectures.ThermalControl.Architectures;
partial model BaseArchitecture "A basic thermal architecture"
  replaceable Interfaces.PlantModel plant
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable Interfaces.ControlSystem controller
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  replaceable Interfaces.Sensor sensor
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  replaceable Interfaces.Actuator actuator
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(plant.room, sensor.room) annotation (Line(
      points={{10,0},{32,0}},
      color={191,0,0}, smooth=Smooth.None));
  connect(sensor.temperature, controller.temperature) annotation (Line(
      points={{53,0},{70,0},{70,40},{12,40}},
      color={0,0,127}, smooth=Smooth.None));
  connect(actuator.furnace, plant.furnace) annotation (Line(
      points={{-30,0},{-10,0}},
      color={191,0,0}, smooth=Smooth.None));
  connect(controller.heat, actuator.heat) annotation (Line(
      points={{-11,40},{-70,40},{-70,0},{-52,0}},
      color={0,0,127}, smooth=Smooth.None));
end BaseArchitecture;
