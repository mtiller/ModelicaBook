within ModelicaByExample.DiscreteBehavior.Decay;
model Decay4
  Real x;
initial equation
  x = 2;
equation
  der(x) = if x>=1 then -1 else 1;
end Decay4;
