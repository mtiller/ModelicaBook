within ModelicaByExample.Architectures.ThermalControl.Bogus;
partial model Sensor_WithBus "Sensor subsystem interface using a bus"

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a room
    "Thermal connection to room"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ModelicaByExample.Architectures.ThermalControl.Bogus.PlantBus
    basicBus annotation (Placement(transformation(extent={{90,-10},{110,10}})));
end Sensor_WithBus;
