within ModelicaByExample.Functions.Nonlinearities;
function InverseQuadratic
  "An inverse of the quadratic function returning the positive root"
  input Real a;
  input Real b;
  input Real c;
  input Real y;
  output Real x;
algorithm
  x := sqrt(b*b - 4*a*(c - y))/(2*a);
end InverseQuadratic;
