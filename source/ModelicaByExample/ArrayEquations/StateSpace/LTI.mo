within ModelicaByExample.ArrayEquations.StateSpace;
model LTI
  "Equations written in ABCD form where matrices are linear, time-invariant"
  parameter Integer nx;
  parameter Integer ny;
  parameter Integer nu;
  parameter Real A[nx,nx]=fill(0,nx,nx);
  parameter Real B[nx,nu]=fill(0,nx,nu);
  parameter Real C[ny,nx]=fill(0,ny,nx);
  parameter Real D[ny,nu]=fill(0,ny,nu);
  parameter Real x0[nx]=fill(0,nx);
  Real u[nu];
  Real x[nx];
  Real y[ny];
initial equation
  x = x0;
equation
  der(x) = A*x+B*u;
  y = C*x+D*u;
end LTI;
