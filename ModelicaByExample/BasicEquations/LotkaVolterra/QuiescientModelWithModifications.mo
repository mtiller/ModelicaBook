within ModelicaByExample.BasicEquations.LotkaVolterra;
model QuiescientModelWithModifications "Steady state model with modifications"
  extends ClassicModel(gamma=0.3, delta=0.01);
initial equation
  der(x) = 0;
  der(y) = 0;
end QuiescientModelWithModifications;
