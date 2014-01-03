within ModelicaByExample.Functions.Nonlinearities;
model ImplicitEvaluation
  "Model that requires the inverse of the quadratic function"
  parameter Real y_guess=2;
  Real y(start=y_guess);
equation
  time+1 = Quadratic(2.0, 3.0, 1.0, y);
end ImplicitEvaluation;
