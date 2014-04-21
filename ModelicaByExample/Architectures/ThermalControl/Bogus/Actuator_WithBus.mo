within ModelicaByExample.Architectures.ThermalControl.Bogus;
partial model Actuator_WithBus "Actuator subsystem interface with bus"

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b furnace
    "Connection point for the furnace"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  ModelicaByExample.Architectures.ThermalControl.Bogus.PlantBus
    basicBus
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
end Actuator_WithBus;
