within ModelicaByExample.Architectures.ThermalControl.Interfaces;
partial model Actuator "Actuator subsystem interface"

  Modelica.Blocks.Interfaces.RealInput heat "Heating command" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        origin={-120,0})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b furnace
    "Connection point for the furnace"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
end Actuator;
