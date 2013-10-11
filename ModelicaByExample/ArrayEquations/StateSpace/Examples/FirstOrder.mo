within ModelicaByExample.ArrayEquations.StateSpace.Examples;
model FirstOrder "Represent der(x) = 1-x"
  extends LTI(nx=1,nu=1,A=[-1], B=[1]);
equation
  u = {1};
end FirstOrder;
