within ModelicaByExample.DiscreteBehavior.Decay;
model Decay5
  Real x;
initial equation
  x = 2;
equation
  der(x) = if noEvent(x>=1) then -1 else 1;
end Decay5;
