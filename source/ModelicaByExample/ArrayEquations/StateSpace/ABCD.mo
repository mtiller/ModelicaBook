within ModelicaByExample.ArrayEquations.StateSpace;
partial model ABCD "Equations written in ABCD form"
  parameter Integer nx=0;
  parameter Integer ny=0;
  parameter Integer nu=0;
  Real Amat[nx,nx];
  Real Bmat[nx,nu];
  Real Cmat[ny,nx];
  Real Dmat[ny,nu];
  Real u[nu];
  Real x[nx];
  Real y[ny];
equation
  der(x) = Amat*x+Bmat*u;
  y = Cmat*x+Dmat*u;
end ABCD;
