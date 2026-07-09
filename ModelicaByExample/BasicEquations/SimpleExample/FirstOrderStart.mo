within ModelicaByExample.BasicEquations.SimpleExample;
model FirstOrderStart "First order equation with fixed start value"
  Real x(start=x_start, fixed=true) "State variable";
  parameter Real x_start=2 "Start value";
equation
  der(x) = 1-x "Drives value of x toward 1.0";
end FirstOrderStart;
