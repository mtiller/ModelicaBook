within ModelicaByExample.Architectures.ThermalControl.Interfaces;
partial model PlantModel "Plant subsystem interface model"
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a room "Room temperature"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b furnace
    "Connection point for the furnace"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
end PlantModel;
