within ModelicaByExample.ArrayEquations.StateSpace.Examples;
model NewtonCooling "NewtonCooling model in state space form"
  parameter Real T_inf=27.5 "Ambient temperature";
  parameter Real T0=20 "Initial temperature";
  parameter Real hA=0.7 "Convective cooling coefficient * area";
  parameter Real m=0.1 "Mass of thermal capacitance";
  parameter Real c_p=1.2 "Specific heat";
  extends LTI(nx=1,nu=1,A=[-hA/(m*c_p)],B=[hA/(m*c_p)],x0={20});
equation
  u = {T_inf};
end NewtonCooling;
