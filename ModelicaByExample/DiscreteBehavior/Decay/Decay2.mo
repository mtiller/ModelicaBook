within ModelicaByExample.DiscreteBehavior.Decay;
model Decay2
  Real x;
initial equation
  x = 1;
equation
  der(x) = if x>=0 then -sqrt(x) else 0;
end Decay2;
