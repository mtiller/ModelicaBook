within ModelicaByExample.BasicEquations.LotkaVolterra;
model ComplexInitialization "Complex initial conditions"
  extends ClassicModel;
initial equation
  der(x) = 2*y;
  x/2 + y^2 = 5;
end ComplexInitialization;
