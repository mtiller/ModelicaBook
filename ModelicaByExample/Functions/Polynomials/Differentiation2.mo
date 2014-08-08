within ModelicaByExample.Functions.Polynomials;
model Differentiation2 "Model that differentiates a function using derivative annotation"
  Real yf;
  Real yp;
  Real d_yf;
  Real d_yp;
equation
  yf = PolynomialWithDerivative(time, {1, -2, 2});
  yp = time^2-2*time+2;
  d_yf = der(yf);
  d_yp = der(yp);
end Differentiation2;
