within ModelicaByExample.Components.HeatTransfer.Examples;
model CoolingToAmbient "A model using convection to an ambient condition"

  ThermalCapacitance cap(C=0.12, T0(displayUnit="K") = 363.15)
    "Thermal capacitance component"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  ConvectionToAmbient conv(h=0.7, A=1.0, T_amb=298.15)
    "Convection to an ambient temprature"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(cap.node, conv.port_a) annotation (Line(
      points={{-20,0},{20,0}},
      color={191,0,0},
      smooth=Smooth.None));
end CoolingToAmbient;
