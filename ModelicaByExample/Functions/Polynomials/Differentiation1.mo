within ModelicaByExample.Functions.Polynomials;
model Differentiation1 "Model that differentiates a function"
  Real yf;
  Real yp;
  Real d_yf;
  Real d_yp;
equation
  yf = Polynomial(time, {1, -2, 2});
  yp = time^2-2*time+2;
  d_yf = der(yf); // How to compute?
  d_yp = der(yp);
end Differentiation1;
