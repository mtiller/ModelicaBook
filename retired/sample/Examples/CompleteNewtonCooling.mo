model CompleteNewtonCooling
  import Modelica.SIunits.*;
  parameter Mass m=1.0 "Mass of coffee + cup";
  parameter SpecificHeat c_p=2.0 "Specific heat of coffee + cup";
  parameter HeatTransferCoefficient h=0.5 "Heat transfer coefficient";
  parameter Area A=0.75 "Surface area";
  parameter Temperature T_ref=300 "Ambient temperature";
  Temperature T "Coffee temperature";
equation
  m*c_p*der(T) = -h*A*(T-T_ref) "Newton's Law of Cooling";
end CompleteNewtonCooling;
