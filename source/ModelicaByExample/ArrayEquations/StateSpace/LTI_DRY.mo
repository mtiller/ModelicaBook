within ModelicaByExample.ArrayEquations.StateSpace;
model LTI_DRY "LTI model size parameters are implicit"
  parameter Real A[:,nx];
  parameter Real B[nx,:];
  parameter Real C[:,nx];
  parameter Real D[ny,nu];
  parameter Real x0[nx];
  extends ABCD(nx=size(A,1),ny=size(C,1),nu=size(B,2));
initial equation
  x = x0;
equation
  Amat = A;
  Bmat = B;
  Cmat = C;
  Dmat = D;
end LTI_DRY;
