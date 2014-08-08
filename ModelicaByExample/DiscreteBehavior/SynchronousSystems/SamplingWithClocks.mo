within ModelicaByExample.DiscreteBehavior.SynchronousSystems;
model SamplingWithClocks "Using clocks to sub and super sample"
  Real x, y, z, w;
equation
  x = sample(time, Clock(1,10));
  y = sample(time, Clock(1,10));
  z = subSample(x, 2);
  w = superSample(x, 3);
end SamplingWithClocks;
