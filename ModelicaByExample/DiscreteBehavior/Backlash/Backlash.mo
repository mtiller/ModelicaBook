within ModelicaByExample.DiscreteBehavior.Backlash;
model Backlash "Implementing the behavior of a backlash using a 'stiff spring'"
  type Angle=Real(unit="rad");
  type AngularVelocity=Real(unit="rad/s");
  type Inertia=Real(unit="kg.m2");
  type Stiffness=Real(unit="N.m/rad");
  type Damping=Real(unit="N.m.s/rad");
  parameter Angle phi1_init = 0;
  parameter Angle phi2_init = 0;
  parameter AngularVelocity omega1_init = 5;
  parameter AngularVelocity omega2_init = 0;
  parameter Angle b=0.5 "Total backlash angle";
  parameter Inertia J1=0.4;
  parameter Inertia J2=1.0;
  parameter Stiffness k1=11;
  parameter Stiffness k2=5;
  parameter Stiffness kb=1000;
  parameter Damping d1=0.2;
  parameter Damping d2=1.0;
  Angle phi1;
  Angle phi2;
  Angle dphi = phi2-phi1;
  AngularVelocity omega1;
  AngularVelocity omega2;
initial equation
  phi1 = phi1_init;
  phi2 = phi2_init;
  omega1 = omega1_init;
  omega2 = omega2_init;
equation
  omega1 = der(phi1);
  omega2 = der(phi2);
  J1*der(omega1) = kb*sign(dphi)*max(abs(dphi)-b/2,0)+k1*(dphi)+d1*der(dphi);
  J2*der(omega2) = kb*sign(-dphi)*max(abs(dphi)-b/2,0)-k1*dphi-d1*der(dphi)-k2*phi2-d2*der(phi2);
end Backlash;
