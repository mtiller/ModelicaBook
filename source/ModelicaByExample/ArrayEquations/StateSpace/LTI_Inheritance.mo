within ModelicaByExample.ArrayEquations.StateSpace;
partial model LTI_Inheritance "LTI model using inheritance"
  parameter Real A[nx,nx]=fill(0,nx,nx);
  parameter Real B[nx,nu]=fill(0,nx,nu);
  parameter Real C[ny,nx]=fill(0,ny,nx);
  parameter Real D[ny,nu]=fill(0,ny,nu);
  parameter Real x0[nx]=fill(0,nx);
  extends ABCD;
initial equation
  x = x0;
equation
  Amat = A;
  Bmat = B;
  Cmat = C;
  Dmat = D;
end LTI_Inheritance;
