within ModelicaByExample.Components.HeatTransfer.Examples;
model Adiabatic "A model without any heat transfer"
  ThermalCapacitance cap(C=0.12, T0(displayUnit="K") = 363.15)
    "Thermal capacitance component"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
end Adiabatic;
