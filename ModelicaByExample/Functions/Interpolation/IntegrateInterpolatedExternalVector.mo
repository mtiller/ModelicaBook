within ModelicaByExample.Functions.Interpolation;
model IntegrateInterpolatedExternalVector
  "Exercises the InterpolateExternalVector"
  parameter VectorTable vector = VectorTable(ybar=[0.0, 0.0;
                                                   2.0, 0.0;
                                                   4.0, 2.0;
                                                   6.0, 0.0;
                                                   8.0, 0.0]);
  Real x;
  Real y;
  Real z;
equation
  x = time;
  y = InterpolateExternalVector(x, vector);
  der(z) = y;
  annotation (experiment(StopTime=6));
end IntegrateInterpolatedExternalVector;
