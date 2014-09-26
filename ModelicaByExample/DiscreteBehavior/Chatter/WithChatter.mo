within ModelicaByExample.DiscreteBehavior.Chatter;
model WithChatter
  Real x;
initial equation
  x = 2;
equation
  der(x) = if x>=1 then -1 else 1;
end WithChatter;
