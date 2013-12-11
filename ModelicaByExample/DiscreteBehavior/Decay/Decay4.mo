within ModelicaByExample.DiscreteBehavior.Decay;
model Decay4
  Real x;
initial equation
  x = 1;
equation
  der(x) = if x>=0 then -x else -x;
end Decay4;
