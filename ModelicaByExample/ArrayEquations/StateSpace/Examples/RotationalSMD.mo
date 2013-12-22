within ModelicaByExample.ArrayEquations.StateSpace.Examples;
model RotationalSMD
  "State space version of a rotationals spring-mass-damper system"
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
                     k1/J2, -k1/J2-k2/J2, d1/J2, -d1/J2-d2/J2],
                  B=fill(0, 4, 0), C=fill(0, 0, 4),
                  D=fill(0, 0, 0));
equation
  /*
  omega1 = der(phi1);
  omega2 = der(phi2);
  J1*der(omega1) = k1*(phi2-phi1)+d1*der(phi2-phi1);
  J2*der(omega2) = k1*(phi1-phi2)+d1*der(phi1-phi2)-k2*phi2-d1*der(phi2);
  */
  u = fill(0, 0);
end RotationalSMD;
