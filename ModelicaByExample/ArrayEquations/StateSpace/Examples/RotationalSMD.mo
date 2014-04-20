within ModelicaByExample.ArrayEquations.StateSpace.Examples;
model RotationalSMD
  "State space version of a rotational spring-mass-damper system"
  parameter Real J1=0.4;
  parameter Real J2=1.0;
  parameter Real k1=11;
  parameter Real k2=5;
  parameter Real d1=0.2;
  parameter Real d2=1.0;
  extends LTI(nx=4, nu=0, ny=0, x0={0, 1, 0, 0},
                  A=[0, 0, 1, 0;
                     0, 0, 0, 1;
                     -k1/J1, k1/J1, -d1/J1, d1/J1;
                     k1/J2, -k1/J2-k2/J2, d1/J2, -d1/J2-d2/J2]);
equation
  u = fill(0, 0);
end RotationalSMD;
