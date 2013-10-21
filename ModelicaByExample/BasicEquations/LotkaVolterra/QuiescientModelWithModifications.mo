within ModelicaByExample.BasicEquations.LotkaVolterra;
model QuiescientModelWithModifications "Steady state model with modifications"
  extends QuiescientModelWithInheritance(gamma=0.3, delta=0.01);
end QuiescientModelWithModifications;
