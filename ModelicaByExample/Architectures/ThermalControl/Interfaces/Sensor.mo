within ModelicaByExample.Architectures.ThermalControl.Interfaces;
partial model Sensor "Sensor subsystem interface"
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a room
    "Thermal connection to room"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.RealOutput temperature "Measured temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={110,0})));
end Sensor;
