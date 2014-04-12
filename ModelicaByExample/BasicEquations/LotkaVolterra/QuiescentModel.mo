within ModelicaByExample.BasicEquations.LotkaVolterra;
model QuiescentModel "Find steady-state solutions to LotkaVolterra equations"
  parameter Real alpha=0.1;
  parameter Real beta=0.02;
  parameter Real gamma=0.4;
  parameter Real delta=0.02;
  Real x;
  Real y;
initial equation
  der(x) = 0;
  der(y) = 0;
equation
  der(x) = x*(alpha-beta*y);
  der(y) = -y*(gamma-delta*x);
end QuiescentModel;
