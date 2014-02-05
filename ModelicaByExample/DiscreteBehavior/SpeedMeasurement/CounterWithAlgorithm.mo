within ModelicaByExample.DiscreteBehavior.SpeedMeasurement;
model CounterWithAlgorithm "Count teeth in a given interval using an algorithm"
  extends BasicEquations.RotationalSMD.SecondOrderSystem;
  parameter Real sample_time(unit="s")=0.125;
  parameter Integer teeth=200;
  parameter Real tooth_angle(unit="rad")=2*3.14159/teeth;
  Real next_phi, prev_phi;
  Integer count;
  Real omega1_measured;
initial equation
  next_phi = phi1+tooth_angle;
  prev_phi = phi1-tooth_angle;
  count = 0;
algorithm
  when {phi1>=pre(next_phi),phi1<=pre(prev_phi)} then
    next_phi := phi1 + tooth_angle;
    prev_phi := phi1 - tooth_angle;
    count := pre(count) + 1;
  end when;
  when sample(0,sample_time) then
    omega1_measured := pre(count)*tooth_angle/sample_time;
    count :=0;
  end when;
end CounterWithAlgorithm;
