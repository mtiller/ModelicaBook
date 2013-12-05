within ModelicaByExample.DiscreteBehavior.Decay;
model Decay1
  Real x;
initial equation
  x = 1;
equation
  der(x) = -sqrt(x);
end Decay1;
