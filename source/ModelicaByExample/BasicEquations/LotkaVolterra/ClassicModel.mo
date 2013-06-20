within ModelicaByExample.BasicEquations.LotkaVolterra;
model ClassicModel "This is the typical equation-oriented model"
  parameter Real alpha=0.1;
  parameter Real beta=0.02;
  parameter Real gamma=0.4;
  parameter Real delta=0.02;
  parameter Real x0=10;
  parameter Real y0=10;
  Real x(start=x0);
  Real y(start=y0);
equation
  der(x) = x*(alpha-beta*y);
  der(y) = -y*(gamma-delta*x);
end ClassicModel;
