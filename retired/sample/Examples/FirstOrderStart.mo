model FirstOrderStart
  Real x(start=10);
equation
  der(x) = -x;
end FirstOrderStart;