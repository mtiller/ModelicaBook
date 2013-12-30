within ModelicaByExample.ArrayEquations.ChemicalReactions;
model Reactions_EnumMatrix "Modeling a chemical reaction with matrix equations"
  type Species = enumeration(
      A,
      B,
      X);
  Real C[Species] "Species concentrations";
  parameter Real k[3] = {0.1, 0.1, 10};
  constant Species A = Species.A;
  constant Species B = Species.B;
  constant Species X = Species.X;
initial equation
  C[A] = 1.0;
  C[B] = 1.0;
  C[X] = 0.0;
equation
  der(C) = [-k[1]*C[B], 0,          k[2];
            -k[1]*C[B], -k[3]*C[X], k[2];
            k[1]*C[B],  -k[3]*C[X], -k[2]]*C;
end Reactions_EnumMatrix;
