within ModelicaByExample.ArrayEquations.StateSpace.Examples;
model FirstOrder_Compact "Represent der(x) = 1-x"
  extends LTI(nx=1,nu=1,A=[-1], B=[1], u={1});
end FirstOrder_Compact;
