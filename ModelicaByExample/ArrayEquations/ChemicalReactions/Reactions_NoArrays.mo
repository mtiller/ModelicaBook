within ModelicaByExample.ArrayEquations.ChemicalReactions;
model Reactions_NoArrays "Modeling a chemical reaction without arrays"
  Real cA;
  Real cB;
  Real cX;
  parameter Real k1=0.1;
  parameter Real k2=0.1;
  parameter Real k3=10;
initial equation
  cA = 1;
  cB = 1;
  cX = 0;
equation
  der(cA) = -k1*cA*cB + k2*cX;
  der(cB) = -k1*cA*cB + k2*cX - k3*cB*cX;
  der(cX) = k1*cA*cB - k2*cX - k3*cB*cX;
end Reactions_NoArrays;
