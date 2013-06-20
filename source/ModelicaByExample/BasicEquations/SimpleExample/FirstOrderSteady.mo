within ModelicaByExample.BasicEquations.SimpleExample;
model FirstOrderSteady
  "First order equation with steady state initial condition"
  Real x "State variable";
initial equation
  der(x) = 0 "Initialize the system in steady state";
equation
  der(x) = 1-x "Drive x toward 1.0 when time<=0.5";
end FirstOrderSteady;
