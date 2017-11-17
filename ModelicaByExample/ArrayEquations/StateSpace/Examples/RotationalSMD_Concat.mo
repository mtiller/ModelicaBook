within ModelicaByExample.ArrayEquations.StateSpace.Examples;
model RotationalSMD_Concat
  "State space version of a rotationals spring-mass-damper system using concatenation"
  parameter Real J1=0.4;
  parameter Real J2=1.0;
  parameter Real c1=11;
  parameter Real c2=5;
  parameter Real d1=0.2;
  parameter Real d2=1.0;
  parameter Real S[2,2] = [-1/J1, 1/J1; 1/J2, -1/J2];
  extends LTI(nx=4, nu=0, ny=0, x0={0, 1, 0, 0},
                  A=[zeros(2, 2), identity(2);
                     c1*S+[0,0;0,-c2/J2], d1*S+[0,0;0,-d2/J2]],
                  B=fill(0, 4, 0), C=fill(0, 0, 4),
                  D=fill(0, 0, 0));
equation
  u = fill(0, 0);
end RotationalSMD_Concat;
