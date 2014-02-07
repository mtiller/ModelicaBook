within ModelicaByExample.Components.HeatTransfer.Examples;
model Cooling "A model using generic convection to ambient conditions"
  ThermalCapacitance cap(C=0.12, T0(displayUnit="K") = 363.15)
    "Thermal capacitance component"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Convection convection(h=0.7, A=1.0)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  AmbientCondition amb(T_amb(displayUnit="K") = 298.15)
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
equation
  connect(convection.port_a, cap.node) annotation (Line(
      points={{10,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(amb.node, convection.port_b) annotation (Line(
      points={{60,0},{30,0}},
      color={191,0,0},
      smooth=Smooth.None));
end Cooling;
