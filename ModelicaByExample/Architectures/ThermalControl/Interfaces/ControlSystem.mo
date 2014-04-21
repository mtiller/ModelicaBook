within ModelicaByExample.Architectures.ThermalControl.Interfaces;
partial model ControlSystem "Control system interface"
  Modelica.Blocks.Interfaces.RealInput temperature "Measured temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,0})));
  Modelica.Blocks.Interfaces.RealOutput heat "Heating command" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-110,0})));
end ControlSystem;
