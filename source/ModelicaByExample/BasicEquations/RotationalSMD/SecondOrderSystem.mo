within ModelicaByExample.BasicEquations.RotationalSMD;
model SecondOrderSystem "A second order rotational system"
  type Angle=Real(unit="rad");
  type AngularVelocity=Real(unit="rad/s");
  type Inertia=Real(unit="N.s2/rad2");
  type Stiffness=Real(unit="N/rad");
  type Damping=Real(unit="N.s/rad");
  parameter Inertia J1=0.4;
  parameter Inertia J2=1.0;
  parameter Stiffness k1=11;
  parameter Stiffness k2=5;
  parameter Damping d1=0.2;
  parameter Damping d2=1.0;
  Angle phi1;
  Angle phi2;
  AngularVelocity omega1;
  AngularVelocity omega2;
initial equation
  phi1 = 0;
  phi2 = 1;
  omega1 = 0;
  omega2 = 0;
equation
  omega1 = der(phi1);
  omega2 = der(phi2);
  J1*der(omega1) = k1*(phi2-phi1)+d1*der(phi2-phi1);
  J2*der(omega2) = k1*(phi1-phi2)+d1*der(phi1-phi2)-k2*phi2-d2*der(phi2);
end SecondOrderSystem;
