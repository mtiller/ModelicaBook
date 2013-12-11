within ModelicaByExample.DiscreteBehavior.Decay;
model Decay5
  Real x;
initial equation
  x = 1;
equation
  der(x) = if noEvent(x>=0) then -x else -x;
end Decay5;
