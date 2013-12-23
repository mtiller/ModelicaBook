within ModelicaByExample.ArrayEquations.StateSpace;
partial model ABCD "Equations written in (potentially non-linear) ABCD form"
  parameter Integer nx;
  parameter Integer ny;
  parameter Integer nu;
  parameter Real x0[nx]=fill(0,nx);
  Real A[nx,nx];
  Real B[nx,nu];
  Real C[ny,nx];
  Real D[ny,nu];
  Real u[nu];
  Real x[nx];
  Real y[ny];
initial equation
  x = x0;
equation
  der(x) = A*x+B*u;
  y = C*x+D*u;
end ABCD;
