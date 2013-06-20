within ModelicaByExample.BasicEquations.SimpleExample;
model FirstOrder
  Real x;
equation
  der(x) = 1-x;
end FirstOrder;
