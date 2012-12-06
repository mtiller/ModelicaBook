model FirstOrderInitial
  Real x;
initial equation
  x = 0 "Used before simulation to compute initial values";
equation
  der(x) = -x;
end FirstOrderInitial;