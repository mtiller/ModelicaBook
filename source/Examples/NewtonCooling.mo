model NewtonCooling
  import Modelica.SIunits.*;
  parameter Mass m "Mass of coffee cup";
  parameter SpecificHeat c_p "Specific heat of coffee cup";
  parameter HeatTransferCoefficient h "Heat transfer coefficient";
  parameter Area A "Surface area";
  parameter Temperature T_ref "Ambient temperature";
  Temperature T "Coffee cup temperature";
equation
  m*c_p*der(T) = -h*A*(T-T_ref) "Newton's Law of Cooling";
end NewtonCooling;
