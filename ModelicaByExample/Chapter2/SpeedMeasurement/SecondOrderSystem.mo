within ModelicaByExample.Chapter2.SpeedMeasurement;
model SecondOrderSystem "A second order mechanical system"
  parameter Real J(unit="kg.m2")=1.0 "Rotational inertia";
  Real tau(unit="N.m") "Torque";
  Real alpha(unit="rad/s2") "Angular acceleration";
  Real omega(unit="rad/s");
  Real phi(unit="rad");
equation
  der(phi) = omega;
  der(omega) = alpha;
  tau = J*alpha "Euler's First Law of Motion";
  tau = 2.0*Modelica.Math.sin(5*time)+1.0;
end SecondOrderSystem;
