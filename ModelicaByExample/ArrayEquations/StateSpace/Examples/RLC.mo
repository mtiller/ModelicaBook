within ModelicaByExample.ArrayEquations.StateSpace.Examples;
model RLC "State space version of an RLC circuit"
  parameter Real Vb=24;
  parameter Real L=1;
  parameter Real R=100;
  parameter Real C=1e-3;
  LTI abcd(nx=2, nu=1, ny=2, x0={0,0},
           A=[-1/(R*C), 1/C; -1/L, 0],
           B=[0; 1/L],
           C=[1/R, 0; -1/R, 1],
           D=[0; 0]);
equation
  /*
  der(V) = i_L/C-V/(R*C);
  der(i_L) = (Vb-V)/L;
  i_R = V/R;
  i_C = i_L-V/R;
  */
  abcd.u = {Vb};
end RLC;
