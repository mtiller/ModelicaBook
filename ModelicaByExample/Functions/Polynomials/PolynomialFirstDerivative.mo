within ModelicaByExample.Functions.Polynomials;
function PolynomialFirstDerivative
  "First derivative of the function Polynomial"
  input Real x;
  input Real c[:];
  input Real x_der;
  input Real c_der[size(c,1)];
  output Real y_der;
protected
  Integer n = size(c,1);
  Real c_diff[n-1] = {(n-i)*c[i] for i in 1:n-1};
algorithm
  y_der :=PolynomialWithDerivative(x, c_diff)*x_der +
          PolynomialWithDerivative(x, c_der);
end PolynomialFirstDerivative;
