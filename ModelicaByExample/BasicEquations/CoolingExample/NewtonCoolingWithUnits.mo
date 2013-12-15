within ModelicaByExample.BasicEquations.CoolingExample;
model NewtonCoolingWithUnits "Cooling example with physical units"
  parameter Real T_inf(unit="K")=298.15 "Ambient temperature";
  parameter Real T0(unit="K")=363.15 "Initial temperature";
  parameter Real h(unit="W/K")=0.7 "Convective cooling coefficient";
  parameter Real m(unit="kg")=0.1 "Mass of thermal capacitance";
  parameter Real c_p(unit="J/(K.kg)")=1.2 "Specific heat";
  Real T(unit="K") "Temperature";
initial equation
  T = T0 "Specify initial value for T";
equation
  m*c_p*der(T) = h*(T_inf-T) "Newton's Law of Cooling";
end NewtonCoolingWithUnits;
