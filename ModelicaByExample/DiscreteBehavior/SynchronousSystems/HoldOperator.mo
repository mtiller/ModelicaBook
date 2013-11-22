within ModelicaByExample.DiscreteBehavior.SynchronousSystems;
model HoldOperator "Demonstrate the hold operator"
  Real x, y, z;
equation
  x = sample(time, Clock(0.1));
  y = sample(time, Clock(0.25));
  // z = x + y "Illegal";
  z = hold(x) + hold(y);
end HoldOperator;
