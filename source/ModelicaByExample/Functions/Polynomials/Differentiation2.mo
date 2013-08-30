within ModelicaByExample.Functions.Polynomials;
model Differentiation2 "Model that differentiates a function using smooth"
  Real yf;
  Real yp;
  Real d_yf;
  Real d_yp;
  Real z;
equation
  z = Polynomial(time, {2, 2});
  yf = smooth(2, z);
  yp = 2*time+2;
  d_yf = der(yf);
  d_yp = der(yp);
end Differentiation2;
