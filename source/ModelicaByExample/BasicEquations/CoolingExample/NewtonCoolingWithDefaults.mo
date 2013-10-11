within ModelicaByExample.BasicEquations.CoolingExample;
model NewtonCoolingWithDefaults "Cooling example with default parameter values"
  parameter Real T_inf=25 "Ambient temperature";
  parameter Real T0=90 "Initial temperature";
  parameter Real h=0.7 "Convective cooling coefficient";
  parameter Real m=0.1 "Mass of thermal capacitance";
  parameter Real c_p=1.2 "Specific heat";
  Real T "Temperature";
initial equation
  T = T0 "Specify initial value for T";
equation
  m*c_p*der(T) = h*(T_inf-T) "Newton's Law of Cooling";
end NewtonCoolingWithDefaults;
