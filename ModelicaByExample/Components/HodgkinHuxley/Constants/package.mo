within ModelicaByExample.Components.HodgkinHuxley;
package Constants "Various physical constants of cell membranes"
  constant Modelica.SIunits.Voltage E_Na = 50e-3 "Sodium potential";
  constant Modelica.SIunits.Voltage E_K = -77e-3 "Potassium potential";
  constant Modelica.SIunits.Voltage E_L = -54.4e-3 "Leakage potential";
  constant MembraneCapacitance C_m=1e-2 "Nominal membrane capacitance";
  constant MembraneConductance G_Na=1200 "Sodium conductance";
  constant MembraneConductance G_K=360 "Potassium conductance";
  constant MembraneConductance G_L=3 "Leakage conductance";
end Constants;
