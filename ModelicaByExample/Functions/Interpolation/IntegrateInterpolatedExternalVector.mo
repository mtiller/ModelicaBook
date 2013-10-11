within ModelicaByExample.Functions.Interpolation;
model IntegrateInterpolatedExternalVector
  "Exercises the InterpolateExternalVector"
  parameter VectorTable vector = VectorTable(ybar=[0.0, 0.0; 2.0, 0.0; 4.0, 2.0; 6.0, 0.0; 8.0, 0.0]);
  Real x;
  Real y;
equation
  x = time;
  der(y) = InterpolateExternalVector(x, vector);
  annotation (experiment(StopTime=6), __Dymola_experimentSetupOutput);
end IntegrateInterpolatedExternalVector;
