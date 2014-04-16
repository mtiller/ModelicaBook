within ModelicaByExample.Functions.Polynomials;
model EvaluationTest1 "Model that evaluates a polynomial"
  Real yf;
  Real yp;
equation
  yf = Polynomial(time, {1, -2, 2});
  yp = time^2-2*time+2;
end EvaluationTest1;
