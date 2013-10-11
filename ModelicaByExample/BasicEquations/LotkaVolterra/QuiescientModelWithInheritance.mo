within ModelicaByExample.BasicEquations.LotkaVolterra;
model QuiescientModelWithInheritance "Steady state model with inheritance"
  extends ClassicModel;
initial equation
  der(x) = 0;
  der(y) = 0;
end QuiescientModelWithInheritance;
