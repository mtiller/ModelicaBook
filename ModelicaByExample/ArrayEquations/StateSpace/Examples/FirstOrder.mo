within ModelicaByExample.ArrayEquations.StateSpace.Examples;
model FirstOrder "Represent der(x) = 1-x in ABCD form"
  extends ABCD(nx=1,nu=1,ny=0);
equation
  Amat = [-1];
  Bmat = [1];
  Cmat = fill(0, 0, 1);
  Dmat = fill(0, 0, 1);
  u = {1};
end FirstOrder;
