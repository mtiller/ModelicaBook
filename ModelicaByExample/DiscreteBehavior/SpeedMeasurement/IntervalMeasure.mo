within ModelicaByExample.DiscreteBehavior.SpeedMeasurement;
model IntervalMeasure "Measure interval between teeth"
  extends BasicEquations.RotationalSMD.SecondOrderSystem;
  parameter Integer teeth=200;
  parameter Real tooth_angle(unit="rad")=2*3.14159/teeth;
  Real next_phi, prev_phi;
  Real last_time;
  Real omega1_measured;
initial equation
  next_phi = phi1+tooth_angle;
  prev_phi = phi1-tooth_angle;
  last_time = time;
equation
  when {phi1>=pre(next_phi),phi1<=pre(prev_phi)} then
    omega1_measured = tooth_angle/(time-pre(last_time));
    next_phi = phi1+tooth_angle;
    prev_phi = phi1-tooth_angle;
    last_time = time;
  end when;
end IntervalMeasure;
