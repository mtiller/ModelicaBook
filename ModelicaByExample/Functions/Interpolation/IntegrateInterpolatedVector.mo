within ModelicaByExample.Functions.Interpolation;
model IntegrateInterpolatedVector "Exercises the InterpolateVector"
  Real x;
  Real y;
  Real z;
equation
  x = time;
  y = InterpolateVector(x, [0.0, 0.0; 2.0, 0.0; 4.0, 2.0; 6.0, 0.0; 8.0, 0.0]);
  der(z) = y;
  annotation (experiment(StopTime=6));
end IntegrateInterpolatedVector;
