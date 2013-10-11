within ModelicaByExample.ArrayEquations.ChemicalReactions;
model Reactions_Array "Modeling a chemical reaction with arrays"
  Real C[3];
  parameter Real k[3] = {0.1, 0.1, 10};
initial equation
  C = {1, 1, 0};
equation
  der(C) = {-k[1]*C[1]*C[2] + k[2]*C[3],
            -k[1]*C[1]*C[2] + k[2]*C[3] - k[3]*C[2]*C[3],
            k[1]*C[1]*C[2] - k[2]*C[3] - k[3]*C[2]*C[3]};
end Reactions_Array;
