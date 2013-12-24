within ModelicaByExample.ArrayEquations.StateSpace;
model LTI
  "Equations written in ABCD form where matrices are also time-invariant"
  parameter Integer nx=0 "Number of states";
  parameter Integer nu=0 "Number of inputs";
  parameter Integer ny=0 "Number of outputs";
  parameter Real A[nx,nx]=fill(0,nx,nx);
  parameter Real B[nx,nu]=fill(0,nx,nu);
  parameter Real C[ny,nx]=fill(0,ny,nx);
  parameter Real D[ny,nu]=fill(0,ny,nu);
  parameter Real x0[nx]=fill(0,nx) "Initial conditions";
  Real x[nx] "State vector";
  Real u[nu] "Input vector";
  Real y[ny] "Output vector";
initial equation
  x = x0 "Specify initial conditions";
equation
  der(x) = A*x+B*u;
  y = C*x+D*u;
end LTI;
