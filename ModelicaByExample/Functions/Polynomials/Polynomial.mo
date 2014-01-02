within ModelicaByExample.Functions.Polynomials;
function Polynomial "Create a generic polynomial from coefficients"
  input Real x;
  input Real c[:];
  output Real y;
protected
  Integer n = size(c,1);
algorithm
  y := c[1];
  for i in 2:n loop
    y := y*x + c[i];
  end for;
end Polynomial;
