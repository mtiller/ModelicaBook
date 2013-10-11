within ModelicaByExample.Components.HodgkinHuxley.Components;
model MembraneCapacitance "Modeling membrane capacitance"
  extends Modelica.Electrical.Analog.Basic.Capacitor(final C=Constants.C_m*A);
  parameter Modelica.SIunits.Area A "Membrane area";
end MembraneCapacitance;
