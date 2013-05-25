within ModelicaByExample.Chapter1.LotkaVolterra;
model ComplexInitialization "Complex initial conditions"
  parameter Real alpha=0.1;
  parameter Real beta=0.02;
  parameter Real gamma=0.4;
  parameter Real delta=0.02;
  parameter Real x0=10;
  parameter Real y0=10;
  Real x(start=1);
  Real y(start=1);
initial equation
  der(x) = 2*y;
  x/2 + y^2 = 5;
equation
  der(x) = x*(alpha-beta*y);
  der(y) = -y*(gamma-delta*x);
end ComplexInitialization;
