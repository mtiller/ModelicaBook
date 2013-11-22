within ModelicaByExample.DiscreteBehavior.SynchronousSystems;
model ZTransforms "Using der with discrete signals"
  Real x;
  Real v;
  Real a;
equation
  der(x) = v;
  der(v) = a;
  a = sample(sin(time), Clock(Clock(0.1), solverMethod="ExplicitEuler"));
end ZTransforms;
