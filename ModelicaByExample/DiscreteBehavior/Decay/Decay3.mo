within ModelicaByExample.DiscreteBehavior.Decay;
model Decay3
  Real x;
initial equation
  x = 1;
equation
  der(x) = if noEvent(x>=0) then -sqrt(x) else 0;
end Decay3;
