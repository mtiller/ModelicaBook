within ModelicaByExample.Functions.Interpolation;
model IntegrateInterpolatedVector "Exercises the InterpolateVector"
  Real x;
  Real y;
equation
  x = time;
  der(y) = InterpolateVector(x, [0.0, 0.0; 2.0, 0.0; 4.0, 2.0; 6.0, 0.0; 8.0, 0.0]);
  annotation (experiment(StopTime=6), __Dymola_experimentSetupOutput);
end IntegrateInterpolatedVector;
