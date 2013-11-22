within ModelicaByExample.DiscreteBehavior.SynchronousSystems;
model IndependentSampling "Sampling independently"
  Real x "Sampled at 10Hz via one method";
  Real y "Sampled at 10Hz via another method";
  Real e "Error between x and y";
  Real next_time "Next sample for y";
equation
  when sample(0,0.1) then
    x = time;
  end when;

  when {initial(), time>pre(next_time)} then
    y = time;
    next_time = pre(next_time)+0.1;
  end when;
  e = x-y;
end IndependentSampling;
