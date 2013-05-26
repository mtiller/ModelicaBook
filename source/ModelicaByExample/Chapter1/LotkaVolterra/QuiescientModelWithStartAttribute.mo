within ModelicaByExample.Chapter1.LotkaVolterra;
model QuiescientModelWithStartAttribute
  "Find steady-state solutions to LotkaVolterra equations"
  parameter Real alpha=0.1;
  parameter Real beta=0.02;
  parameter Real gamma=0.4;
  parameter Real delta=0.02;
  parameter Real x0=10;
  parameter Real y0=10;
  Real x(start=x0);
  Real y(start=y0);
initial equation
  der(x) = 0;
  der(y) = 0;
equation
  der(x) = x*(alpha-beta*y);
  der(y) = -y*(gamma-delta*x);
end QuiescientModelWithStartAttribute;
